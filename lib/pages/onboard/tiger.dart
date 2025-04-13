// TigerPage - Tiger background with name input and transition
import 'package:emogotchi/api/api.dart';
import 'package:emogotchi/pages/onboard/emotionpage.dart';
import 'package:emogotchi/provider/uuid_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';

class TigerPage extends StatefulWidget {
  const TigerPage({super.key});

  @override
  State<TigerPage> createState() => _TigerPageState();
}

class _TigerPageState extends State<TigerPage> {
  final TextEditingController _nameController = TextEditingController();
  late String _uuid = '';

  @override
  void initState() {
    super.initState();
    _initializeUuid();
  }

  void _initializeUuid() async {
    final deviceInfoProvider =
        Provider.of<DeviceInfoProvider>(context, listen: false);
    await deviceInfoProvider.fetchDeviceUuid();

    if (!mounted) return;

    final fetchedUuid = deviceInfoProvider.uuid;
    if (fetchedUuid != null) {
      setState(() {
        _uuid = fetchedUuid;
      });
      print("Fetched UUID: $_uuid");
    } else {
      print("Failed to get UUID");
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void sendUserInfo() async {
    try {
      final apiService = ApiService();
      final result =
          await apiService.postOnboarding(_uuid, _nameController.text);

      print("Onboarding Success: $result");

      await Future.delayed(const Duration(milliseconds: 500));
      Navigator.of(context).push(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (_, __, ___) => const EmotionPage(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    } catch (e) {
      print("Error sending onboarding data: $e");

      if (!mounted) return;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Error'),
          content: Text('Failed to send info: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void _handleNext(String value) {
    if (_nameController.text.trim().isEmpty) {
      HapticFeedback.lightImpact();
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          icon: const Icon(Icons.warning, color: Colors.redAccent),
          title: const Text('What is your name?'),
          content: const Text('You must enter your name to continue.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    final inputName = _nameController.text.trim();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Is this name correct?"),
        content: Text('"$inputName"'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // 팝업 닫기만
            },
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // 팝업 닫기
              sendUserInfo(); // 다음 페이지로
            },
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  const Text(
                    "What's your soul mate name?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Set name and profile\nthat will be shown to others.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                  const SizedBox(height: 50),
                  Image.asset(
                    'assets/emoji/family.png',
                    height: 250,
                    width: 250,
                  ),
                  const Spacer(),
                  const SizedBox(height: 160), // 공간 확보만!
                ],
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: MediaQuery.of(context).viewInsets.bottom,
          child: Container(
            padding: const EdgeInsets.fromLTRB(30, 16, 30, 24),
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CupertinoTextField(
                  controller: _nameController,
                  textAlign: TextAlign.center,
                  placeholder: "Enter Name",
                  maxLength: 16,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                  style: const TextStyle(fontSize: 20),
                  placeholderStyle:
                      const TextStyle(fontSize: 20, color: Colors.black54),
                  cursorColor: Colors.black,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[200],
                  ),
                  onSubmitted: _handleNext,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
