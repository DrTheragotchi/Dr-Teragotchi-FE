import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:emogotchi/components/Graph.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class BetterAnimalPage extends StatefulWidget {
  const BetterAnimalPage({super.key});

  @override
  State<BetterAnimalPage> createState() => _BetterAnimalPageState();
}

class _BetterAnimalPageState extends State<BetterAnimalPage>
    with TickerProviderStateMixin {
  late final AnimationController _shakeController1;
  late final AnimationController _shakeController2;

  // ✅ 펭귄 이미지 간격 설정
  final double penguinSpacing = 32.0;

  @override
  void initState() {
    super.initState();
    _shakeController1 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _shakeController2 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _shakeController1.dispose();
    _shakeController2.dispose();
    super.dispose();
  }

  Widget _buildShakyProfile({
    required AnimationController controller,
    required String imagePath,
    required bool isEgg,
  }) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        double offset = math.sin(controller.value * 2 * math.pi) * 4;
        return Transform.translate(
          offset: Offset(offset, offset),
          child: child,
        );
      },
      child: Container(
        width: isEgg ? 115: 100,
        height: isEgg ? 115: 100,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
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
            // 🌄 Background
            Container(
              height: size.height,
              width: size.width,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/background/airport.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // 📦 Foreground
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: size.height),
                child: Center(
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        const Text(
                          'Break Emotional Barrier!',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 30),
                        const SizedBox(
                          height: 200,
                          child: Graph(),
                        ),
                        const SizedBox(height: 30),

                        // 🐧 Shaky Penguin Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildShakyProfile(
                              controller: _shakeController1,
                              imagePath: 'assets/penguin_egg/penguin_egg_happy.png',
                              isEgg: true
                            ),
                            SizedBox(width: penguinSpacing), 
                            _buildShakyProfile(
                              controller: _shakeController2,
                              imagePath: 'assets/penguin/penguin_happy.png',
                              isEgg: false
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Stabilize your emotion \nTo help your Animal grow',
                            style: TextStyle(
                              fontSize: 20,
                              height: 1.4,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 60),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}