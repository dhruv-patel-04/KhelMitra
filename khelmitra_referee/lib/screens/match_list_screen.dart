import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'score_update_screen.dart';

class MatchListScreen extends StatefulWidget {
  final String token;
  final ApiService api;
  final VoidCallback? onLogout;
  const MatchListScreen({super.key, required this.token, required this.api, this.onLogout});

  @override
  State<MatchListScreen> createState() => _MatchListScreenState();
}

class _MatchListScreenState extends State<MatchListScreen> {
  bool _loading = true;
  List<dynamic> _matches = [];
  String _sportName = 'Kabaddi';

  @override
  void initState() {
    super.initState();
    _loadMatches();
  }

  Future<void> _loadMatches() async {
    setState(() => _loading = true);
    try {
      final matches = await widget.api.getLiveMatches(token: widget.token, sportName: _sportName);
      if (mounted) setState(() => _matches = matches);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Kabaddi Matches'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loading ? null : _loadMatches,
            tooltip: 'Refresh',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              if (widget.onLogout != null) widget.onLogout!();
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadMatches,
              child: _matches.isEmpty
                  ? ListView(children: const [Center(child: Padding(padding: EdgeInsets.all(24), child: Text('No live matches')))])
                  : ListView.separated(
                      padding: const EdgeInsets.all(12),
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemCount: _matches.length,
                      itemBuilder: (context, index) {
                        final m = _matches[index];
                        final current = m['current_score'];
                        final scoreText = current != null ? '${current['team_a']} - ${current['team_b']}' : 'No score yet';
                        final teamAName = m['team_a_name'] ?? '';
                        final teamBName = m['team_b_name'] ?? '';
                        final teamALogo = m['team_a_logo'];
                        final teamBLogo = m['team_b_logo'];

                        return Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          child: InkWell(
                            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ScoreUpdateScreen(token: widget.token, api: widget.api, match: m))),
                            borderRadius: BorderRadius.circular(8),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        radius: 28,
                                        backgroundImage: teamALogo != null ? NetworkImage(teamALogo) : null,
                                        child: teamALogo == null ? Text(teamAName.isNotEmpty ? teamAName[0] : 'A') : null,
                                      ),
                                      const SizedBox(height: 6),
                                      SizedBox(width: 80, child: Text(teamAName, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis)),
                                    ],
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text(m['title'] ?? '$teamAName vs $teamBName', style: const TextStyle(fontWeight: FontWeight.w600)),
                                        const SizedBox(height: 8),
                                        Text(scoreText, style: const TextStyle(fontSize: 16)),
                                        const SizedBox(height: 4),
                                        Text(m['venue'] ?? '', style: const TextStyle(color: Colors.grey)),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        radius: 28,
                                        backgroundImage: teamBLogo != null ? NetworkImage(teamBLogo) : null,
                                        child: teamBLogo == null ? Text(teamBName.isNotEmpty ? teamBName[0] : 'B') : null,
                                      ),
                                      const SizedBox(height: 6),
                                      SizedBox(width: 80, child: Text(teamBName, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}
