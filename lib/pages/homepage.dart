import 'package:flutter/material.dart';
import 'dart:math';

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

    // Hero 전환 끝난 후 애니메이션 시작
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final animation = ModalRoute.of(context)?.animation;
      if (animation != null) {
        animation.addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            Future.delayed(Duration(milliseconds: 300), () {
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
        });
      } else {
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
            top: 40,
            left: 20,
            right: 20,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: 0.7,
                minHeight: 15,
                backgroundColor: Colors.white54,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
              ),
            ),
          ),
          Positioned(
            bottom: 30,
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
}
