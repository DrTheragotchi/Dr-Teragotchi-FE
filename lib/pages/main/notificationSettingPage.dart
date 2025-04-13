import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _allNotificationsEnabled = true;
  bool _soundNotificationsEnabled = false;

  TimeOfDay? _firstTime;
  TimeOfDay? _secondTime;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    tz.initializeTimeZones();
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    const settings = InitializationSettings(android: androidInit, iOS: iosInit);
    await flutterLocalNotificationsPlugin.initialize(settings);
  }

  void _showTimePicker(BuildContext context) {
    final now = DateTime.now();
    TimeOfDay initialTime = _firstTime ?? TimeOfDay.now();

    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 300,
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                initialDateTime: DateTime(
                  now.year,
                  now.month,
                  now.day,
                  initialTime.hour,
                  initialTime.minute,
                ),
                use24hFormat: false,
                onDateTimeChanged: (DateTime newDate) {
                  TimeOfDay selected = TimeOfDay.fromDateTime(newDate);
                  setState(() {
                    _firstTime = selected;
                    _secondTime = TimeOfDay(
                      hour: (selected.hour + 8) % 24,
                      minute: selected.minute,
                    );
                  });
                },
              ),
            ),
            CupertinoButton(
              child: const Text("Done"),
              onPressed: () {
                Navigator.of(context).pop();
                if (_firstTime != null) {
                  _scheduleNotification(_firstTime!,
                      id: 0, title: 'First Notification');
                  _scheduleNotification(_secondTime!,
                      id: 1, title: 'Second Notification');
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Future<void> _scheduleNotification(TimeOfDay time,
      {required int id, required String title}) async {
    final now = DateTime.now();
    final scheduledDate = tz.TZDateTime.local(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    final tz.TZDateTime finalSchedule =
        scheduledDate.isBefore(tz.TZDateTime.now(tz.local))
            ? scheduledDate.add(const Duration(days: 1))
            : scheduledDate;

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      "It's time to meet your Emogotchi 🐧",
      finalSchedule,
      const NotificationDetails(
        android: AndroidNotificationDetails('channel_id', 'Emogotchi'),
        iOS: DarwinNotificationDetails(),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  void _showTurnOffDialog() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Turn off Notifications?'),
        content: Column(
          children: [
            const SizedBox(height: 10),
            Image.asset('assets/penguin/penguin_sad.png', height: 100),
            const SizedBox(height: 10),
            const Text("Your SoulMate wants to be with you!"),
          ],
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text('Cancel', style: TextStyle(color: Colors.black)),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('Turn Off'),
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _allNotificationsEnabled = false;
              });
            },
          ),
        ],
      ),
    );
  }

  // ✅ Test Notification Function
  void _sendTestNotification() {
    final now = tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5));
    flutterLocalNotificationsPlugin.zonedSchedule(
      999,
      'Test Notification',
      'This is a test 🚀',
      now,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'test_channel',
          'Test Channel',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Widget _buildTimeDisplay(String label, TimeOfDay? time) {
    return Opacity(
      opacity: _allNotificationsEnabled ? 1 : 0.4,
      child: IgnorePointer(
        ignoring: !_allNotificationsEnabled,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                label,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            Text(
              time != null ? time.format(context) : "--:--",
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomSwitch({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 19,
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: Transform.scale(
        scale: 1.2,
        child: CupertinoSwitch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.green,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/background/park.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Notifications',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildCustomSwitch(
                  title: "All Notifications",
                  value: _allNotificationsEnabled,
                  onChanged: (val) {
                    if (!val) {
                      _showTurnOffDialog();
                    } else {
                      setState(() => _allNotificationsEnabled = true);
                    }
                  },
                ),
                const Divider(color: Colors.white),
                Opacity(
                  opacity: _allNotificationsEnabled ? 1 : 0.4,
                  child: IgnorePointer(
                    ignoring: !_allNotificationsEnabled,
                    child: _buildCustomSwitch(
                      title: "Notification Sound",
                      value: _soundNotificationsEnabled,
                      onChanged: (val) =>
                          setState(() => _soundNotificationsEnabled = val),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Opacity(
                  opacity: _allNotificationsEnabled ? 1 : 0.4,
                  child: IgnorePointer(
                    ignoring: !_allNotificationsEnabled,
                    child: Column(
                      children: [
                        const Center(
                          child: Text(
                            "Start your Day with Emogotchi!",
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: Image.asset(
                            'assets/penguin/penguin_eye_close.png',
                            height: 100,
                          ),
                        ),
                        const SizedBox(height: 30),
                        GestureDetector(
                          onTap: () => _showTimePicker(context),
                          child: _buildTimeDisplay(
                              "First Time Received", _firstTime),
                        ),
                        const SizedBox(height: 20),
                        _buildTimeDisplay("Second Time Received", _secondTime),

                        // ✅ Test Button
                        const SizedBox(height: 30),
                        CupertinoButton.filled(
                          onPressed: _allNotificationsEnabled
                              ? _sendTestNotification
                              : null,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          child: const Text(
                            "Send Test Notification",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        // ✅ End Test Button
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
