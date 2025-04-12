import 'package:emogotchi/components/home_chat.dart';
import 'package:emogotchi/provider/background_provider.dart';
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

    // 배경은 처음 앱 실행 시 한 번만 설정
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

    // Navigator.pop 후 다시 돌아올 때도 여기 호출됨
    if (!_controller.isAnimating && _firstJumpDone) {
      _controller.forward().then((_) {
        _controller.repeat(reverse: true);
      });
    }
  }

  void startPenguinAnimation() {
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

  Widget _penguinImage({bool animated = true}) {
    final image = Image.asset(
      'assets/penguin/penguin_happy.png',
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
    return _penguinImage(animated: false);
  }

  @override
  void dispose() {
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
                              value: 0.5,
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
                StatusButton(false),
                const SizedBox(height: 6),
                StatusButton(true),
              ],
            ),
          ),
          Positioned(
            bottom: 295,
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                HapticFeedback.mediumImpact();
                startPenguinAnimation();
                Navigator.pushNamed(context, '/chatpage', arguments: {
                  'emotion': '',
                });
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
                child: _penguinImage(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget StatusButton(bool isStreak, {String value = '10'}) {
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
            value,
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
