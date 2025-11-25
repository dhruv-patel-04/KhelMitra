import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'match_list_screen.dart';

class LoginScreen extends StatefulWidget {
  final void Function(String token, String baseUrl)? onLoggedIn;
  final String? defaultBaseUrl;

  const LoginScreen({Key? key, this.onLoggedIn, this.defaultBaseUrl}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _loading = false;
  String _baseUrl = 'http://localhost:8000'; // change to your backend URL

  @override
  void initState() {
    super.initState();
    if (widget.defaultBaseUrl != null && widget.defaultBaseUrl!.isNotEmpty) {
      _baseUrl = widget.defaultBaseUrl!;
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _login() async {
    setState(() => _loading = true);
    final api = ApiService(baseUrl: _baseUrl);
    try {
      final result = await api.login(_usernameCtrl.text.trim(), _passwordCtrl.text);
      final token = result['token'] as String;
      // If caller provided a login callback, call it (it will persist token and navigate).
      if (widget.onLoggedIn != null) {
        widget.onLoggedIn!(token, _baseUrl);
        return;
      }
      // Fallback: navigate directly
      if (!mounted) return;
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => MatchListScreen(token: token, api: api)));
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('KhelMitra — Referee Login')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            const Text('Server', style: TextStyle(fontWeight: FontWeight.w600)),
            TextField(controller: TextEditingController(text: _baseUrl),
              decoration: const InputDecoration(hintText: 'Backend base URL (e.g. http://10.0.2.2:8000)'),
              onChanged: (v) => _baseUrl = v.trim(),
            ),
            const SizedBox(height: 12),
            TextField(controller: _usernameCtrl, decoration: const InputDecoration(labelText: 'Username')),
            const SizedBox(height: 8),
            TextField(controller: _passwordCtrl, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _loading ? null : _login, child: _loading ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Login')),
            const SizedBox(height: 12),
            const Text('Use a referee account (is_referee = true). Change server if needed.'),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                // quick helper toggles for common hosts
                setState(() {
                  if (_baseUrl.contains('10.0.2.2')) _baseUrl = 'http://localhost:8000'; else _baseUrl = 'http://10.0.2.2:8000';
                });
              },
              child: const Text('Toggle emulator ↔ localhost'),
            ),
          ],
        ),
      ),
    );
  }
}
