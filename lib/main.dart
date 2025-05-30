import 'package:flutter/material.dart';
import 'level_selection_screen.dart';

void main() {
  runApp(BucketBallGame());
}

class BucketBallGame extends StatelessWidget {
  const BucketBallGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LevelSelectionScreen(),
    );
  }
}