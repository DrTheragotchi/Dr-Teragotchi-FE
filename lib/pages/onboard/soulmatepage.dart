import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:emogotchi/pages/homepage.dart';

class SoulmatePage extends StatefulWidget {
  @override
  State<SoulmatePage> createState() => _SoulmatePageState();
}

class _SoulmatePageState extends State<SoulmatePage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(_createFadeRoute());
    });
  }

  Route _createFadeRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => HomePage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      transitionDuration: Duration(milliseconds: 800),
    );
  }

  Widget _penguinImage() {
    return SizedBox(
      height: 300,
      child: Image.asset(
        'assets/penguin/penguin_happy.png',
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _flightShuttleBuilder(
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection flightDirection,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    return _penguinImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ColorfulSafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Your soulmate is...',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Hero(
                tag: 'penguinHero',
                flightShuttleBuilder: _flightShuttleBuilder,
                child: _penguinImage(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
