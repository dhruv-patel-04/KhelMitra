import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MatchCard extends StatelessWidget {
  final Map<String, dynamic> match;
  final bool isLive;
  final VoidCallback onTap;

  const MatchCard({
    Key? key,
    required this.match,
    required this.isLive,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sportName = match['sport_name'];
    final status = match['status'];
    final startTime = DateTime.parse(match['start_time']);
    
    // Get current score if available
    final currentScore = match['current_score'];
    final hasScores = currentScore != null;
    final teamAScore = hasScores ? currentScore['team_a'] : null;
    final teamBScore = hasScores ? currentScore['team_b'] : null;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sport and status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    sportName ?? 'Unknown Sport',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  _buildStatusBadge(context, status),
                ],
              ),
              const SizedBox(height: 16),
              
              // Teams and scores
              Row(
                children: [
                  // Team A
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildTeamLogo(match['team_a_logo']),
                        const SizedBox(height: 8),
                        Text(
                          match['team_a_name'] ?? 'Team A',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  
                  // Score
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        if (hasScores)
                          Text(
                            '$teamAScore - $teamBScore',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        else
                          const Text(
                            'VS',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        const SizedBox(height: 4),
                        if (isLive)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.fiber_manual_record, color: Colors.white, size: 12),
                                SizedBox(width: 4),
                                Text(
                                  'LIVE',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          Text(
                            DateFormat('h:mm a').format(startTime),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                  ),
                  
                  // Team B
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildTeamLogo(match['team_b_logo']),
                        const SizedBox(height: 8),
                        Text(
                          match['team_b_name'] ?? 'Team B',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Match date and venue
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat('MMM d, yyyy').format(startTime),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 12,
                    ),
                  ),
                  if (match['venue'] != null) ...[  
                    const SizedBox(width: 16),
                    Icon(
                      Icons.location_on,
                      size: 16,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        match['venue'],
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context, String status) {
    Color color;
    String text;
    
    switch (status) {
      case 'live':
        color = Colors.red;
        text = 'LIVE';
        break;
      case 'completed':
        color = Colors.green;
        text = 'COMPLETED';
        break;
      case 'scheduled':
        color = Colors.blue;
        text = 'UPCOMING';
        break;
      case 'cancelled':
        color = Colors.grey;
        text = 'CANCELLED';
        break;
      default:
        color = Colors.blue;
        text = status.toUpperCase();
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTeamLogo(String? logoUrl) {
    if (logoUrl != null && logoUrl.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          logoUrl,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 60,
              height: 60,
              color: Colors.grey[300],
              child: const Icon(Icons.sports, color: Colors.grey),
            );
          },
        ),
      );
    } else {
      return Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.sports, color: Colors.grey),
      );
    }
  }
}