import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'screens/login_screen.dart';
import 'screens/match_list_screen.dart';
import 'services/token_storage.dart';
import 'services/api_service.dart';

void main() {
  runApp(const RefereeApp());
}

class RefereeApp extends StatefulWidget {
  const RefereeApp({super.key});

  @override
  State<RefereeApp> createState() => _RefereeAppState();
}

class _RefereeAppState extends State<RefereeApp> {
  final TokenStorage _storage = TokenStorage();
  String? _token;
  String _baseUrl = 'http://10.0.2.2:8000';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _restore();
  }

  Future<void> _restore() async {
    final token = await _storage.readToken();
    final base = await _storage.readBaseUrl();
    setState(() {
      _token = token;
      if (base != null && base.isNotEmpty) _baseUrl = base;
      _loading = false;
    });
  }

  void _onLoggedIn(String token, String baseUrl) async {
    await _storage.saveToken(token);
    await _storage.saveBaseUrl(baseUrl);
    setState(() {
      _token = token;
      _baseUrl = baseUrl;
    });
  }

  void _onLoggedOut() async {
    await _storage.deleteToken();
    setState(() => _token = null);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const MaterialApp(home: Scaffold(body: Center(child: CircularProgressIndicator())));

    final api = ApiService(baseUrl: _baseUrl);

    return MaterialApp(
      title: 'KhelMitra Referee',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      home: _token == null
          ? LoginScreen(onLoggedIn: (token, base) => _onLoggedIn(token, base), defaultBaseUrl: _baseUrl)
          : MatchListScreen(token: _token!, api: api, onLogout: _onLoggedOut),
    );
  }
}
