import 'package:emogotchi/components/home_chat.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late String selectedBackground;
  late AnimationController _controller;
  late Animation<double> _moveAnimation;
  late Animation<double> _tiltAnimation;

  bool _firstJumpDone = false;

  final List<String> background = [
    'assets/background/airport.png',
    'assets/background/lake.png',
    'assets/background/mountain.png',
    'assets/background/park.png',
    'assets/background/school.png',
  ];

  int getRandomInt() {
    return Random().nextInt(background.length);
  }

  @override
  void initState() {
    super.initState();
    selectedBackground = background[getRandomInt()];

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
                startPenguinAnimation(); // 3초 뒤 애니메이션 시작
                Navigator.pushNamed(context, '/chatpage');
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: HomeChatBubble(text: 'Hello~'),
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
