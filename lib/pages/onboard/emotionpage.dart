import 'package:carousel_slider/carousel_slider.dart';
import 'package:emogotchi/pages/onboard/chatpage.dart';
import 'package:emogotchi/provider/emotion_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmotionPage extends StatefulWidget {
  const EmotionPage({Key? key}) : super(key: key);

  @override
  State<EmotionPage> createState() => _EmotionPageState();
}

class _EmotionPageState extends State<EmotionPage> {
  int _selectedIndex = 0;

  final emotions = [
    {
      'image': 'assets/emoji/angry.png',
      'label': 'Angry',
      'color': Colors.redAccent,
    },
    {
      'image': 'assets/emoji/sad.png',
      'label': 'Sad',
      'color': Colors.blueAccent,
    },
    {
      'image': 'assets/emoji/happy.png',
      'label': 'Happy',
      'color': Colors.yellow.shade700,
    },
    {
      'image': 'assets/emoji/anxious.png',
      'label': 'Anxious',
      'color': Colors.purpleAccent,
    },
    {
      'image': 'assets/emoji/neutral.png',
      'label': 'Neutral',
      'color': Colors.grey,
    },
  ];

  void _navigateToChat(BuildContext context, String emotion) async {
    await Future.delayed(const Duration(milliseconds: 500));
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, __, ___) => const ChatPage(isInit: true),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedEmotion = emotions[_selectedIndex];

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 100),
            const Text(
              'How are you feeling today?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            CarouselSlider.builder(
                itemCount: emotions.length,
                options: CarouselOptions(
                  height: 400,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: true,
                  enlargeStrategy: CenterPageEnlargeStrategy.zoom,
                  scrollPhysics: BouncingScrollPhysics(),
                  viewportFraction: 0.6,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                ),
                itemBuilder: (context, index, _) {
                  final emotion = emotions[index];
                  return GestureDetector(
                    onTap: () {
                      Provider.of<EmotionProvider>(context, listen: false)
                          .setEmotion(emotion['label'] as String);
                      _navigateToChat(context, emotion['label'] as String);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          emotion['image'] as String,
                          height: 300,
                          width: 300,
                        ),
                        // Text(
                        //   emotion['label'] as String,
                        //   style: const TextStyle(
                        //     fontSize: 20,
                        //     color: Colors.black,
                        //   ),
                        // ),
                      ],
                    ),
                  );
                }),
            const SizedBox(height: 150),
          ],
        ),
      ),
    );
  }
}
