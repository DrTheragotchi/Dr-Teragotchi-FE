import 'package:emogotchi/pages/main/calendarpage.dart';
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
  int _currentIndex = 1;
  bool _isChatMode = false;

  @override
  Widget build(BuildContext context) {
    final bool isChatPage = _currentIndex == 1 && _isChatMode;

    Widget currentPage;
    if (_currentIndex == 0) {
      currentPage = const CalendarPage();
    } else if (_currentIndex == 2) {
      currentPage = const SettingPage();
    } else {
      currentPage = _isChatMode ? const ChatPage() : const HomePage();
    }

    return Scaffold(
      extendBody: true,
      body: currentPage,
      bottomNavigationBar: isChatPage
          ? null
          : SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  color: (_currentIndex == 0 || _currentIndex == 2)
                      ? Colors.white
                      : Colors.transparent,
                ),
                child: BottomNavigationBar(
                  backgroundColor: (_currentIndex == 0 || _currentIndex == 2)
                      ? Colors.white
                      : Colors.transparent,
                  elevation: 0,
                  currentIndex: _currentIndex,
                  onTap: (int index) {
                    setState(() {
                      if (index == 1) {
                        if (_currentIndex != 1) {
                          _isChatMode = false;
                        } else {
                          _isChatMode = !_isChatMode;
                        }
                      } else {
                        _isChatMode = false;
                      }
                      _currentIndex = index;
                    });
                  },
                  type: BottomNavigationBarType.fixed,
                  selectedItemColor: Colors.black,
                  unselectedItemColor: Colors.black54,
                  iconSize: 30,
                  showUnselectedLabels: false,
                  showSelectedLabels: false,
                  items: [
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.calendar_today),
                      label: '캘린더',
                    ),
                    BottomNavigationBarItem(
                      icon: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: (_currentIndex == 0 || _currentIndex == 2)
                              ? Colors.white
                              : Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            (_currentIndex == 0 || _currentIndex == 2)
                                ? BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(
                                        0, 3), // changes position of shadow
                                  )
                                : BoxShadow(
                                    color: Colors.transparent,
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            (_currentIndex == 0 || _currentIndex == 2)
                                ? Icons.home
                                : Icons.add,
                            color: (_currentIndex == 0 || _currentIndex == 2)
                                ? Colors.grey
                                : Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                      label: '홈/일기',
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
