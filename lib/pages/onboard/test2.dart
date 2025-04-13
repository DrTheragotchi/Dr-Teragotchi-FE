// OnboardingApp2 - simplified for foreground-only display
import 'package:flutter/material.dart';

class OnboardingApp2 extends StatefulWidget {
  const OnboardingApp2({super.key});

  @override
  State<OnboardingApp2> createState() => _OnboardingApp2State();
}

class _OnboardingApp2State extends State<OnboardingApp2>
    with TickerProviderStateMixin {
  late AnimationController _controller1;
  late Animation<Offset> _animation1;

  late AnimationController _controller2;
  late Animation<Offset> _animation2;

  @override
  void initState() {
    super.initState();

    _controller1 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animation1 = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller1,
      curve: Curves.easeOut,
    ));

    _controller2 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animation2 = Tween<Offset>(
      begin: const Offset(2.5, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller2,
      curve: Curves.easeOut,
    ));

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _controller1.forward();
    });
    Future.delayed(const Duration(milliseconds: 1200), () {
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

    return SizedBox(
      width: size.width,
      height: size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          const Text(
            'Emotional Calendar',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          SlideTransition(
            position: _animation1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Container(
                width: 250,
                height: 250,
                decoration: const BoxDecoration(
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
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/pig/pig_happy.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Interact twice a day\nBuild your own emotional calendar',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              height: 1.4,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
