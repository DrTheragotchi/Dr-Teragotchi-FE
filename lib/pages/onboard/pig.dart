import 'package:flutter/material.dart';

class PigPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/pig/pig_happy.png',
              height: 200,
              width: 200,
            ),
            SizedBox(height: 20),
            Text(
              'Welcome to Pig World!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
