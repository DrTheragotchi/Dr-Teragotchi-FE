import 'dart:async';

import 'package:emogotchi/api/api.dart';
import 'package:emogotchi/components/home_chat.dart';
import 'package:emogotchi/pages/onboard/chatpage.dart';
import 'package:emogotchi/provider/background_provider.dart';
import 'package:emogotchi/provider/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _moveAnimation;
  late Animation<double> _tiltAnimation;
  late String selectedMessage;

  /* ------------------------------ */
  late String animalType;
  late String animalMood;
  int points = 0;
  int level = 0;
  int riceLevel = 0;
  int streak = 0;
  String uuid = '';
  bool _isEyeOpen = true;
  Timer? _blinkTimer;

  bool _firstJumpDone = false;

  final List<String> background = [
    'assets/background/airport.png',
    'assets/background/lake.png',
    'assets/background/mountain.png',
    'assets/background/park.png',
    'assets/background/school.png',
  ];
  List<String> aniamlMessages = [
    "It's okay to not be okay. You’re doing your best and that’s enough",
    "You are not alone. I'm here with you always",
    "Even small steps are progress. Be proud of yourself",
    "Your feelings are valid. It’s okay to feel everything you're feeling",
    "You’ve made it through 100 percent of your worst days. You’re stronger than you think",
    "Just for today breathe. That’s more than enough",
    "There’s no rush. You can take your time to heal",
    "You are more than your sadness. There’s light in you too",
    "Some days are hard. Be gentle with yourself today",
    "You don’t have to carry everything all at once",
    "Your presence matters even if you can’t see it right now",
    "It’s brave to ask for help. You deserve support",
    "Rest is not a weakness. It’s part of being human",
    "The world is better with you in it. Don’t forget that",
    "You are worthy of love care and kindness",
    "Take things one breath one moment at a time",
    "You are not a burden. Your pain is real and so is your courage",
    "Healing isn’t linear and that’s perfectly okay",
    "Your story isn’t over. This is just one chapter",
    "You’ve come so far. That matters even if you can’t see it yet",
  ];

  int getRandomInt() {
    return Random().nextInt(background.length);
  }

  @override
  void initState() {
    super.initState();
    _setupAnimation();
    _setup();
  }

  Future<void> _setup() async {
    final prefs = await SharedPreferences.getInstance();
    uuid = prefs.getString('uuid') ?? '';

    print('📦 로컬에서 불러온 uuid: $uuid');

    if (uuid.isNotEmpty) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final response = await ApiService().getUser(uuid.trim());

      userProvider.setUserData(
        uuid: response['uuid'] ?? uuid,
        emotion: response['animal_emotion'] ?? userProvider.emotion,
        animal: response['animal_type'] ?? userProvider.animalType,
        animalLevel:
            response['animal_level']?.toString() ?? userProvider.animalLevel,
        points: response['points'] ?? userProvider.points,
        userName: response['nickname'] ?? userProvider.userName,
        isNotified: response['is_notified'] ?? userProvider.isNotified,
      );

      setState(() {
        animalMood = response['animal_emotion'] ?? 'neutral';
        animalType = response['animal_type'] ?? 'penguin';
        points = response['points'] ?? 0;
        level = int.tryParse(response['animal_level']?.toString() ?? '') ?? 1;
      });
    }
  }

  void _setupAnimation() {
    final bgProvider = Provider.of<BackgroundProvider>(context, listen: false);

    if (bgProvider.selectedBackground == null) {
      final randomBg = background[getRandomInt()];
      bgProvider.setBackground(randomBg);
    }

    selectedMessage = aniamlMessages[Random().nextInt(aniamlMessages.length)];

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _moveAnimation = Tween<double>(begin: 0, end: 16).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutBack),
    );

    _tiltAnimation = Tween<double>(begin: -0.05, end: 0.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_controller.isAnimating && _firstJumpDone) {
      _controller.forward().then((_) {
        _controller.repeat(reverse: true);
      });
    }

    final userInfoProvider = Provider.of<UserProvider>(context, listen: false);
    final rawMood = userInfoProvider.getEmotion;
    final rawType = userInfoProvider.getAnimalType;

    animalMood = (rawMood.isEmpty) ? 'neutral' : rawMood;
    animalType = (rawType.isEmpty) ? 'penguin' : rawType;
    points = userInfoProvider.getPoints;

    print('animalType: $animalType');
    print('animalMood: $animalMood');
    print('points: $points');

    if (animalMood == 'neutral' && _blinkTimer == null) {
      _blinkTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (mounted) {
          setState(() {
            _isEyeOpen = !_isEyeOpen;
          });
        }
      });
    }

    if (uuid.isNotEmpty) {
      ApiService().getUser(uuid).then((response) {
        print('User data: $response');
        userInfoProvider.setUserData(
          uuid: response['uuid'] ?? uuid,
          emotion: response['animal_emotion'] ?? userInfoProvider.emotion,
          animal: response['animal_type'] ?? userInfoProvider.animalType,
          animalLevel: response['animal_level']?.toString() ??
              userInfoProvider.animalLevel,
          points: response['points'] ?? userInfoProvider.points,
          userName: response['nickname'] ?? userInfoProvider.userName,
          isNotified: response['is_notified'] ?? userInfoProvider.isNotified,
        );
        setState(() {
          animalMood = response['animal_emotion'] ?? 'neutral';
          animalType = response['animal_type'] ?? 'penguin';
          points = response['points'] ?? 0;
        });
      });
    }
  }

  void startAnimalAnimation() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _controller.forward().then((_) {
          _controller.repeat(reverse: true);
          setState(() {
            _firstJumpDone = true;
          });
        });
      }
    });
  }

  Widget _animalImage({bool animated = true}) {
    String imagePath;

    if (animalMood == 'neutral') {
      final eyeState = _isEyeOpen ? 'eye_open' : 'eye_close';
      imagePath = 'assets/$animalType/${animalType}_$eyeState.png';
    } else {
      imagePath = 'assets/$animalType/${animalType}_${animalMood}.png';
    }

    final image = Image.asset(
      imagePath,
      fit: BoxFit.contain,
    );

    return SizedBox(
      height: 180,
      child: animated
          ? AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, -_moveAnimation.value),
                  child: Transform.rotate(
                    angle: _firstJumpDone ? _tiltAnimation.value : 0,
                    child: child,
                  ),
                );
              },
              child: image,
            )
          : image,
    );
  }

  Widget _flightShuttleBuilder(
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection flightDirection,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    return _animalImage(animated: false);
  }

  @override
  void dispose() {
    _blinkTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedBackground =
        Provider.of<BackgroundProvider>(context).selectedBackground ??
            'assets/background/airport.png';

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            selectedBackground,
            fit: BoxFit.cover,
          ),
          Positioned(
            top: 60,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  height: 45,
                  width: 220,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Center(
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        SizedBox(
                          width: 200,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: riceLevel / 5,
                              minHeight: 15,
                              backgroundColor: Colors.grey.withOpacity(0.3),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.orangeAccent),
                            ),
                          ),
                        ),
                        Positioned(
                          left: -8,
                          top: -8,
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor:
                                Colors.yellowAccent.withOpacity(0.7),
                            child: Image.asset(
                              'assets/homepage/rice.png',
                              height: 30,
                              width: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                StatusButton(false, points),
                const SizedBox(height: 6),
                StatusButton(true, level),
                const SizedBox(height: 6),
                StatusButton(true, streak),
              ],
            ),
          ),
          Positioned(
            bottom: 295,
            left: 0,
            right: 0,
            child: points >= 20
                ? Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                      ),
                      onPressed: () async {
                        if (points >= 20 && riceLevel < 10) {
                          setState(() {
                            points -= 20;
                            riceLevel += 1;
                          });

                          try {
                            await ApiService().updateUserPoints(uuid, points);
                            print("🎯 서버에 포인트 반영 완료: $points");
                          } catch (e) {
                            print("❌ 포인트 업데이트 실패: $e");
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("서버에 포인트 업데이트 중 문제가 발생했어요."),
                              ),
                            );
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text("🍚 밥 레벨이 올라갔어요! 현재 레벨: $riceLevel"),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                      child: Text(
                        "🍚 Feed (-20 Coins)",
                        style:
                            const TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      HapticFeedback.mediumImpact();
                      startAnimalAnimation();
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          settings: RouteSettings(
                            name: '/chatpage',
                            arguments: {
                              'emotion': '',
                            },
                          ),
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  ChatPage(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return FadeTransition(
                                opacity: animation, child: child);
                          },
                          transitionDuration: const Duration(milliseconds: 500),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: HomeChatBubble(text: selectedMessage),
                    ),
                  ),
          ),
          Positioned(
            bottom: 105,
            left: 0,
            right: 0,
            child: Center(
              child: Hero(
                tag: 'penguinHero',
                flightShuttleBuilder: _flightShuttleBuilder,
                child: _animalImage(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget StatusButton(bool isStreak, int value) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(30),
      ),
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 15,
            backgroundColor: isStreak
                ? Colors.orangeAccent.withOpacity(0.7)
                : Colors.blue.withOpacity(0.7),
            child: isStreak
                ? Image.asset(
                    'assets/homepage/streak.png',
                    height: 30,
                    width: 30,
                  )
                : const Text(
                    'LV',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
          ),
          const SizedBox(width: 4),
          Text(
            value.toString(),
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
