import 'dart:async';

import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ScoreUpdateScreen extends StatefulWidget {
  final String token;
  final ApiService api;
  final Map<String, dynamic> match;
  const ScoreUpdateScreen({super.key, required this.token, required this.api, required this.match});

  @override
  State<ScoreUpdateScreen> createState() => _ScoreUpdateScreenState();
}

class _ScoreUpdateScreenState extends State<ScoreUpdateScreen> {
  // Kabaddi breakdown inputs for Team A
  final _aRaidCtrl = TextEditingController(text: '0');
  final _aTackleCtrl = TextEditingController(text: '0');
  final _aBonusCtrl = TextEditingController(text: '0');
  final _aAllOutCtrl = TextEditingController(text: '0');

  // Kabaddi breakdown inputs for Team B
  final _bRaidCtrl = TextEditingController(text: '0');
  final _bTackleCtrl = TextEditingController(text: '0');
  final _bBonusCtrl = TextEditingController(text: '0');
  final _bAllOutCtrl = TextEditingController(text: '0');

  final _periodCtrl = TextEditingController();
  bool _loading = false;

  int _aTotal = 0;
  int _bTotal = 0;
  Timer? _pollTimer;
  Map<String, dynamic>? _serverMatch;
  // base scores fetched from server; local breakdowns are deltas
  int _baseATotal = 0;
  int _baseBTotal = 0;

  @override
  void initState() {
    super.initState();
    void attachListeners() {
      for (final c in [_aRaidCtrl, _aTackleCtrl, _aBonusCtrl, _aAllOutCtrl, _bRaidCtrl, _bTackleCtrl, _bBonusCtrl, _bAllOutCtrl]) {
        c.addListener(_recomputeTotals);
      }
    }

    attachListeners();
    _recomputeTotals();
    _startPolling();
  }

  @override
  void dispose() {
    for (final c in [_aRaidCtrl, _aTackleCtrl, _aBonusCtrl, _aAllOutCtrl, _bRaidCtrl, _bTackleCtrl, _bBonusCtrl, _bAllOutCtrl, _periodCtrl]) {
      c.dispose();
    }
    super.dispose();
    _pollTimer?.cancel();
  }

  void _startPolling() {
    // initial fetch
    _fetchMatchDetail();
    _pollTimer = Timer.periodic(const Duration(seconds: 5), (_) => _fetchMatchDetail());
  }

  Future<void> _fetchMatchDetail() async {
    try {
      final matchId = widget.match['id'] as int;
      final detail = await widget.api.getMatchDetail(token: widget.token, matchId: matchId);
      // Update server snapshot and current_score if available
      setState(() {
        _serverMatch = detail;
        final latestScore = detail['scores'] != null && (detail['scores'] as List).isNotEmpty ? (detail['scores'] as List).last : null;
        if (latestScore != null) {
          // set base totals from server; keep local breakdowns (deltas) and recompute
          _baseATotal = (latestScore['team_a_score'] ?? _baseATotal) as int;
          _baseBTotal = (latestScore['team_b_score'] ?? _baseBTotal) as int;
          // recompute displayed totals
          _recomputeTotals();
        }
      });
    } catch (_) {
      // ignore polling errors silently; UI still allows local updates
    }
  }

  void _recomputeTotals() {
    int parse(String v) {
      try {
        return int.parse(v);
      } catch (_) {
        return 0;
      }
    }

    setState(() {
      final aDelta = parse(_aRaidCtrl.text) + parse(_aTackleCtrl.text) + parse(_aBonusCtrl.text) + parse(_aAllOutCtrl.text);
      final bDelta = parse(_bRaidCtrl.text) + parse(_bTackleCtrl.text) + parse(_bBonusCtrl.text) + parse(_bAllOutCtrl.text);
      _aTotal = _baseATotal + aDelta;
      _bTotal = _baseBTotal + bDelta;
    });
  }

