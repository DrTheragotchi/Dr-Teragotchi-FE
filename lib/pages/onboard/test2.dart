import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(OnboardingApp2());
}

class OnboardingApp2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Onboarding Example',
      debugShowCheckedModeBanner: false,
      home: OnboardingPage(),
    );
  }
}

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with TickerProviderStateMixin {
  late AnimationController _controller1;
  late Animation<Offset> _animation1;

  late AnimationController _controller2;
  late Animation<Offset> _animation2;

  @override
  void initState() {
    super.initState();

    // Pig - from LEFT
    _controller1 = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
    _animation1 = Tween<Offset>(
      begin: Offset(-1.0, 0.0), // from LEFT
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller1,
      curve: Curves.easeOut,
    ));

    // Dog - from RIGHT
    _controller2 = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
    _animation2 = Tween<Offset>(
      begin: Offset(2.5, 0.0), // from RIGHT
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller2,
      curve: Curves.easeOut,
    ));

    // Animate with delays
    Future.delayed(Duration(milliseconds: 300), () {
      if (mounted) _controller1.forward();
    });
    Future.delayed(Duration(milliseconds: 1200), () {
      if (mounted) _controller2.forward();
    });
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: ColorfulSafeArea(
        top: false,
        bottom: false,
        child: Stack(
          children: [
            // Background
            Container(
              height: size.height,
              width: size.width,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/background/lake.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Foreground Content
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),

                    // Title
                    Text(
                      'Emotional Calendar',
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),

                    const SizedBox(height: 20),

                    // Pig from left
                    SlideTransition(
                      position: _animation1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            24), // adjust radius as needed
                        child: Container(
                          width: 250,
                          height: 250,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/emoji/calendar.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),

                    SlideTransition(
                      position: _animation2,
                      child: Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/pig/pig_happy.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 0),

                    // Subtitle
                    Text(
                      'Interact twice a day\nBuild your own emotional calendar',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        height: 1.4,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
