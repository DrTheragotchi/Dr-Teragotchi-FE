import 'package:emogotchi/const/theme/theme.dart';
import 'package:emogotchi/pages/homepage.dart';
import 'package:emogotchi/pages/initpage.dart';
import 'package:emogotchi/pages/onboard/chatpage.dart';
import 'package:emogotchi/pages/onboard/emotionpage.dart';
import 'package:emogotchi/pages/onboard/nickname.dart';
import 'package:emogotchi/pages/onboard/onboard.dart';
import 'package:emogotchi/pages/onboard/pig.dart';
import 'package:emogotchi/pages/onboard/soulmatepage.dart';
import 'package:emogotchi/pages/onboard/tiger.dart';
import 'package:emogotchi/pages/onboard/penguin.dart';
import 'package:emogotchi/provider/emotion_provider.dart';
import 'package:emogotchi/provider/user_provider.dart';
import 'package:emogotchi/provider/uuid_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Ensure 'provider' is added in pubspec.yaml

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => DeviceInfoProvider()),
        ChangeNotifierProvider(create: (context) => EmotionProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        initialRoute: '/',
        routes: {
          '/': (context) => InitPage(),
          '/onboard': (context) => OnboardPage(),
          '/pigpage': (context) => PigPage(),
          '/tigerpage': (context) => TigerPage(),
          '/penguinpage': (context) => PenguinPage(),
          '/homepage': (context) => HomePage(),
          '/namepage': (context) => NamePage(),
          '/chatpage': (context) => ChatPage(),
          '/emotionpage': (context) => EmotionPage(),
          '/soulmatepage': (context) => SoulmatePage(),
        },
      ),
    );
  }
}
