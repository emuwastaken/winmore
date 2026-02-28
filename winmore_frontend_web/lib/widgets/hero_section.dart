import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> {

  String? _statusMessage;
  bool _isError = false;
  Timer? _messageTimer;

  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    _messageTimer?.cancel();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    final input = _controller.text.trim();
    if (input.isEmpty) return;

    final response = await http.post(
      Uri.parse('http://localhost:8080/api/analyze'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'url': input}),
    );

    final body = jsonDecode(response.body);

    setState(() {
      _isError = response.statusCode != 200;
      _statusMessage = _isError ? body['error'] : 'Deck loaded: ${body['deckName']}';
    });

    _messageTimer?.cancel();
    _messageTimer = Timer(const Duration(seconds: 10), () {
      setState(() => _statusMessage = null);
    });
  }

  double _getHeroHeight(double width) {
    if (width > 1200) return width * 9 / 21;
    if (width > 800)  return width * 9 / 16;
    if (width > 600)  return width * 3 / 4;
    return 500;
  }

  String _getBackgroundImage(double width) {
    if (width > 800) return 'assets/images/hero_bg.jpg';
    if (width > 600) return 'assets/images/hero_tablet.jpg';
    return 'assets/images/hero_mobile.jpg';
  }

  double _getInputWidth(double width) {
    if (width > 1400) return 800;
    if (width > 1000) return width * 0.55;
    if (width > 800)  return width * 0.70;
    if (width > 600)  return width * 0.85;
    return double.infinity;
  }

  double _getPadding(double width) {
    if (width > 1200) return 120;
    if (width > 800)  return 80;
    if (width > 600)  return 48;
    return 24;
  }

  double _getHeadlineSize(double width) {
    if (width > 1200) return 72;
    if (width > 800)  return 56;
    if (width > 600)  return 44;
    return 36;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = _getHeroHeight(width);
        final inputWidth = _getInputWidth(width);
        final padding = _getPadding(width);
        final headlineSize = _getHeadlineSize(width);
        final isMobile = width < 600;

        return SizedBox(
          width: double.infinity,
          height: height,
          child: Stack(
            fit: StackFit.expand,
            children: [

              // Layer 1 — background image with smooth transition
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 600),
                child: Image.asset(
                  _getBackgroundImage(width),
                  key: ValueKey(_getBackgroundImage(width)),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  alignment: Alignment.topCenter,
                ),
              ),

              // Layer 2 — blur + dark overlay
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                child: Container(
                  color: Colors.black.withOpacity(0.50),
                ),
              ),

              // Layer 3 — content
              Padding(
                padding: EdgeInsets.symmetric(horizontal: padding, vertical: 60),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    // Headline
                    Text(
                      'Is your deck\nwin-more?',
                      style: TextStyle(
                        fontSize: headlineSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.1,
                        shadows: const [
                          Shadow(
                            offset: Offset(0, 0),
                            blurRadius: 1,
                            color: Colors.black,
                          ),
                          Shadow(
                            offset: Offset(0, 0),
                            blurRadius: 3,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Subtitle
                    Text(
                      'Paste your Archidekt link or decklist below.\nWe\'ll tell you if you\'re winning because you\'re good\nor because you\'re already ahead.',
                      style: TextStyle(
                        fontSize: isMobile ? 14 : 16,
                        color: Colors.white70,
                        height: 1.6,
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Input row — width constrained by breakpoint
                    SizedBox(
                      width: inputWidth,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _controller,
                                  onSubmitted: (_) => _onSubmit(),
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: 'Paste Archidekt URL or decklist...',
                                    hintStyle: const TextStyle(color: Colors.white38),
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.08),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 18,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(
                                        color: Color(0xFFD4AF37),
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 12),

                              SizedBox(
                                height: 56,
                                child: ElevatedButton(
                                  onPressed: _onSubmit,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF5C589E),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 28),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text(
                                    'Analyze',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Status message — visible for 10 seconds after submit
                          if (_statusMessage != null) ...[
                            const SizedBox(height: 12),
                            Text(
                              _statusMessage!,
                              style: TextStyle(
                                color: _isError
                                    ? Colors.redAccent
                                    : const Color(0xFFD4AF37),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}