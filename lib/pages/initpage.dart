import 'package:emogotchi/pages/settingpage.dart';
import 'package:flutter/material.dart';

class InitPage extends StatelessWidget {
  const InitPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Initialization Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate to the next page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingPage()),
            );
          },
          child: const Text('Go to Settings'),
        ),
      ),
    );
  }
}
