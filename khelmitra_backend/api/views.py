from django.contrib.auth import authenticate
from django.contrib.auth.models import User
from rest_framework import generics, permissions, status
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.authtoken.models import Token
from .models import Sport, Team, Match, Score, UserProfile
from .serializers import (
    UserSerializer, UserProfileSerializer, SportSerializer, TeamSerializer,
    ScoreSerializer, MatchListSerializer, MatchDetailSerializer, LoginSerializer
)


class RegisterView(generics.CreateAPIView):
    """View for user registration"""
    queryset = User.objects.all()
    permission_classes = (permissions.AllowAny,)
    serializer_class = UserSerializer


class LoginView(APIView):
    """View for user login"""
    permission_classes = (permissions.AllowAny,)
    serializer_class = LoginSerializer

    def post(self, request):
        serializer = self.serializer_class(data=request.data)
        if serializer.is_valid():
            username = serializer.validated_data['username']
            password = serializer.validated_data['password']
            user = authenticate(username=username, password=password)
            
            if user:
                token, created = Token.objects.get_or_create(user=user)
                return Response({
                    'token': token.key,
                    'user_id': user.pk,
                    'username': user.username,
                    'email': user.email,
                    'first_name': user.first_name,
                    'last_name': user.last_name
                })
            return Response({'error': 'Invalid credentials'}, status=status.HTTP_401_UNAUTHORIZED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class UserProfileView(generics.RetrieveUpdateAPIView):
    """View for retrieving and updating user profile"""
    serializer_class = UserProfileSerializer
    permission_classes = (permissions.IsAuthenticated,)

    def get_object(self):
        return UserProfile.objects.get(user=self.request.user)


class SportListView(generics.ListAPIView):
    """View for listing all sports"""
    queryset = Sport.objects.all()
    serializer_class = SportSerializer
    permission_classes = (permissions.AllowAny,)


class TeamListView(generics.ListAPIView):
    """View for listing all teams"""
    queryset = Team.objects.all()
    serializer_class = TeamSerializer
    permission_classes = (permissions.AllowAny,)

    def get_queryset(self):
        queryset = Team.objects.all()
        sport_id = self.request.query_params.get('sport_id', None)
        if sport_id is not None:
            queryset = queryset.filter(sport_id=sport_id)
        return queryset


class LiveMatchListView(generics.ListAPIView):
    """View for listing live matches"""
    serializer_class = MatchListSerializer
    permission_classes = (permissions.AllowAny,)

    def get_queryset(self):
        queryset = Match.objects.filter(status='live')
        sport_id = self.request.query_params.get('sport_id', None)
        if sport_id is not None:
            queryset = queryset.filter(sport_id=sport_id)
        return queryset


class UpcomingMatchListView(generics.ListAPIView):
    """View for listing upcoming matches"""
    serializer_class = MatchListSerializer
    permission_classes = (permissions.AllowAny,)

    def get_queryset(self):
        queryset = Match.objects.filter(status='scheduled')
        sport_id = self.request.query_params.get('sport_id', None)
        if sport_id is not None:
            queryset = queryset.filter(sport_id=sport_id)
        return queryset


class CompletedMatchListView(generics.ListAPIView):
    """View for listing completed matches"""
    serializer_class = MatchListSerializer
    permission_classes = (permissions.AllowAny,)

    def get_queryset(self):
        queryset = Match.objects.filter(status='completed')
        sport_id = self.request.query_params.get('sport_id', None)
        if sport_id is not None:
            queryset = queryset.filter(sport_id=sport_id)
        return queryset


class MatchDetailView(generics.RetrieveAPIView):
    """View for retrieving match details"""
    queryset = Match.objects.all()
    serializer_class = MatchDetailSerializer
    permission_classes = (permissions.AllowAny,)


class UpdateScoreView(APIView):
    """Endpoint for referees to post score updates for a match"""
    permission_classes = (permissions.IsAuthenticated,)

    def post(self, request, pk):
        # Only users flagged as referees can update scores
        profile = getattr(request.user, 'profile', None)
        if not profile or not getattr(profile, 'is_referee', False):
            return Response({'detail': 'Permission denied. User is not a referee.'}, status=status.HTTP_403_FORBIDDEN)

        try:
            match = Match.objects.get(pk=pk)
        except Match.DoesNotExist:
            return Response({'detail': 'Match not found.'}, status=status.HTTP_404_NOT_FOUND)

        # Ensure the match id is set on the incoming data
        data = request.data.copy()
        data['match'] = match.id

        serializer = ScoreSerializer(data=data)
        if serializer.is_valid():
            score = serializer.save()
            # If match is not live, set it to live when a score is posted
            if match.status != 'live':
                match.status = 'live'
                match.save()
            return Response(ScoreSerializer(score).data, status=status.HTTP_201_CREATED)

        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)