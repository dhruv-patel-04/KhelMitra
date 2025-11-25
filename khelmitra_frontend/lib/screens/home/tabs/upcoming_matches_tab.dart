import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:khelmitra/providers/match_provider.dart';
import 'package:khelmitra/screens/match/match_detail_screen.dart';
import 'package:khelmitra/widgets/match_card.dart';
import 'package:khelmitra/widgets/empty_state.dart';

class UpcomingMatchesTab extends StatefulWidget {
  final int? sportId;
  
  const UpcomingMatchesTab({Key? key, this.sportId}) : super(key: key);

  @override
  State<UpcomingMatchesTab> createState() => _UpcomingMatchesTabState();
}

class _UpcomingMatchesTabState extends State<UpcomingMatchesTab> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void didUpdateWidget(UpcomingMatchesTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.sportId != oldWidget.sportId) {
      _loadData();
    }
  }

  Future<void> _loadData() async {
    await Provider.of<MatchProvider>(context, listen: false).fetchUpcomingMatches(
      sportId: widget.sportId,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    return Consumer<MatchProvider>(
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
                  onPressed: _loadData,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        
        if (matchProvider.upcomingMatches.isEmpty) {
          return const EmptyState(
            icon: Icons.event,
            title: 'No Upcoming Matches',
            message: 'There are no upcoming matches scheduled at the moment.',
          );
        }
        
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: matchProvider.upcomingMatches.length,
          itemBuilder: (context, index) {
            final match = matchProvider.upcomingMatches[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: MatchCard(
                match: match,
                isLive: false,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => MatchDetailScreen(matchId: match['id']),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}