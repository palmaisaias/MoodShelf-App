import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// Uncomment these lines if you're planning to fetch data in the future
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'dart:async';

void main() {
  runApp(MoodBookApp());
}

class MoodBookApp extends StatelessWidget {
  const MoodBookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mood Book Recommendation',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        textTheme: GoogleFonts.latoTextTheme(),
        brightness: Brightness.dark,
      ),
      home: MoodHomePage(),
    );
  }
}

class MoodHomePage extends StatefulWidget {
  const MoodHomePage({super.key});

  @override
  _MoodHomePageState createState() => _MoodHomePageState();
}

class _MoodHomePageState extends State<MoodHomePage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _moodController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String bookRecommendation = "";
  bool showRecommendation = false;

  @override
  void dispose() {
    _moodController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void fetchBooks(String mood) {
    // Simulate fetching data with a delay
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        bookRecommendation = "Recommended Book for \"$mood\" Mood";
        showRecommendation = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Applying a gradient background
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo.shade900, Colors.indigo.shade500],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Title with Animation
                SizedBox(
                  height: 80,
                  child: DefaultTextStyle(
                    style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    child: AnimatedTextKit(
                      animatedTexts: [
                        FadeAnimatedText('Mood Book'),
                        FadeAnimatedText('Recommendation'),
                      ],
                      // Removed 'isRepeatingCursor' parameter
                      repeatForever:
                          true, // Set to false if you don't want it to repeat
                      // You can also use 'totalRepeatCount: 1' to control the repetitions
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // Mood Input Field with Animation
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: EdgeInsets.symmetric(
                      horizontal: 20, vertical: _focusNode.hasFocus ? 15 : 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: _focusNode.hasFocus
                          ? Colors.white
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: TextField(
                    controller: _moodController,
                    focusNode: _focusNode,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      icon: Icon(FontAwesomeIcons.solidSmile,
                          color: Colors.white),
                      border: InputBorder.none,
                      hintText: 'Enter your mood',
                      hintStyle: const TextStyle(color: Colors.white70),
                    ),
                    textInputAction: TextInputAction.done,
                    onSubmitted: (value) {
                      fetchBooks(value);
                    },
                  ),
                ),
                const SizedBox(height: 30),
                // Get Recommendation Button
                ElevatedButton.icon(
                  onPressed: () {
                    String mood = _moodController.text;
                    fetchBooks(mood);
                  },
                  icon: const Icon(Icons.search),
                  label: const Text('Get Book Recommendation'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    backgroundColor: Colors.indigoAccent,
                    textStyle: const TextStyle(fontSize: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                // Animated Book Recommendation Display
                if (showRecommendation)
                  AnimatedOpacity(
                    opacity: showRecommendation ? 1.0 : 0.0,
                    duration: const Duration(seconds: 1),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: DefaultTextStyle(
                        style: const TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        child: AnimatedTextKit(
                          animatedTexts: [
                            TypewriterAnimatedText(bookRecommendation),
                          ],
                          totalRepeatCount: 1,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
