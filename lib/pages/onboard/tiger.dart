import 'package:flutter/material.dart';

class TigerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/tiger/tiger_happy.png',
              height: 200,
              width: 200,
            ),
            SizedBox(height: 20),
            Text(
              'Welcome to Tiger World!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
