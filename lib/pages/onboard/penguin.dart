import 'package:emogotchi/components/chatbubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PenguinPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  'assets/penguin/penguin_happy.png', // Replace with your image path
                  height: 200,
                  width: 200,
                ),
                // CustomChatBubble(
                //   message: chatMessages["send"]!,
                //   alignment: Alignment.topRight,
                //   bubbleType: BubbleType.sendBubble,
                //   imageAsset: imageAssetGirl,
                //   backgroundColor: Color.fromRGBO(235, 227, 209, 1),
                // ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Welcome to Penguin World!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
