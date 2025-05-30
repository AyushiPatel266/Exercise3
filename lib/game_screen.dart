import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'level_selection_screen.dart';

class Ball {
  double x;
  double y;
  Color color;

  Ball({required this.x, required this.y, required this.color});
}

class GameScreen extends StatefulWidget {
  final int maxBalls;
  const GameScreen({super.key, required this.maxBalls});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  double bucketX = 0.0;
  int score = 0;
  int lives = 3;
  late Timer ballDropTimer;
  bool gameOver = false;
  List<Ball> balls = [];
  final List<Color> ballColors = [
    Colors.orange, Colors.green, Colors.blue, Colors.red, Colors.yellow.shade700, Colors.pink, Colors.teal,
  ];

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    gameOver = false;
    score = 0;
    lives = 3;
    balls = [generateBall()];
    ballDropTimer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      setState(() {
        for (var ball in balls) {
          ball.y += 0.03;
        }

        balls.removeWhere((ball) {
          if (ball.y >= 1.0) {
            if ((ball.x - bucketX).abs() < 0.2) {
              score++;
              if (score >= widget.maxBalls) {
                ballDropTimer.cancel();
                showResultDialog("🎉 You Win!", "You caught all the balls!");
              }
            } else {
              lives--;
              if (lives == 0) {
                ballDropTimer.cancel();
                showResultDialog("💔 Game Over", "You lost all your lives.");
              }
            }
            return true;
          }
          return false;
        });

        while (balls.length < 1 || (score >= 30 && balls.length < 3)) {
          balls.add(generateBall());
        }
      });
    });
  }

  Ball generateBall() {
    return Ball(
      x: Random().nextDouble() * 2 - 1,
      y: -1.0,
      color: ballColors[Random().nextInt(ballColors.length)],
    );
  }

  void moveBucket(double dx) {
    setState(() {
      bucketX += dx;
      if (bucketX < -1.0) bucketX = -1.0;
      if (bucketX > 1.0) bucketX = 1.0;
    });
  }

  void showResultDialog(String title, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white,
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
        content: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.5, // Max 50% of screen height
              minWidth: double.infinity, // Fill width
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  "$message\n\nYour score: $score",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 24),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 16,
                  runSpacing: 10,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        startGame();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                      child: const Text('🔁 Play Again', style: TextStyle(color: Colors.white)),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => LevelSelectionScreen()),
                              (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                      child: const Text('🏠 Main Screen', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    ballDropTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
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
        child: SafeArea(
          child: GestureDetector(
            onHorizontalDragUpdate: (details) {
              moveBucket(details.delta.dx / MediaQuery.of(context).size.width * 2);
            },
            child: Stack(
              children: [
                Positioned(top: 30, left: 20, child: _buildScoreDisplay()),
                Positioned(top: 30, right: 20, child: _buildLivesDisplay()),
                ...balls.map((ball) => Align(
                  alignment: Alignment(ball.x, ball.y),
                  child: Container(
                    width: 30, height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ball.color,
                      boxShadow: [BoxShadow(color: ball.color.withOpacity(0.4), blurRadius: 8, spreadRadius: 2)],
                    ),
                  ),
                )),
                Align(alignment: Alignment(bucketX, 0.9), child: _buildBucket()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScoreDisplay() => Container(
    padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.85),
      borderRadius: BorderRadius.circular(16),
      boxShadow: [BoxShadow(color: Colors.purpleAccent.withOpacity(0.2), blurRadius: 10, offset: Offset(0, 3))],
    ),
    child: Text("🏆 Score: $score", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
  );

  Widget _buildLivesDisplay() => Container(
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.85),
      borderRadius: BorderRadius.circular(16),
      boxShadow: [BoxShadow(color: Colors.redAccent.withOpacity(0.2), blurRadius: 10, offset: Offset(0, 3))],
    ),
    child: Row(children: List.generate(lives, (index) => Icon(Icons.favorite_rounded, color: Colors.redAccent, size: 26))),
  );

  Widget _buildBucket() => Stack(
    alignment: Alignment.bottomCenter,
    children: [
      Container(
        width: 100, height: 45,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.deepPurple.shade300, Colors.deepPurple.shade600], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          borderRadius: BorderRadius.vertical(top: Radius.circular(12), bottom: Radius.circular(20)),
          boxShadow: [BoxShadow(color: Colors.deepPurple.withOpacity(0.3), blurRadius: 10, offset: Offset(0, 4))],
        ),
      ),
      Container(width: 90, height: 12, decoration: BoxDecoration(color: Colors.deepPurple.shade800, borderRadius: BorderRadius.circular(6))),
    ],
  );
}