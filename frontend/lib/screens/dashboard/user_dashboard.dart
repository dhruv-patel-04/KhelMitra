import 'package:flutter/material.dart';
import 'package:frontend/widgets/top_bar.dart';
import '../../widgets/bottom_navbar.dart';
import '../dashboard/home_screen.dart';
import '../dashboard/recent_matches_screen.dart';
import '../dashboard/profile_screen.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    RecentMatchesScreen(),
    ProfileScreen(),
  ];

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _refreshData() {
    // Add your refresh logic here
    debugPrint("Home screen refreshed");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(onRefresh: _refreshData),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTabSelected: _onTabSelected,
      ),
    );
  }
}
