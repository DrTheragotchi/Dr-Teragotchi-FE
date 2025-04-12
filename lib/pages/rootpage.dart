import 'package:emogotchi/pages/main/calendarpage.dart';
import 'package:emogotchi/pages/main/diarypage.dart';
import 'package:emogotchi/pages/main/homepage.dart';
import 'package:emogotchi/pages/onboard/chatpage.dart';
import 'package:emogotchi/pages/settingpage.dart';
import 'package:flutter/material.dart';

class RootPage extends StatefulWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    DiaryPage(),
    ChatPage(),
    CalendarPage(),
    SettingPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _pages[_currentIndex],
      bottomNavigationBar: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            currentIndex: _currentIndex,
            onTap: (int index) {
              setState(() {
                _currentIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white70,
            iconSize: 30,
            showUnselectedLabels: false,
            showSelectedLabels: false,
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: '홈',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today),
                label: '캘린더',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(16), // 👉 더 부드러운 둥근 사각형
                  ),
                  child: const Center(
                    child: Icon(Icons.add, color: Colors.white, size: 30),
                  ),
                ),
                label: '일기',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today),
                label: '캘린더',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: '설정',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
