// mood_home_page.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'widgets/animated_title.dart'; // New widget import for the animated title

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
  bool _showTitle = false;

  @override
  void initState() {
    super.initState();
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

  Future<void> fetchBooks(String mood) async {
    // Your API logic remains unchanged
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
      final url = Uri.parse('http://3.143.252.206/recommend');
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
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/background.jpg'), // Your image path
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.5), // Adjust the opacity here
              BlendMode
                  .dstATop, // Blending mode that keeps the image visible under the opacity
            ),
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedTitle(showTitle: _showTitle),
                const SizedBox(height: 40),
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
                        width: 2),
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
                            color: Colors.white),
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
