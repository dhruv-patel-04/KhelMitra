import 'package:flutter/material.dart';
import 'package:frontend/widgets/match_card.dart';
// import '../../widgets/top_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> sports = [
    'All Sports',
    'Cricket',
    'Football',
    'Badminton',
    'Tennis'
  ];

  String selectedSport = 'All Sports';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10), //to add space
          
          // Horizontal Sports Filter
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              itemCount: sports.length,
              itemBuilder: (context, index) {
                final sport = sports[index];
                final isSelected = sport == selectedSport;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedSport = sport;
                    });
                    debugPrint("Selected Sport: $selectedSport");
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.green : Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        sport,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 0),

          Expanded(
      child: ListView.builder(
        itemCount: 10, // Replace with your data length
        itemBuilder: (context, index) {
          return MatchCard(
            sport: selectedSport,
            team1: "Team A",
            team2: "Team B",
            date: "25 Aug 2025",
            time: "5:30 PM",
          );
        },
      ),
    ),
        ],
      ),
    );
  }
}
