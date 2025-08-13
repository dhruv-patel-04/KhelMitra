import 'package:flutter/material.dart';
import '../../config/app_colors.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  int _selectedTabIndex = 0;

  final List<String> sportsTabs = ["All Sports", "Kabaddi", "Cricket", "Football"];

  // Dummy match data (Replace with API data later)
  final List<Map<String, dynamic>> liveMatches = [
    {
      "sport": "Kabaddi",
      "teamA": "Team A",
      "teamB": "Team B",
      "scoreA": 28,
      "scoreB": 24,
      "status": "2nd Half",
      "color": AppColors.orange
    },
    {
      "sport": "Cricket",
      "teamA": "Team X",
      "teamB": "Team Y",
      "scoreA": "152/4",
      "scoreB": "148/6",
      "status": "20 Overs",
      "color": AppColors.green
    }
  ];

  final List<Map<String, dynamic>> upcomingMatches = [
    {
      "sport": "Football",
      "teamA": "Team M",
      "teamB": "Team N",
      "date": "25 Aug, 4:00 PM",
      "color": AppColors.navy
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("KhelMitra"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications, color: Colors.white),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sports Tab Selector
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              itemCount: sportsTabs.length,
              itemBuilder: (context, index) {
                final isSelected = index == _selectedTabIndex;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedTabIndex = index;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.green : Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        sportsTabs[index],
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Live Matches Section
                  const Text(
                    "🔴 LIVE MATCHES",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    children: liveMatches.map((match) {
                      return _buildMatchCard(
                        match['sport'],
                        match['teamA'],
                        match['teamB'],
                        match['scoreA'].toString(),
                        match['scoreB'].toString(),
                        match['status'],
                        match['color'],
                        isLive: true,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // Upcoming Matches Section
                  const Text(
                    "UPCOMING MATCHES",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    children: upcomingMatches.map((match) {
                      return _buildUpcomingMatchCard(
                        match['sport'],
                        match['teamA'],
                        match['teamB'],
                        match['date'],
                        match['color'],
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: AppColors.green,
        unselectedItemColor: AppColors.bottomTab,
        onTap: (index) {
          // TODO: Handle tab navigation
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.leaderboard), label: "Point Table"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  Widget _buildMatchCard(String sport, String teamA, String teamB, String scoreA, String scoreB, String status, Color color, {bool isLive = false}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.greyCard,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(sport, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTeamScore(teamA, scoreA),
                _buildTeamScore(teamB, scoreB),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                if (isLive)
                  const Icon(Icons.circle, color: Colors.red, size: 12),
                const SizedBox(width: 4),
                Text(status, style: const TextStyle(fontSize: 14, color: Colors.black87)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingMatchCard(String sport, String teamA, String teamB, String date, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.greyCard,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(sport, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 8),
            Text("$teamA vs $teamB", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Text(date, style: const TextStyle(fontSize: 14, color: Colors.black54)),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamScore(String team, String score) {
    return Column(
      children: [
        Text(team, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 4),
        Text(score, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
