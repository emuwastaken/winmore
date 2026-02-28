import 'package:flutter/material.dart';
import 'pages/landing_page.dart';

void main() {
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
        scaffoldBackgroundColor: const Color(0xFF1A1A2E),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFD4AF37),   // gold accent
          surface: Color(0xFF1A1A2E),
        ),
      ),
      home: const LandingPage(),
    );
  }
}
