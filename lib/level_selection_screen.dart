import 'package:flutter/material.dart';
import 'game_screen.dart';

class LevelSelectionScreen extends StatelessWidget {
  const LevelSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFBF80D2),
              Color(0xFFD69ADE),
              Color(0xFFE1AEE3),
              Color(0xFFEABDE6),
              Color(0xFFF3CBE9),
              Color(0xFFFFDFEF),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "🎮 Choose Level",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 30),
              _LevelButton(text: "Beginner", maxBalls: 15),
              _LevelButton(text: "Intermediate", maxBalls: 25),
              _LevelButton(text: "Advanced", maxBalls: 35),
              _LevelButton(text: "Expert", maxBalls: 50),
              _LevelButton(text: "Legend", maxBalls: 75),
            ],
          ),
        ),
      ),
    );
  }
}

class _LevelButton extends StatefulWidget {
  final String text;
  final int maxBalls;

  const _LevelButton({required this.text, required this.maxBalls, super.key});

  @override
  State<_LevelButton> createState() => _LevelButtonState();
}

class _LevelButtonState extends State<_LevelButton> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovering = true),
        onExit: (_) => setState(() => _isHovering = false),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GameScreen(maxBalls: widget.maxBalls),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            backgroundColor: _isHovering ? Colors.deepPurple[300] : Colors.deepPurple[700],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 5,
            shadowColor: Colors.deepPurpleAccent,
          ),
          child: Text(
            widget.text,
            style: const TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ),
    );
  }
}