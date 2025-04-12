import 'package:flutter/material.dart';
import 'dart:math';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String selectedBackground;

  final List<String> background = [
    'assets/background/airport.png',
    'assets/background/lake.png',
    'assets/background/mountain.png',
    'assets/background/park.png',
    'assets/background/school.png',
  ];

  int getRandomInt() {
    return Random().nextInt(background.length); // 0 ~ 4
  }

  @override
  void initState() {
    super.initState();
    selectedBackground = background[getRandomInt()];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            selectedBackground,
            fit: BoxFit.cover,
          ),
          Image.asset(
            'assets/penguin/penguin_happy.png',
            height: 100,
          ),
        ],
      ),
    );
  }
}
