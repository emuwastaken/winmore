import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'pages/landing_page.dart';
import 'pages/admin_page.dart';

void main() {
  setUrlStrategy(PathUrlStrategy());
  runApp(const WinMoreApp());
}

class WinMoreApp extends StatelessWidget {
  const WinMoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WinMore.cards',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF111827), // darker slate
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFD4AF37),
          surface: Color(0xFF1A1A2E),
        ),
      ),

      initialRoute: '/',
      routes: {
        '/': (context) => const LandingPage(),
        '/admin': (context) => const AdminPage(),
      },
    );
  }
}