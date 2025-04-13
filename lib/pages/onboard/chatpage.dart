import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:emogotchi/api/api.dart';
import 'package:emogotchi/components/chatbubble.dart';
import 'package:emogotchi/pages/main/homepage.dart';
import 'package:emogotchi/pages/onboard/soulmatepage.dart';
import 'package:emogotchi/pages/rootpage.dart';
import 'package:emogotchi/provider/emotion_provider.dart';
import 'package:emogotchi/provider/user_provider.dart';
import 'package:emogotchi/provider/uuid_provider.dart';

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
    _isThinking = true;
    _initialize().then((_) {
      if (mounted) {
        setState(() {
          _isThinking = false;
        });
      }
    });
  }

  Future<void> _initialize() async {
    final deviceInfoProvider =
        Provider.of<DeviceInfoProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    await deviceInfoProvider.fetchDeviceUuid();
    if (!mounted) return;

    _uuid = deviceInfoProvider.uuid ?? 'error';
    final apiService = ApiService();
    final response = await apiService.getUser(_uuid);

    userProvider.setUserData(
      uuid: response['uuid'] ?? userProvider.uuid,
      emotion: response['animal_emotion'] ?? userProvider.emotion,
      animal: (response['animal_type']?.toString().isNotEmpty ?? false)
          ? response['animal_type']
          : userProvider.animalType,
      animalLevel:
          response['animal_level']?.toString() ?? userProvider.animalLevel,
      points: response['points'] ?? userProvider.points,
      userName: response['nickname'] ?? userProvider.userName,
      isNotified: response['is_notified'] ?? userProvider.isNotified,
    );

    _currentEmotion = userProvider.emotion.toLowerCase();

    if (widget.isInit) {
      final messages =
          initMessages[_currentEmotion] ?? initMessages['neutral']!;
      final randomIndex = (messages.length * 0.5).toInt();

      setState(() {
        _messages.add({
          'sender': 'bot',
          'text': messages[randomIndex],
        });
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Widget getPage(String routeName) {
    switch (routeName) {
      case '/rootpage':
        return const RootPage();
      case '/soulmatepage':
        return SoulmatePage();
      default:
        return const Scaffold(body: Center(child: Text('Page not found')));
    }
  }

  Future<void> fadeTransitionToNamed(
      BuildContext context, String routeName) async {
    await Future.delayed(const Duration(seconds: 2));
    if (!context.mounted) return;

    Navigator.of(context).push(PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          getPage(routeName),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 500),
    ));
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty || _uuid.isEmpty) return;

    setState(() {
      _messages.add({'sender': 'user', 'text': message});
      _messageController.clear();
      _isThinking = true;
    });
    _scrollToBottom();

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
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final updatedAnimal =
        (response['animal']?.toString().trim().isNotEmpty ?? false)
            ? response['animal']
            : userProvider.animalType;

    userProvider.setUserData(
      emotion: response['emotion'] ?? userProvider.emotion,
      animal: updatedAnimal,
      points: response['points'] ?? userProvider.points,
    );

    if (response['animal'] == null && response['isFifth'] != false) {
      await fadeTransitionToNamed(context, '/rootpage');
    } else if (response['animal'] != null && response['isFifth'] != false) {
      await fadeTransitionToNamed(context, '/soulmatepage');
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
                          : 'assets/doctor.png',
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
