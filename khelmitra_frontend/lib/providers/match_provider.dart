import 'package:flutter/material.dart';
import 'package:khelmitra/services/api_service.dart';

class MatchProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  bool _isLoading = false;
  String? _error;
  
  List<dynamic> _liveMatches = [];
  List<dynamic> _upcomingMatches = [];
  List<dynamic> _completedMatches = [];
  List<dynamic> _sports = [];
  Map<String, dynamic>? _currentMatch;
  
  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<dynamic> get liveMatches => _liveMatches;
  List<dynamic> get upcomingMatches => _upcomingMatches;
  List<dynamic> get completedMatches => _completedMatches;
  List<dynamic> get sports => _sports;
  Map<String, dynamic>? get currentMatch => _currentMatch;
  
  // Fetch all sports
  Future<void> fetchSports() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final response = await _apiService.getSports();
      if (response['success']) {
        _sports = response['data'];
        _error = null;
      } else {
        _error = 'Failed to load sports';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Fetch live matches
  Future<void> fetchLiveMatches({int? sportId}) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final response = await _apiService.getLiveMatches(sportId: sportId);
      if (response['success']) {
        _liveMatches = response['data'];
        _error = null;
      } else {
        _error = 'Failed to load live matches';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Fetch upcoming matches
  Future<void> fetchUpcomingMatches({int? sportId}) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final response = await _apiService.getUpcomingMatches(sportId: sportId);
      if (response['success']) {
        _upcomingMatches = response['data'];
        _error = null;
      } else {
        _error = 'Failed to load upcoming matches';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Fetch completed matches
  Future<void> fetchCompletedMatches({int? sportId}) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final response = await _apiService.getCompletedMatches(sportId: sportId);
      if (response['success']) {
        _completedMatches = response['data'];
        _error = null;
      } else {
        _error = 'Failed to load completed matches';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Fetch match details
  Future<void> fetchMatchDetails(int matchId) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final response = await _apiService.getMatchDetails(matchId);
      if (response['success']) {
        _currentMatch = response['data'];
        _error = null;
      } else {
        _error = 'Failed to load match details';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Refresh all match data
  Future<void> refreshAllMatches({int? sportId}) async {
    await Future.wait([
      fetchLiveMatches(sportId: sportId),
      fetchUpcomingMatches(sportId: sportId),
      fetchCompletedMatches(sportId: sportId),
    ]);
  }
  
  // Clear current match
  void clearCurrentMatch() {
    _currentMatch = null;
    notifyListeners();
  }
}