import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:khelmitra/providers/match_provider.dart';
import 'package:khelmitra/screens/match/match_detail_screen.dart';
import 'package:khelmitra/widgets/match_card.dart';
import 'package:khelmitra/widgets/empty_state.dart';

class CompletedMatchesTab extends StatefulWidget {
  final int? sportId;
  
  const CompletedMatchesTab({Key? key, this.sportId}) : super(key: key);

  @override
  State<CompletedMatchesTab> createState() => _CompletedMatchesTabState();
}

class _CompletedMatchesTabState extends State<CompletedMatchesTab> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void didUpdateWidget(CompletedMatchesTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.sportId != oldWidget.sportId) {
      _loadData();
    }
  }

  Future<void> _loadData() async {
    await Provider.of<MatchProvider>(context, listen: false).fetchCompletedMatches(
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
        
        if (matchProvider.completedMatches.isEmpty) {
          return const EmptyState(
            icon: Icons.history,
            title: 'No Completed Matches',
            message: 'There are no completed matches to display.',
          );
        }
        
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: matchProvider.completedMatches.length,
          itemBuilder: (context, index) {
            final match = matchProvider.completedMatches[index];
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