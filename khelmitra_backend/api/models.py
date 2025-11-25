from django.db import models
from django.contrib.auth.models import User


class Sport(models.Model):
    """Model for different sports types"""
    name = models.CharField(max_length=100)
    description = models.TextField(blank=True, null=True)
    icon = models.ImageField(upload_to='sport_icons/', blank=True, null=True)
    
    def __str__(self):
        return self.name


class Team(models.Model):
    """Model for sports teams"""
    name = models.CharField(max_length=100)
    logo = models.ImageField(upload_to='team_logos/', blank=True, null=True)
    sport = models.ForeignKey(Sport, on_delete=models.CASCADE, related_name='teams')
    description = models.TextField(blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    def __str__(self):
        return self.name


class Match(models.Model):
    """Model for sports matches"""
    STATUS_CHOICES = (
        ('scheduled', 'Scheduled'),
        ('live', 'Live'),
        ('completed', 'Completed'),
        ('cancelled', 'Cancelled'),
    )
    
    title = models.CharField(max_length=200)
    sport = models.ForeignKey(Sport, on_delete=models.CASCADE, related_name='matches')
    team_a = models.ForeignKey(Team, on_delete=models.CASCADE, related_name='home_matches')
    team_b = models.ForeignKey(Team, on_delete=models.CASCADE, related_name='away_matches')
    start_time = models.DateTimeField()
    end_time = models.DateTimeField(null=True, blank=True)
    venue = models.CharField(max_length=200, blank=True, null=True)
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='scheduled')
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    def __str__(self):
        return f"{self.team_a.name} vs {self.team_b.name} - {self.start_time.strftime('%Y-%m-%d')}"


class Score(models.Model):
    """Model for match scores"""
    match = models.ForeignKey(Match, on_delete=models.CASCADE, related_name='scores')
    team_a_score = models.IntegerField(default=0)
    team_b_score = models.IntegerField(default=0)
    period = models.CharField(max_length=50, blank=True, null=True)  # e.g., "1st Quarter", "2nd Half"
    timestamp = models.DateTimeField(auto_now=True)
    
    def __str__(self):
        return f"{self.match} - {self.team_a_score}:{self.team_b_score}"


class UserProfile(models.Model):
    """Extended user profile model"""
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='profile')
    profile_picture = models.ImageField(upload_to='profile_pics/', blank=True, null=True)
    bio = models.TextField(blank=True, null=True, max_length=500)
    favorite_teams = models.ManyToManyField(Team, blank=True, related_name='fans')
    favorite_sports = models.ManyToManyField(Sport, blank=True, related_name='fans')
    is_referee = models.BooleanField(default=False)
    
    def __str__(self):
        return self.user.username