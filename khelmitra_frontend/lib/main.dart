import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:khelmitra/providers/auth_provider.dart';
import 'package:khelmitra/providers/match_provider.dart';
import 'package:khelmitra/screens/splash_screen.dart';
import 'package:khelmitra/utils/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => MatchProvider()),
      ],
      child: MaterialApp(
        title: 'KhelMitra',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const SplashScreen(),
      ),
    );
  }
}