import 'package:flutter/material.dart';
import '../../widgets/nav_bar.dart';
import '../../widgets/hero_section.dart';
import '../../widgets/features_section.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //NavBar(),
            HeroSection(),
            FeaturesSection(),
          ],
        ),
      ),
    );
  }
}
