// mood_book_app.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'mood_home_page.dart';

class MoodBookApp extends StatelessWidget {
  const MoodBookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mood Shelf',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        textTheme: GoogleFonts.latoTextTheme(),
        brightness: Brightness.dark,
      ),
      home: const MoodHomePage(),
    );
  }
}