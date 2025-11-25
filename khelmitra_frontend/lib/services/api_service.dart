import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  // Base URL for API requests - change this to your backend URL when deployed
  static const String baseUrl = 'http://127.0.0.1:8000/api';
  // Use 10.0.2.2 for Android emulator to connect to localhost
  // For iOS simulator, use 'http://localhost:8000/api'
  // For physical devices, use your computer's IP address
  
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  
  // Get auth token from secure storage
  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }
  
  // Save auth token to secure storage
  Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }
  
  // Delete auth token from secure storage
  Future<void> deleteToken() async {
    await _storage.delete(key: 'auth_token');
  }
  
  // Get headers with auth token
  Future<Map<String, String>> _getHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Token $token',
    };
  }
  
  // Register a new user
  Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
    required String password2,
    required String firstName,
    required String lastName,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register/'),
      headers: await _getHeaders(),
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
        'password2': password2,
        'first_name': firstName,
        'last_name': lastName,
      }),
    );
    
    final data = jsonDecode(response.body);
    
    if (response.statusCode == 201) {
      return {'success': true, 'data': data};
    } else {
      return {'success': false, 'error': data};
    }
  }
  
  // Login user
  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login/'),
      headers: await _getHeaders(),
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );
    
    final data = jsonDecode(response.body);
    
    if (response.statusCode == 200) {
      // Save token
      await saveToken(data['token']);
      return {'success': true, 'data': data};
    } else {
      return {'success': false, 'error': data};
    }
  }
  
  // Logout user
  Future<void> logout() async {
    await deleteToken();
  }
  
  // Get user profile
  Future<Map<String, dynamic>> getUserProfile() async {
    final response = await http.get(
      Uri.parse('$baseUrl/profile/'),
      headers: await _getHeaders(),
    );
    
    final data = jsonDecode(response.body);
    
    if (response.statusCode == 200) {
      return {'success': true, 'data': data};
    } else {
      return {'success': false, 'error': data};
    }
  }
  
  // Update user profile
  Future<Map<String, dynamic>> updateUserProfile(Map<String, dynamic> profileData) async {
    final response = await http.put(
      Uri.parse('$baseUrl/profile/'),
      headers: await _getHeaders(),
      body: jsonEncode(profileData),
    );
    
    final data = jsonDecode(response.body);
    
    if (response.statusCode == 200) {
      return {'success': true, 'data': data};
    } else {
      return {'success': false, 'error': data};
    }
  }
  
  // Get all sports
  Future<Map<String, dynamic>> getSports() async {
    final response = await http.get(
      Uri.parse('$baseUrl/sports/'),
      headers: await _getHeaders(),
    );
    
    final data = jsonDecode(response.body);
    
    if (response.statusCode == 200) {
      return {'success': true, 'data': data};
    } else {
      return {'success': false, 'error': data};
    }
  }
  
  // Get teams (optionally filtered by sport_id)
  Future<Map<String, dynamic>> getTeams({int? sportId}) async {
    String url = '$baseUrl/teams/';
    if (sportId != null) {
      url += '?sport_id=$sportId';
    }
    
    final response = await http.get(
      Uri.parse(url),
      headers: await _getHeaders(),
    );
    
    final data = jsonDecode(response.body);
    
    if (response.statusCode == 200) {
      return {'success': true, 'data': data};
    } else {
      return {'success': false, 'error': data};
    }
  }
  
  // Get live matches (optionally filtered by sport_id)
  Future<Map<String, dynamic>> getLiveMatches({int? sportId}) async {
    String url = '$baseUrl/matches/live/';
    if (sportId != null) {
      url += '?sport_id=$sportId';
    }
    
    final response = await http.get(
      Uri.parse(url),
      headers: await _getHeaders(),
    );
    
    final data = jsonDecode(response.body);
    
    if (response.statusCode == 200) {
      return {'success': true, 'data': data};
    } else {
      return {'success': false, 'error': data};
    }
  }
  
  // Get upcoming matches (optionally filtered by sport_id)
  Future<Map<String, dynamic>> getUpcomingMatches({int? sportId}) async {
    String url = '$baseUrl/matches/upcoming/';
    if (sportId != null) {
      url += '?sport_id=$sportId';
    }
    
    final response = await http.get(
      Uri.parse(url),
      headers: await _getHeaders(),
    );
    
    final data = jsonDecode(response.body);
    
    if (response.statusCode == 200) {
      return {'success': true, 'data': data};
    } else {
      return {'success': false, 'error': data};
    }
  }
  
  // Get completed matches (optionally filtered by sport_id)
  Future<Map<String, dynamic>> getCompletedMatches({int? sportId}) async {
    String url = '$baseUrl/matches/completed/';
    if (sportId != null) {
      url += '?sport_id=$sportId';
    }
    
    final response = await http.get(
      Uri.parse(url),
      headers: await _getHeaders(),
    );
    
    final data = jsonDecode(response.body);
    
    if (response.statusCode == 200) {
      return {'success': true, 'data': data};
    } else {
      return {'success': false, 'error': data};
    }
  }
  
  // Get match details
  Future<Map<String, dynamic>> getMatchDetails(int matchId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/matches/$matchId/'),
      headers: await _getHeaders(),
    );
    
    final data = jsonDecode(response.body);
    
    if (response.statusCode == 200) {
      return {'success': true, 'data': data};
    } else {
      return {'success': false, 'error': data};
    }
  }
}