  Future<void> _submit() async {
    final matchId = widget.match['id'] as int;
    final period = _periodCtrl.text.isEmpty ? null : _periodCtrl.text;
    final teamAScore = _aTotal;
    final teamBScore = _bTotal;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Score'),
        content: Text('${widget.match['team_a_name'] ?? 'Team A'}: $teamAScore\n${widget.match['team_b_name'] ?? 'Team B'}: $teamBScore'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Confirm')),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _loading = true);
    try {
      await widget.api.postScore(token: widget.token, matchId: matchId, teamAScore: teamAScore, teamBScore: teamBScore, period: period);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Score updated')));
        // refresh server snapshot immediately
        await _fetchMatchDetail();
        // after server confirms, clear local breakdowns (they've been merged into base)
        _aRaidCtrl.text = '0';
        _aTackleCtrl.text = '0';
        _aBonusCtrl.text = '0';
        _aAllOutCtrl.text = '0';
        _bRaidCtrl.text = '0';
        _bTackleCtrl.text = '0';
        _bBonusCtrl.text = '0';
        _bAllOutCtrl.text = '0';
        _recomputeTotals();
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  // Action helpers
  Future<void> _addRaid(bool forTeamA) async {
    final points = await _askForPoints(defaultValue: 1, title: 'Raid points');
    if (points == null) return;
    if (forTeamA) {
      final cur = int.tryParse(_aRaidCtrl.text) ?? 0;
      _aRaidCtrl.text = (cur + points).toString();
    } else {
      final cur = int.tryParse(_bRaidCtrl.text) ?? 0;
      _bRaidCtrl.text = (cur + points).toString();
    }
    _recomputeTotals();
    await _submit();
  }

  Future<void> _addTackle(bool forTeamA) async {
    final points = await _askForPoints(defaultValue: 1, title: 'Tackle points');
    if (points == null) return;
    if (forTeamA) {
      final cur = int.tryParse(_aTackleCtrl.text) ?? 0;
      _aTackleCtrl.text = (cur + points).toString();
    } else {
      final cur = int.tryParse(_bTackleCtrl.text) ?? 0;
      _bTackleCtrl.text = (cur + points).toString();
    }
    _recomputeTotals();
    await _submit();
  }

  Future<void> _addBonus(bool forTeamA) async {
    if (forTeamA) {
      final cur = int.tryParse(_aBonusCtrl.text) ?? 0;
      _aBonusCtrl.text = (cur + 1).toString();
    } else {
      final cur = int.tryParse(_bBonusCtrl.text) ?? 0;
      _bBonusCtrl.text = (cur + 1).toString();
    }
    _recomputeTotals();
    await _submit();
  }

  Future<void> _addAllOut(bool forTeamA) async {
    // All-out awards 2 points to opponent team
    if (forTeamA) {
      final cur = int.tryParse(_bAllOutCtrl.text) ?? 0;
      _bAllOutCtrl.text = (cur + 2).toString();
    } else {
      final cur = int.tryParse(_aAllOutCtrl.text) ?? 0;
      _aAllOutCtrl.text = (cur + 2).toString();
    }
    _recomputeTotals();
    await _submit();
  }

  Future<int?> _askForPoints({required int defaultValue, required String title}) async {
    final ctrl = TextEditingController(text: defaultValue.toString());
    final res = await showDialog<int?>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(controller: ctrl, keyboardType: TextInputType.number, decoration: const InputDecoration(hintText: 'Points')),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(null), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.of(context).pop(int.tryParse(ctrl.text) ?? defaultValue), child: const Text('OK')),
        ],
      ),
    );
    return res;
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.match['title'] ?? '${widget.match['team_a_name']} vs ${widget.match['team_b_name']}';
    final teamAName = widget.match['team_a_name'] ?? 'Team A';
    final teamBName = widget.match['team_b_name'] ?? 'Team B';

