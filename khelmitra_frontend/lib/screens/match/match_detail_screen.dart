import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:khelmitra/providers/match_provider.dart';
import 'package:khelmitra/widgets/score_board.dart';

class MatchDetailScreen extends StatefulWidget {
  final int matchId;
  
  const MatchDetailScreen({Key? key, required this.matchId}) : super(key: key);

  @override
  State<MatchDetailScreen> createState() => _MatchDetailScreenState();
}

class _MatchDetailScreenState extends State<MatchDetailScreen> {
  @override
  void initState() {
    super.initState();
    _loadMatchDetails();
  }

  @override
  void dispose() {
    Provider.of<MatchProvider>(context, listen: false).clearCurrentMatch();
    super.dispose();
  }

  Future<void> _loadMatchDetails() async {
    await Provider.of<MatchProvider>(context, listen: false).fetchMatchDetails(widget.matchId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Match Details'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            icon: const Icon(Icons.refresh),
            onPressed: _loadMatchDetails,
          ),
        ],
      ),
      body: Consumer<MatchProvider>(
        builder: (context, matchProvider, _) {
          if (matchProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (matchProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${matchProvider.error}',
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadMatchDetails,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          
          if (matchProvider.currentMatch == null) {
            return const Center(child: Text('Match not found'));
          }
          
          final match = matchProvider.currentMatch!;
          final isLive = match['status'] == 'live';
          final latestScore = match['scores'].isNotEmpty ? match['scores'].last : null;
          
          return RefreshIndicator(
            onRefresh: _loadMatchDetails,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Match title and status
                    Text(
                      match['title'],
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getStatusColor(match['status']),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            _getStatusText(match['status']),
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          match['sport']['name'],
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // Score board
                    if (latestScore != null)
                      ScoreBoard(
                        teamA: match['team_a']['name'],
                        teamB: match['team_b']['name'],
                        scoreA: latestScore['team_a_score'],
                        scoreB: latestScore['team_b_score'],
                        teamALogo: match['team_a']['logo'],
                        teamBLogo: match['team_b']['logo'],
                        isLive: isLive,
                        period: latestScore['period'],
                      ),
                    const SizedBox(height: 24),
                    
                    // Match details
                    _buildDetailItem(
                      context,
                      'Date & Time',
                      DateFormat('EEEE, MMM d, yyyy • h:mm a').format(DateTime.parse(match['start_time'])),
                      Icons.calendar_today,
                    ),
                    if (match['venue'] != null)
                      _buildDetailItem(
                        context,
                        'Venue',
                        match['venue'],
                        Icons.location_on,
                      ),
                    const SizedBox(height: 24),
                    
                    // Score history
                    if (match['scores'].isNotEmpty) ...[  
                      Text(
                        'Score History',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: match['scores'].length,
                        itemBuilder: (context, index) {
                          final score = match['scores'][match['scores'].length - 1 - index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          score['period'] ?? 'Final Score',
                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          DateFormat('MMM d, yyyy • h:mm a')
                                              .format(DateTime.parse(score['timestamp'])),
                                          style: Theme.of(context).textTheme.bodySmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '${score['team_a_score']} - ${score['team_b_score']}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailItem(BuildContext context, String title, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.secondary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(value),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'live':
        return Colors.red;
      case 'completed':
        return Colors.green;
      case 'scheduled':
        return Colors.blue;
      case 'cancelled':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'live':
        return 'LIVE';
      case 'completed':
        return 'COMPLETED';
      case 'scheduled':
        return 'UPCOMING';
      case 'cancelled':
        return 'CANCELLED';
      default:
        return status.toUpperCase();
    }
  }
}