import 'package:emogotchi/components/chatbubble.dart';
import 'package:emogotchi/pages/main/homepage.dart';
import 'package:emogotchi/pages/onboard/soulmatepage.dart';
import 'package:emogotchi/pages/rootpage.dart';
import 'package:emogotchi/provider/emotion_provider.dart';
import 'package:emogotchi/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:emogotchi/api/api.dart';
import 'package:emogotchi/provider/uuid_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';

class ChatPage extends StatefulWidget {
  final bool isInit;
  const ChatPage({Key? key, this.isInit = false}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, String>> _messages = [];

  late String _uuid = '';
  late String _currentEmotion = '';
  late String _currentAnimal = '';
  late int _currentPoints = 0;
  bool _isThinking = false;

  final Map<String, List<String>> initMessages = {
    "happy": [
      "I'm glad to hear you're feeling happy! What's been going well lately?",
      "Tell me about something that made you smile today.",
      "What’s bringing you joy these days?",
      "Would you like to reflect on something positive together?",
    ],
    "sad": [
      "I'm here for you. What’s been weighing on your heart lately?",
      "Would you like to talk about what's been making you feel this way?",
      "It’s okay to feel sad. What happened recently?",
      "When did you start feeling this way?",
    ],
    "anxious": [
      "It sounds like you’ve been feeling tense. Want to share what’s on your mind?",
      "What’s been causing you to feel uneasy lately?",
      "Would you like to talk about what’s making you anxious?",
      "What thoughts have been occupying your mind recently?",
    ],
    "angry": [
      "It’s okay to feel angry. Want to talk about what happened?",
      "What triggered your frustration today?",
      "Would you like to vent or process that anger together?",
      "When did you start feeling this upset?",
    ],
    "neutral": [
      "Thanks for checking in. How are things going for you lately?",
      "Anything on your mind you'd like to explore today?",
      "Is there something you'd like to reflect on or unpack together?",
      "How have you been feeling overall these days?",
    ],
  };

  @override
  void initState() {
    super.initState();
    _initializeChatSetup();
  }

  Future<void> _initializeChatSetup() async {
    setState(() {
      _isThinking = true;
    });

    final deviceInfoProvider =
        Provider.of<DeviceInfoProvider>(context, listen: false);
    final emotionProvider =
        Provider.of<EmotionProvider>(context, listen: false);

    await deviceInfoProvider.fetchDeviceUuid();
    await emotionProvider.getEmotion();

    if (!mounted) return;

    final fetchedUuid = deviceInfoProvider.uuid;
    final fetchedEmotion = emotionProvider.emotion;

    if (fetchedUuid != null && fetchedEmotion != null) {
      _uuid = fetchedUuid;
      _currentEmotion = fetchedEmotion.toLowerCase();

      final initMessagesList = initMessages[_currentEmotion] ?? [];
      if (initMessagesList.isNotEmpty) {
        final randomIndex = (initMessagesList.length * 0.5).toInt();

        await Future.delayed(const Duration(seconds: 2)); // 생각 중 표시 시간

        setState(() {
          _isThinking = false;
          _messages.add({
            'sender': 'bot',
            'text': initMessagesList[randomIndex],
          });
        });

        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });
      }
    }
  }

  Widget getPage(String routeName) {
    switch (routeName) {
      case '/rootpage':
        return const RootPage();
      case '/soulmatepage':
        return SoulmatePage();
      default:
        return const Scaffold(
          body: Center(child: Text('Page not found')),
        );
    }
  }

  Future<void> fadeTransitionToNamed(
      BuildContext context, String routeName) async {
    await Future.delayed(const Duration(seconds: 2));
    if (!context.mounted) return;

    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            getPage(routeName),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.minScrollExtent, // reverse:true니까 min!
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _sendMessage() async {
    final String message = _messageController.text.trim();
    if (message.isEmpty || _uuid.isEmpty) return;

    setState(() {
      _messages.add({'sender': 'user', 'text': message});
      _messageController.clear();
      _isThinking = true;
    });

    _scrollToBottom();

    print("current emotion: $_currentEmotion");

    if (widget.isInit == false) {
      setState(() {
        _currentEmotion = '';
      });
    }

    try {
      final apiService = ApiService();
      final response = await apiService.postMessage(
        message,
        _uuid,
        _currentEmotion.toUpperCase(),
      );

      setState(() {
        _isThinking = false;
        _messages.add({'sender': 'bot', 'text': response['response'] ?? ''});
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });

      print("Response: ${response['response']}");
      print("Emotion: ${response['emotion']}");
      print("Animal: ${response['animal']}");
      print("Points: ${response['points']}");
      print("isFifth: ${response['isFifth']}");

      final userProvider = Provider.of<UserProvider>(context, listen: false);

      final updatedAnimal = (response['animal'] ?? '').toString().trim().isEmpty
          ? userProvider.animalType
          : response['animal'];

      userProvider.setUserData(
        emotion: response['emotion'] ?? '',
        animal: updatedAnimal,
        points: response['points'] ?? 0,
      );

      print("User data updated");
      // ✅ emotion과 animal이 있으면 SoulmatePage로 이동
      if (response['animal'] == null && response['isFifth'] != false) {
        await fadeTransitionToNamed(context, '/rootpage');
      }

      if (response['animal'] != null && response['isFifth'] != false) {
        await fadeTransitionToNamed(context, '/soulmatepage');
      }
    } catch (e) {
      setState(() {
        _isThinking = false;
        _messages.add({'sender': 'bot', 'text': 'Error: $e'});
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(12),
                itemCount: _messages.length,
                reverse: true,
                itemBuilder: (context, index) {
                  final reversedIndex = _messages.length - 1 - index;
                  final message = _messages[reversedIndex];
                  final isUser = message['sender'] == 'user';

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: CustomChatBubble(
                      message: message['text'] ?? '',
                      alignment:
                          isUser ? Alignment.topRight : Alignment.topLeft,
                      bubbleType: isUser
                          ? BubbleType.sendBubble
                          : BubbleType.receiverBubble,
                      imageAsset: isUser
                          ? 'assets/penguin/penguin_happy.png'
                          : "assets/doctor.png",
                      backgroundColor: isUser
                          ? const Color.fromARGB(255, 210, 235, 244)
                          : const Color.fromRGBO(243, 226, 180, 1),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomSheet: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: 'Express your feelings...',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                " * Share your feelings with Emogotchi to navigate your emotions.",
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
