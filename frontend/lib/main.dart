import 'package:flutter/material.dart';
import 'package:frontend/screens/dashboard/user_dashboard.dart';
import 'config/app_colors.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';

void main() {
  runApp(const KhelMitraApp());
}

class KhelMitraApp extends StatelessWidget {
  const KhelMitraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KhelMitra',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.green,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.green,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/dashboard': (context) => const UserDashboard(),
      },
    );
  }
}
