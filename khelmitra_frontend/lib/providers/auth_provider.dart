import 'package:flutter/material.dart';
import 'package:khelmitra/services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _error;
  Map<String, dynamic>? _userData;
  
  // Getters
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<String, dynamic>? get userData => _userData;
  Map<String, dynamic>? get user => _userData;
  
  // Initialize auth state
  Future<void> initAuth() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final token = await _apiService.getToken();
      if (token != null) {
        // Token exists, try to get user profile
        final response = await _apiService.getUserProfile();
        if (response['success']) {
          _userData = response['data'];
          _isAuthenticated = true;
        } else {
          // Invalid token, logout
          await _apiService.deleteToken();
          _isAuthenticated = false;
        }
      } else {
        _isAuthenticated = false;
      }
      _error = null;
    } catch (e) {
      _error = e.toString();
      _isAuthenticated = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Register a new user
  Future<bool> register({
    required String username,
    required String email,
    required String password,
    required String password2,
    required String firstName,
    required String lastName,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final response = await _apiService.register(
        username: username,
        email: email,
        password: password,
        password2: password2,
        firstName: firstName,
        lastName: lastName,
      );
      
      if (response['success']) {
        // Registration successful
        return true;
      } else {
        // Registration failed
        _error = _formatErrorMessage(response['error']);
        return false;
      }
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Login user
  Future<bool> login({
    required String username,
    required String password,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final response = await _apiService.login(
        username: username,
        password: password,
      );
      
      if (response['success']) {
        // Login successful
        _userData = response['data'];
        _isAuthenticated = true;
        return true;
      } else {
        // Login failed
        _error = _formatErrorMessage(response['error']);
        _isAuthenticated = false;
        return false;
      }
    } catch (e) {
      _error = e.toString();
      _isAuthenticated = false;
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Logout user
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      await _apiService.logout();
      _isAuthenticated = false;
      _userData = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Get user profile
  Future<Map<String, dynamic>?> getUserProfile() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final response = await _apiService.getUserProfile();
      
      if (response['success']) {
        // Update user data
        _userData = response['data'];
        return response['data'];
      } else {
        // Failed to get profile
        _error = _formatErrorMessage(response['error']);
        return null;
      }
    } catch (e) {
      _error = e.toString();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Update user profile
  Future<bool> updateUserProfile(Map<String, dynamic> profileData) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      // We need to add this method to ApiService
      final response = await _apiService.updateUserProfile(profileData);
      
      if (response['success']) {
        // Update user data
        _userData = response['data'];
        return true;
      } else {
        // Failed to update profile
        _error = _formatErrorMessage(response['error']);
        return false;
      }
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Helper method to format error messages from API
  String _formatErrorMessage(Map<String, dynamic> errorData) {
    if (errorData.containsKey('error')) {
      return errorData['error'];
    }
    
    final StringBuffer errorMessage = StringBuffer();
    
    errorData.forEach((key, value) {
      if (value is List) {
        errorMessage.writeln('$key: ${value.join(', ')}');
      } else {
        errorMessage.writeln('$key: $value');
      }
    });
    
    return errorMessage.toString().trim();
  }
}