    Widget buildBreakdown(String label, TextEditingController ctrl) {
      return SizedBox(
        width: 100,
        child: TextField(
          controller: ctrl,
          decoration: InputDecoration(labelText: label, isDense: true),
          keyboardType: TextInputType.number,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Update Score — $title')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(child: Text(teamAName, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w700))),
                Expanded(child: Text('Kabaddi Breakdown', textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w700))),
                Expanded(child: Text(teamBName, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w700))),
              ],
            ),
            const SizedBox(height: 12),
            // Server reported latest score (if available)
            if (_serverMatch != null) ...[
              const Text('Server latest:'),
              const SizedBox(height: 4),
              Builder(builder: (_) {
                final latest = _serverMatch!['scores'] != null && (_serverMatch!['scores'] as List).isNotEmpty ? (_serverMatch!['scores'] as List).last : null;
                if (latest != null) {
                  return Text('${widget.match['team_a_name'] ?? 'A'} ${latest['team_a_score']} - ${latest['team_b_score']} ${widget.match['team_b_name'] ?? 'B'}', style: const TextStyle(color: Colors.blue));
                }
                return const SizedBox.shrink();
              }),
              const SizedBox(height: 12),
            ],

            const Divider(),
            const SizedBox(height: 8),
            const Text('Quick Actions', style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),

            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      ElevatedButton.icon(onPressed: () => _addRaid(true), icon: const Icon(Icons.flash_on), label: const Text('Raid')),
                      const SizedBox(height: 6),
                      ElevatedButton.icon(onPressed: () => _addTackle(true), icon: const Icon(Icons.sports_mma), label: const Text('Tackle')),
                      const SizedBox(height: 6),
                      ElevatedButton.icon(onPressed: () => _addBonus(true), icon: const Icon(Icons.add_circle_outline), label: const Text('Bonus')),
                      const SizedBox(height: 6),
                      ElevatedButton.icon(onPressed: () => _addAllOut(true), icon: const Icon(Icons.group_remove), label: const Text('All-out')),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    children: [
                      ElevatedButton.icon(onPressed: () => _addRaid(false), icon: const Icon(Icons.flash_on), label: const Text('Raid')),
                      const SizedBox(height: 6),
                      ElevatedButton.icon(onPressed: () => _addTackle(false), icon: const Icon(Icons.sports_mma), label: const Text('Tackle')),
                      const SizedBox(height: 6),
                      ElevatedButton.icon(onPressed: () => _addBonus(false), icon: const Icon(Icons.add_circle_outline), label: const Text('Bonus')),
                      const SizedBox(height: 6),
                      ElevatedButton.icon(onPressed: () => _addAllOut(false), icon: const Icon(Icons.group_remove), label: const Text('All-out')),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Raid
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildBreakdown('Raid', _aRaidCtrl),
                const Expanded(child: Center(child: Text('Raid Points'))),
                buildBreakdown('Raid', _bRaidCtrl),
              ],
            ),
            const SizedBox(height: 8),

            // Tackle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildBreakdown('Tackle', _aTackleCtrl),
                const Expanded(child: Center(child: Text('Tackle Points'))),
                buildBreakdown('Tackle', _bTackleCtrl),
              ],
            ),
            const SizedBox(height: 8),

            // Bonus
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildBreakdown('Bonus', _aBonusCtrl),
                const Expanded(child: Center(child: Text('Bonus Points'))),
                buildBreakdown('Bonus', _bBonusCtrl),
              ],
            ),
            const SizedBox(height: 8),

            // All-out
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildBreakdown('All-out', _aAllOutCtrl),
                const Expanded(child: Center(child: Text('All-out Points'))),
                buildBreakdown('All-out', _bAllOutCtrl),
              ],
            ),

            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: Text('Total: $teamAName  — $_aTotal', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
                Expanded(child: Text('Total: $teamBName  — $_bTotal', textAlign: TextAlign.end, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
              ],
            ),

            const SizedBox(height: 12),
            TextField(controller: _periodCtrl, decoration: const InputDecoration(labelText: 'Period / Phase (optional)')),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _loading ? null : _submit, child: _loading ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Submit Kabaddi Score')),
          ],
        ),
      ),
    );
  }
}
