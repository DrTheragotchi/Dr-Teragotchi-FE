import 'package:emogotchi/const/theme/theme.dart';
import 'package:emogotchi/pages/main/homepage.dart';
import 'package:emogotchi/pages/initpage.dart';
import 'package:emogotchi/pages/onboard/chatpage.dart';
import 'package:emogotchi/pages/onboard/emotionpage.dart';
import 'package:emogotchi/pages/onboard/nickname.dart';
import 'package:emogotchi/pages/onboard/onboard.dart';
import 'package:emogotchi/pages/onboard/pig.dart';
import 'package:emogotchi/pages/onboard/soulmatepage.dart';
import 'package:emogotchi/pages/onboard/tiger.dart';
import 'package:emogotchi/pages/onboard/penguin.dart';
import 'package:emogotchi/pages/rootpage.dart';
import 'package:emogotchi/provider/background_provider.dart';
import 'package:emogotchi/provider/emotion_provider.dart';
import 'package:emogotchi/provider/user_provider.dart';
import 'package:emogotchi/provider/uuid_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // prefs.clear();

  runApp(const MyApp());
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
        ChangeNotifierProvider(create: (context) => BackgroundProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        home: const CheckAuthPage(),
        routes: {
          '/onboard': (context) => const OnboardPage(),
          '/pigpage': (context) => PigPage(),
          '/tigerpage': (context) => TigerPage(),
          '/penguinpage': (context) => PenguinPage(),
          '/rootpage': (context) => const RootPage(),
          '/homepage': (context) => const HomePage(),
          '/namepage': (context) => const NamePage(),
          '/chatpage': (context) => const ChatPage(),
          '/emotionpage': (context) => const EmotionPage(),
          '/soulmatepage': (context) => SoulmatePage(),
        },
      ),
    );
  }
}

class CheckAuthPage extends StatelessWidget {
  const CheckAuthPage({Key? key}) : super(key: key);

  Future<Widget> _decideStartPage(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.loadFromLocal();

    print('userName: ${userProvider.userName}');
    // userName이 저장되어 있으면 RootPage, 아니면 InitPage로
    return userProvider.userName.isNotEmpty
        ? const RootPage()
        : const InitPage();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _decideStartPage(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // 로딩 중
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasData) {
          return snapshot.data!;
        } else {
          return const InitPage(); // fallback
        }
      },
    );
  }
}
