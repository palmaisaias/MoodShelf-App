import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

void main() {
  runApp(const MoodBookApp());
}

class MoodBookApp extends StatelessWidget {
  const MoodBookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Raquel\'s Pages', // Updated title
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
  bool isLoading = false;

  // New variable to control the opacity of the title
  bool _showTitle = false;

  @override
  void initState() {
    super.initState();
    // Trigger the fade-in animation after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _showTitle = true;
      });
    });
  }

  @override
  void dispose() {
    _moodController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // Fetch recommendation from the Flask backend
  Future<void> fetchBooks(String mood) async {
    if (mood.trim().isEmpty) {
      setState(() {
        bookRecommendation = "Please enter your mood.";
        showRecommendation = true;
      });
      return;
    }

    setState(() {
      isLoading = true;
      showRecommendation = false;
    });

    try {
      final url = Uri.parse(
          'http://3.143.252.206/recommend'); // Update the URL with your backend's IP or domain

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({"mood": mood}),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        setState(() {
          bookRecommendation = jsonResponse['book'];
          showRecommendation = true;
        });
      } else if (response.statusCode == 404) {
        setState(() {
          bookRecommendation = "No books found for this mood.";
          showRecommendation = true;
        });
      } else {
        setState(() {
          bookRecommendation = "An error occurred. Please try again.";
          showRecommendation = true;
        });
      }
    } catch (e) {
      setState(() {
        bookRecommendation = "Failed to connect to the server.";
        showRecommendation = true;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Applying a gradient background
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.brown.shade700, // Earthy Brown
              const Color.fromARGB(255, 35, 90, 38), // Dark Green
              const Color.fromARGB(255, 199, 87, 0), // Rich Sienna
              const Color.fromARGB(255, 123, 11, 61), // Deep Olive
              Colors.brown.shade800, // Darker Brown
            ],
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
                // App Title with Single Fade-In Animation and Icons
                AnimatedOpacity(
                  opacity: _showTitle ? 1.0 : 0.0,
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
                          child: const Text("Raquel's Pages"),
                        ),
                      ),
                      const SizedBox(
                          height: 10), // Spacing between title and icons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Reaction Icon
                          Image.asset(
                            'assets/reaction.png',
                            width: 40, // Adjust width as needed
                            height: 40, // Adjust height as needed
                          ),
                          const SizedBox(width: 20), // Spacing between icons
                          // Book Icon
                          Image.asset(
                            'assets/book.png',
                            width: 40, // Adjust width as needed
                            height: 40, // Adjust height as needed
                          ),
                        ],
                      ),
                    ],
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
                    decoration: const InputDecoration(
                      icon: Icon(FontAwesomeIcons.solidSmile,
                          color: Colors.white),
                      border: InputBorder.none,
                      hintText: 'Enter your mood',
                      hintStyle: TextStyle(color: Colors.white70),
                    ),
                    textInputAction: TextInputAction.done,
                    onSubmitted: (value) {
                      fetchBooks(value);
                    },
                  ),
                ),
                const SizedBox(height: 30),
                // Get Recommendation Button or Loading Indicator
                isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton.icon(
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
                        child: Text(bookRecommendation),
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
