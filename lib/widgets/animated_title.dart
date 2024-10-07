// widgets/animated_title.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnimatedTitle extends StatelessWidget {
  final bool showTitle;
  const AnimatedTitle({super.key, required this.showTitle});

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: showTitle ? 1.0 : 0.0,
      duration: const Duration(seconds: 2),
      curve: Curves.easeIn,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 80,
            child: DefaultTextStyle(
              style: GoogleFonts.cinzelDecorative(
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              child: const Text("MoodShelf"),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}