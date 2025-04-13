import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({Key? key}) : super(key: key);

  @override
  State<NotificationSettingsPage> createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool _allNotificationsEnabled = true;
  bool _soundNotificationsEnabled = false;
  TimeOfDay? _selectedStartTime;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

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

  Future<void> _scheduleDailyNotification(TimeOfDay time) async {
    final now = DateTime.now();
    final tz.TZDateTime scheduled = tz.TZDateTime.local(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    final tz.TZDateTime nextInstance =
        scheduled.isBefore(tz.TZDateTime.now(tz.local))
            ? scheduled.add(const Duration(days: 1))
            : scheduled;

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Good Morning!',
      'Start your day with Emogotchi 🐧',
      nextInstance,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'emogotchi_channel',
          'Daily Notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  void _showCupertinoTimePicker({
    required BuildContext context,
    required TimeOfDay? initialTime,
    required ValueChanged<TimeOfDay> onTimeChanged,
  }) {
    final TimeOfDay initialPickerTime = initialTime ?? TimeOfDay.now();
    final DateTime now = DateTime.now();
    DateTime initialDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      initialPickerTime.hour,
      initialPickerTime.minute,
    );
    TimeOfDay selectedTime = initialPickerTime;

    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 250,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: CupertinoButton(
                child: const Text('Done'),
                onPressed: () {
                  Navigator.pop(context);
                  onTimeChanged(selectedTime);
                  _scheduleDailyNotification(selectedTime);
                },
              ),
            ),
            Expanded(
              child: CupertinoDatePicker(
                initialDateTime: initialDateTime,
                mode: CupertinoDatePickerMode.time,
                use24hFormat: false,
                onDateTimeChanged: (DateTime newDateTime) {
                  selectedTime = TimeOfDay.fromDateTime(newDateTime);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCupertinoSwitchTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      title: Text(title),
      trailing: CupertinoSwitch(
        value: value,
        onChanged: onChanged,
        activeColor: CupertinoColors.activeGreen,
      ),
    );
  }

  Widget _buildNavigationTile({
    required String title,
    String? currentValue,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (currentValue != null)
            Text(currentValue, style: const TextStyle(color: Colors.grey)),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
      onTap: onTap,
    );
  }

  void _showTurnOffConfirmationDialog() {
    showCupertinoDialog<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Turn Off Notifications?'),
        content: Column(
          children: [
            Image.asset('assets/penguin/penguin_sad.png', height: 100),
            const Text('No more connection with Emogotchi?'),
          ],
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.black), // ✅ Make Cancel text black
            ),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('Turn Off'),
            onPressed: () {
              Navigator.pop(context);
              setState(() => _allNotificationsEnabled = false);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String formattedStartTime = _selectedStartTime != null
        ? MaterialLocalizations.of(context).formatTimeOfDay(_selectedStartTime!)
        : 'Not Set';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          _buildCupertinoSwitchTile(
            title: 'All Notifications',
            value: _allNotificationsEnabled,
            onChanged: (value) {
              if (!value) {
                _showTurnOffConfirmationDialog();
              } else {
                setState(() => _allNotificationsEnabled = true);
              }
            },
          ),
          const Divider(),
          Opacity(
            opacity: _allNotificationsEnabled ? 1 : 0.5,
            child: IgnorePointer(
              ignoring: !_allNotificationsEnabled,
              child: Column(
                children: [
                  _buildNavigationTile(
                    title: 'Start your Day with Emogotchi',
                    currentValue: formattedStartTime,
                    onTap: () => _showCupertinoTimePicker(
                      context: context,
                      initialTime: _selectedStartTime,
                      onTimeChanged: (newTime) {
                        setState(() => _selectedStartTime = newTime);
                      },
                    ),
                  ),
                  const Divider(),
                  _buildCupertinoSwitchTile(
                    title: 'Notification Sound',
                    value: _soundNotificationsEnabled,
                    onChanged: (value) =>
                        setState(() => _soundNotificationsEnabled = value),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
