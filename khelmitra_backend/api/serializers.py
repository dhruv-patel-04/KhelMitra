from rest_framework import serializers
from django.contrib.auth.models import User
from django.contrib.auth.password_validation import validate_password
from .models import Sport, Team, Match, Score, UserProfile


class UserSerializer(serializers.ModelSerializer):
    """Serializer for User model"""
    password = serializers.CharField(write_only=True, required=True, validators=[validate_password])
    password2 = serializers.CharField(write_only=True, required=True)

    class Meta:
        model = User
        fields = ('id', 'username', 'password', 'password2', 'email', 'first_name', 'last_name')
        extra_kwargs = {
            'first_name': {'required': True},
            'last_name': {'required': True},
            'email': {'required': True}
        }

    def validate(self, attrs):
        if attrs['password'] != attrs['password2']:
            raise serializers.ValidationError({"password": "Password fields didn't match."})
        return attrs

    def create(self, validated_data):
        validated_data.pop('password2')
        user = User.objects.create(
            username=validated_data['username'],
            email=validated_data['email'],
            first_name=validated_data['first_name'],
            last_name=validated_data['last_name']
        )
        user.set_password(validated_data['password'])
        user.save()
        
        # Create user profile
        UserProfile.objects.create(user=user)
        
        return user


class UserProfileSerializer(serializers.ModelSerializer):
    """Serializer for UserProfile model"""
    username = serializers.CharField(source='user.username', read_only=True)
    email = serializers.EmailField(source='user.email', required=False)
    full_name = serializers.SerializerMethodField()
    is_referee = serializers.BooleanField(read_only=True)
    
    class Meta:
        model = UserProfile
        fields = ('id', 'username', 'email', 'full_name', 'profile_picture', 'favorite_teams', 'favorite_sports', 'is_referee')
    
    def get_full_name(self, obj):
        return f"{obj.user.first_name} {obj.user.last_name}"
    
    def update(self, instance, validated_data):
        # Handle user fields
        user_data = {}
        if 'user' in validated_data:
            user_data = validated_data.pop('user')
        
        # Handle full_name field from request data
        if 'full_name' in self.initial_data:
            full_name = self.initial_data['full_name']
            name_parts = full_name.strip().split(' ', 1)
            user_data['first_name'] = name_parts[0] if name_parts else ''
            user_data['last_name'] = name_parts[1] if len(name_parts) > 1 else ''
        
        # Update user fields
        if user_data:
            user = instance.user
            for attr, value in user_data.items():
                setattr(user, attr, value)
            user.save()
        
        # Update profile fields
        for attr, value in validated_data.items():
            setattr(instance, attr, value)
        instance.save()
        
        return instance


class SportSerializer(serializers.ModelSerializer):
    """Serializer for Sport model"""
    class Meta:
        model = Sport
        fields = ('id', 'name', 'description', 'icon')


class TeamSerializer(serializers.ModelSerializer):
    """Serializer for Team model"""
    sport_name = serializers.CharField(source='sport.name', read_only=True)
    
    class Meta:
        model = Team
        fields = ('id', 'name', 'logo', 'sport', 'sport_name', 'description', 'created_at')


class ScoreSerializer(serializers.ModelSerializer):
    """Serializer for Score model"""
    class Meta:
        model = Score
        fields = ('id', 'match', 'team_a_score', 'team_b_score', 'period', 'timestamp')


class MatchListSerializer(serializers.ModelSerializer):
    """Serializer for listing matches"""
    sport_name = serializers.CharField(source='sport.name', read_only=True)
    team_a_name = serializers.CharField(source='team_a.name', read_only=True)
    team_b_name = serializers.CharField(source='team_b.name', read_only=True)
    team_a_logo = serializers.ImageField(source='team_a.logo', read_only=True)
    team_b_logo = serializers.ImageField(source='team_b.logo', read_only=True)
    current_score = serializers.SerializerMethodField()
    
    class Meta:
        model = Match
        fields = ('id', 'title', 'sport', 'sport_name', 'team_a', 'team_a_name', 'team_a_logo',
              'team_b', 'team_b_name', 'team_b_logo', 'start_time', 'status', 'venue', 'current_score')
    
    def get_current_score(self, obj):
        latest_score = obj.scores.order_by('-timestamp').first()
        if latest_score:
            return {
                'team_a': latest_score.team_a_score,
                'team_b': latest_score.team_b_score,
                'period': latest_score.period
            }
        return None


class MatchDetailSerializer(serializers.ModelSerializer):
    """Serializer for detailed match view"""
    sport = SportSerializer(read_only=True)
    team_a = TeamSerializer(read_only=True)
    team_b = TeamSerializer(read_only=True)
    scores = ScoreSerializer(many=True, read_only=True)
    
    class Meta:
        model = Match
        fields = ('id', 'title', 'sport', 'team_a', 'team_b', 'start_time', 'end_time',
                  'venue', 'status', 'scores', 'created_at', 'updated_at')


class LoginSerializer(serializers.Serializer):
    """Serializer for user login"""
    username = serializers.CharField(max_length=150, required=True)
    password = serializers.CharField(required=True, write_only=True)