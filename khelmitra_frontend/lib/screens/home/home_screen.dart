import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:khelmitra/providers/auth_provider.dart';
import 'package:khelmitra/providers/match_provider.dart';
import 'package:khelmitra/screens/auth/login_screen.dart';
import 'package:khelmitra/screens/home/tabs/live_matches_tab.dart';
import 'package:khelmitra/screens/home/tabs/upcoming_matches_tab.dart';
import 'package:khelmitra/screens/home/tabs/completed_matches_tab.dart';
import 'package:khelmitra/screens/profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int? _selectedSportId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final matchProvider = Provider.of<MatchProvider>(context, listen: false);
    await matchProvider.fetchSports();
    await matchProvider.refreshAllMatches(sportId: _selectedSportId);
  }

  Future<void> _refreshData() async {
    await Provider.of<MatchProvider>(context, listen: false).refreshAllMatches(
      sportId: _selectedSportId,
    );
  }

  void _logout() async {
    await Provider.of<AuthProvider>(context, listen: false).logout();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KhelMitra'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: Column(
          children: [
            // Sports filter
            Consumer<MatchProvider>(
              builder: (context, matchProvider, _) {
                if (matchProvider.sports.isEmpty) {
                  return const SizedBox.shrink();
                }
                
                return Container(
                  height: 50,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: matchProvider.sports.length + 1, // +1 for "All Sports"
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        // "All Sports" option
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: const Text('All Sports'),
                            selected: _selectedSportId == null,
                            onSelected: (selected) {
                              if (selected) {
                                setState(() {
                                  _selectedSportId = null;
                                });
                                _refreshData();
                              }
                            },
                          ),
                        );
                      }
                      
                      final sport = matchProvider.sports[index - 1];
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(sport['name']),
                          selected: _selectedSportId == sport['id'],
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedSportId = sport['id'];
                              });
                              _refreshData();
                            }
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            
            // Tab bar
            TabBar(
              controller: _tabController,
              onTap: (index) {
                _refreshData();
              },
              tabs: const [
                Tab(text: 'Live'),
                Tab(text: 'Upcoming'),
                Tab(text: 'Completed'),
              ],
            ),
            
            // Tab content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  LiveMatchesTab(sportId: _selectedSportId),
                  UpcomingMatchesTab(sportId: _selectedSportId),
                  CompletedMatchesTab(sportId: _selectedSportId),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}