from django.contrib import admin
from .models import Sport, Team, Match, Score, UserProfile


@admin.register(Sport)
class SportAdmin(admin.ModelAdmin):
    list_display = ('name', 'description')
    search_fields = ('name',)


@admin.register(Team)
class TeamAdmin(admin.ModelAdmin):
    list_display = ('name', 'sport', 'created_at')
    list_filter = ('sport',)
    search_fields = ('name',)


@admin.register(Match)
class MatchAdmin(admin.ModelAdmin):
    list_display = ('title', 'sport', 'team_a', 'team_b', 'start_time', 'status')
    list_filter = ('sport', 'status')
    search_fields = ('title', 'team_a__name', 'team_b__name')


@admin.register(Score)
class ScoreAdmin(admin.ModelAdmin):
    list_display = ('match', 'team_a_score', 'team_b_score', 'period', 'timestamp')
    list_filter = ('match__sport',)


@admin.register(UserProfile)
class UserProfileAdmin(admin.ModelAdmin):
    list_display = ('user', 'get_email')
    search_fields = ('user__username', 'user__email')
    filter_horizontal = ('favorite_teams', 'favorite_sports')
    
    def get_email(self, obj):
        return obj.user.email
    get_email.short_description = 'Email'