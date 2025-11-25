import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:khelmitra/providers/match_provider.dart';
import 'package:khelmitra/screens/match/match_detail_screen.dart';
import 'package:khelmitra/widgets/match_card.dart';
import 'package:khelmitra/widgets/empty_state.dart';

class LiveMatchesTab extends StatefulWidget {
  final int? sportId;
  
  const LiveMatchesTab({Key? key, this.sportId}) : super(key: key);

  @override
  State<LiveMatchesTab> createState() => _LiveMatchesTabState();
}

class _LiveMatchesTabState extends State<LiveMatchesTab> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void didUpdateWidget(LiveMatchesTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.sportId != oldWidget.sportId) {
      _loadData();
    }
  }

  Future<void> _loadData() async {
    await Provider.of<MatchProvider>(context, listen: false).fetchLiveMatches(
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
        
        if (matchProvider.liveMatches.isEmpty) {
          return const EmptyState(
            icon: Icons.sports_score,
            title: 'No Live Matches',
            message: 'There are no live matches at the moment. Check back later!',
          );
        }
        
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: matchProvider.liveMatches.length,
          itemBuilder: (context, index) {
            final match = matchProvider.liveMatches[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: MatchCard(
                match: match,
                isLive: true,
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