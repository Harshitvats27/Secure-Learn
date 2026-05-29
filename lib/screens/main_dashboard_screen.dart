import 'dart:async'; // Timer ke liye zaroori hai
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MainDashboardScreen extends StatefulWidget {
  final String role;

  const MainDashboardScreen({super.key, required this.role});

  @override
  State<MainDashboardScreen> createState() => _MainDashboardScreenState();
}

class _MainDashboardScreenState extends State<MainDashboardScreen> {
  int totalPoints = 0;

  // --- QUOTE ANIMATION VARIABLES ---
  int _currentQuoteIndex = 0;
  final num _timerSeconds = 5; // Har 7 second mein quote badlega
  StreamSubscription? _quoteTimer;

  // 15 Cybersecurity Quotes ki List
  final List<Map<String, String>> cyberQuotes = [
    {
      "quote": "Amateurs hack systems, professionals hack people.",
      "author": "Bruce Schneier",
    },
    {
      "quote": "Security is not a product, but a process.",
      "author": "Bruce Schneier",
    },
    {
      "quote":
          "There are only two types of companies: those that have been hacked, and those that will be.",
      "author": "Robert Mueller",
    },
    {
      "quote":
          "If you think technology can solve your security problems, then you don't understand the problems and you don't understand the technology.",
      "author": "Bruce Schneier",
    },
    {
      "quote":
          "The only truly secure system is one that is powered off and cast in concrete.",
      "author": "Gene Spafford",
    },
    {
      "quote":
          "Password encryption is like putting a cardboard lock on a vault.",
      "author": "Unknown",
    },
    {
      "quote":
          "Privacy is not an option, and it shouldn't be the price we pay for just getting on the Internet.",
      "author": "Gary Kovacs",
    },
    {
      "quote":
          "Cybersecurity is a shared responsibility, and it boils down to this: in cybersecurity, the more systems we secure, the more secure we all are.",
      "author": "Jeh Johnson",
    },
    {
      "quote":
          "Companies spend millions of dollars on firewalls and secure access devices, and it's money wasted because none of these measures address the weakest link in the security chain: the people.",
      "author": "Kevin Mitnick",
    },
    {
      "quote":
          "As cyberactors become more sophisticated, we must also become more sophisticated in our defense.",
      "author": "Janet Napolitano",
    },
    {
      "quote":
          "One individual's cyber hygiene can affect an entire network's safety.",
      "author": "Unknown",
    },
    {
      "quote":
          "Technology trusts code. People trust people. Hackers exploit both.",
      "author": "Unknown",
    },
    {
      "quote":
          "The digital world is not a separate place. It is a reflection of our physical vulnerabilities.",
      "author": "Unknown",
    },
    {
      "quote":
          "A computer once beat me at chess, but it was no match for me at kick boxing.",
      "author": "Emo Philips",
    },
    {
      "quote":
          "Hardware is easy to protect: lock it in a room, chain it to a desk, or buy a spare. Information is harder to protect.",
      "author": "Unknown",
    },
  ];

  @override
  void initState() {
    super.initState();
    fetchUserScore();
    _startQuoteTimer(); // Screen load hote hi timer start
  }

  @override
  void dispose() {
    _quoteTimer?.cancel(); // Screen band hone par timer close karna zaroori hai
    super.dispose();
  }

  // Timer function jo index change karega
  void _startQuoteTimer() {
    _quoteTimer = Stream.periodic(Duration(seconds: _timerSeconds.toInt()))
        .listen((_) {
          if (mounted) {
            setState(() {
              _currentQuoteIndex =
                  (_currentQuoteIndex + 1) % cyberQuotes.length;
            });
          }
        });
  }

  Future<void> fetchUserScore() async {
    try {
      String? uid = FirebaseAuth.instance.currentUser?.uid;

      // Temporary hardcoded UID for testing (Uncomment if needed)
      // String uid = "3z25emPx6pV1A1zJu7VxSK6MYG22";

      if (uid == null) {
        print("User is not logged in!");
        return;
      }

      final userDoc = await FirebaseFirestore.instance
          .collection('leaderboard')
          .doc(uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          totalPoints = (userDoc.data()?['score'] ?? 0) as int;
        });
      } else {
        print("Document does not exist in leaderboard!");
      }
    } catch (e) {
      print("Error fetching user score: $e");
    }
  }

  Widget buildStatCard(String title, String value, Color color, IconData icon) {
    return Animate(
      effects: const [FadeEffect(duration: Duration(milliseconds: 500))],
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.8), color.withOpacity(0.6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 28, color: Colors.white),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(title, style: const TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : const Color(0xFFF6F6F6),
      appBar: AppBar(
        title: Text(
          "SecureLearn Dashboard",
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
        ),
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.deepPurple,
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          onPressed: () => ZoomDrawer.of(context)!.toggle(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Category: ${widget.role}",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Your Progress",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    buildStatCard(
                      "Total Points",
                      "$totalPoints",
                      Colors.deepPurple,
                      Icons.star,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // --- REPLACED "RECENT ACTIVITIES" WITH HACKER WISDOM ---
              Text(
                "Hacker Wisdom",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 12),
// --- HACKER WISDOM CONTAINER (OVERFLOW FIXED) ---
              Container(
                width: double.infinity,
                // FIX 1: Fixed height hatakar BoxConstraints lagaya
                constraints: const BoxConstraints(minHeight: 180),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDarkMode ? const Color(0xFF1A1A24) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.deepPurple.withOpacity(0.5), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepPurple.withOpacity(0.15),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 600),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.0, 0.1),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: Column(
                    key: ValueKey<int>(_currentQuoteIndex),
                    // FIX 2: Yeh sabse zaroori line hai tere error ke liye!
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                          Icons.format_quote_rounded,
                          color: Colors.deepPurpleAccent,
                          size: 36
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "\"${cyberQuotes[_currentQuoteIndex]['quote']}\"",
                        style: TextStyle(
                          fontSize: 15,
                          fontStyle: FontStyle.italic,
                          color: isDarkMode ? Colors.white.withOpacity(0.9) : Colors.black87,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "— ${cyberQuotes[_currentQuoteIndex]['author']}",
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurpleAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
