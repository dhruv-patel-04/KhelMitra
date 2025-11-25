import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  Future<Map<String, dynamic>> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/api/login/');
    try {
      final resp = await http
          .post(url,
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode({'username': username, 'password': password}))
          .timeout(const Duration(seconds: 15));

      if (resp.statusCode == 200) {
        return jsonDecode(resp.body) as Map<String, dynamic>;
      }

      throw Exception('Login failed (${resp.statusCode}): ${resp.body}');
    } catch (e) {
      // Rethrow so UI can show a meaningful message
      throw Exception('Network/login error: $e');
    }
  }

  Future<List<dynamic>> getLiveMatches({required String token, String? sportName}) async {
    // If sportName is provided, attempt to resolve sport id first
    String urlStr = '$baseUrl/api/matches/live/';
    if (sportName != null) {
      // fetch sports and find id
      final sUrl = Uri.parse('$baseUrl/api/sports/');
      final sResp = await http.get(sUrl);
      if (sResp.statusCode == 200) {
        final List<dynamic> sports = jsonDecode(sResp.body);
        final sport = sports.firstWhere((s) => s['name'].toString().toLowerCase() == sportName.toLowerCase(), orElse: () => null);
        if (sport != null) {
          urlStr = '$baseUrl/api/matches/live/?sport_id=${sport['id']}';
        }
      }
    }

    final url = Uri.parse(urlStr);
    try {
      final resp = await http.get(url, headers: {'Authorization': 'Token $token'}).timeout(const Duration(seconds: 15));
      if (resp.statusCode == 200) {
        return jsonDecode(resp.body) as List<dynamic>;
      }
      throw Exception('Could not fetch matches (${resp.statusCode}): ${resp.body}');
    } catch (e) {
      throw Exception('Network error fetching matches: $e');
    }
  }

  Future<Map<String, dynamic>> postScore({required String token, required int matchId, required int teamAScore, required int teamBScore, String? period}) async {
    final url = Uri.parse('$baseUrl/api/matches/$matchId/update_score/');
    final Map<String, dynamic> body = {
      'team_a_score': teamAScore,
      'team_b_score': teamBScore,
    };
    if (period != null) body['period'] = period;

    try {
      final resp = await http
          .post(url, headers: {'Content-Type': 'application/json', 'Authorization': 'Token $token'}, body: jsonEncode(body))
          .timeout(const Duration(seconds: 15));

      if (resp.statusCode == 201) {
        return jsonDecode(resp.body) as Map<String, dynamic>;
      }
      throw Exception('Failed to post score (${resp.statusCode}): ${resp.body}');
    } catch (e) {
      throw Exception('Network error posting score: $e');
    }
  }

  Future<Map<String, dynamic>> getMatchDetail({required String token, required int matchId}) async {
    final url = Uri.parse('$baseUrl/api/matches/$matchId/');
    try {
      final resp = await http.get(url, headers: {'Authorization': 'Token $token'}).timeout(const Duration(seconds: 10));
      if (resp.statusCode == 200) {
        return jsonDecode(resp.body) as Map<String, dynamic>;
      }
      throw Exception('Failed to get match detail (${resp.statusCode}): ${resp.body}');
    } catch (e) {
      throw Exception('Network error fetching match detail: $e');
    }
  }
}
