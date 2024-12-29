import 'package:flutter/material.dart';
import 'package:sywari/pages/splash_screen.dart';
import 'package:sywari/pages/tabs_screen.dart';
import 'pages/schedule_screen.dart';
import 'pages/settings_screen.dart';

class Sywari extends StatefulWidget {
  const Sywari({super.key});

  @override
  State<Sywari> createState() => _SywariState();
}

class _SywariState extends State<Sywari> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/schedule': (context) => const ScheduleScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/tabs': (context) => const TabsScreen(),
      },
    );
  }
}
