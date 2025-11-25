from django.urls import path
from rest_framework.authtoken.views import obtain_auth_token
from . import views

urlpatterns = [
    # Authentication endpoints
    path('register/', views.RegisterView.as_view(), name='register'),
    path('login/', views.LoginView.as_view(), name='login'),
    path('token-auth/', obtain_auth_token, name='token_auth'),
    path('profile/', views.UserProfileView.as_view(), name='profile'),
    
    # Sports and teams endpoints
    path('sports/', views.SportListView.as_view(), name='sport-list'),
    path('teams/', views.TeamListView.as_view(), name='team-list'),
    
    # Match endpoints
    path('matches/live/', views.LiveMatchListView.as_view(), name='live-matches'),
    path('matches/upcoming/', views.UpcomingMatchListView.as_view(), name='upcoming-matches'),
    path('matches/completed/', views.CompletedMatchListView.as_view(), name='completed-matches'),
    path('matches/<int:pk>/', views.MatchDetailView.as_view(), name='match-detail'),
    path('matches/<int:pk>/update_score/', views.UpdateScoreView.as_view(), name='update-score'),
]