import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // Import Cupertino widgets
import 'package:intl/intl.dart'; // Import intl package for date formatting

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({Key? key}) : super(key: key);

  @override
  State<NotificationSettingsPage> createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool _allNotificationsEnabled = true;
  // Removed unused _like/_comment notification toggles from state for simplicity
  // bool _likeNotificationsEnabled = true;
  // bool _commentNotificationsEnabled = false;
  bool _soundNotificationsEnabled = false; // Keep sound toggle state

  TimeOfDay? _selectedStartTime;
  TimeOfDay? _selectedEndTime;

  // --- Helper Widgets (Unchanged) ---
  Widget _buildCupertinoSwitchTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      title: Text(title,
          style: const TextStyle(color: Colors.black, fontSize: 16)),
      trailing: CupertinoSwitch(
        value: value,
        onChanged: onChanged,
        activeColor: CupertinoColors.activeGreen,
      ),
      onTap: () {
        onChanged(!value);
      },
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
    );
  }

  Widget _buildNavigationTile({
    required String title,
    String? currentValue,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(title,
          style: const TextStyle(color: Colors.black, fontSize: 16)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (currentValue != null)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(
                currentValue,
                style: TextStyle(color: Colors.grey[500], fontSize: 15),
              ),
            ),
          Icon(Icons.chevron_right, color: Colors.grey[400], size: 22),
        ],
      ),
      onTap: onTap,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
    );
  }

  void _showCupertinoTimePicker(
      {required BuildContext context,
      required TimeOfDay? initialTime,
      required ValueChanged<TimeOfDay> onTimeChanged}) {
    // ... (Time picker code is unchanged)
    final TimeOfDay initialPickerTime = initialTime ?? TimeOfDay.now();
    final DateTime now = DateTime.now();
    DateTime initialDateTime = DateTime(now.year, now.month, now.day,
        initialPickerTime.hour, initialPickerTime.minute);
    TimeOfDay selectedTime = initialPickerTime;

    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 250,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: CupertinoButton(
                child: const Text('Done',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                onPressed: () {
                  Navigator.pop(context);
                  onTimeChanged(selectedTime);
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

  Widget _buildThickDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8.0),
      child: Divider(
        height: 1,
        thickness: 1,
        color: Colors.grey[400],
      ),
    );
  }
  // --- End Helper Widgets ---

  // --- Function to show Confirmation Dialog ---
  void _showTurnOffConfirmationDialog() {
    showCupertinoDialog<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Turn Off Notifications?'),
        content: Column(
            mainAxisSize: MainAxisSize.min, // Minimizes extra space
            children: [
              // Display an asset image (update the asset path as needed)
              Image.asset(
                'assets/penguin/penguin_sad.png', // Replace with your image path
                height: 100, // Adjust the height as needed
              ),
              const SizedBox(height: 10),
              const Text(
                'NO more Connection with Emogotchi?',
                style: TextStyle(color: Colors.black),
              ),
            ]),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            // Default action (usually Cancel)
            isDefaultAction: true,
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.black),
            ),

            onPressed: () {
              Navigator.pop(context); // Close the dialog, state remains ON
            },
          ),
          CupertinoDialogAction(
            // Destructive action (usually confirmation for negative action)
            isDestructiveAction: true,
            child: const Text('Turn Off'),
            onPressed: () {
              Navigator.pop(context); // Close the dialog
              // CONFIRMED: Update the state to OFF
              setState(() {
                _allNotificationsEnabled = false;
                // Optionally, also turn off related settings if needed
                // _soundNotificationsEnabled = false;
              });
            },
          ),
        ],
      ),
    );
  }
  // --- End Confirmation Dialog ---

  @override
  Widget build(BuildContext context) {
    const Color lightBackgroundColor = Colors.white;
    const Color appBarBackgroundColor = Colors.white;
    const Color appBarForegroundColor = Colors.black;

    final String formattedStartTime = _selectedStartTime != null
        ? MaterialLocalizations.of(context)
            .formatTimeOfDay(_selectedStartTime!, alwaysUse24HourFormat: false)
        : 'Not Set';
    final String formattedEndTime = _selectedEndTime != null
        ? MaterialLocalizations.of(context).formatTimeOfDay(_selectedEndTime!)
        : 'Not Set';
    final String durationValue =
        (_selectedStartTime != null && _selectedEndTime != null)
            ? '$formattedStartTime - $formattedEndTime'
            : 'Set Duration';

    return Scaffold(
      backgroundColor: lightBackgroundColor,
      appBar: AppBar(
        // ... (AppBar setup remains the same)
        backgroundColor: appBarBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: appBarForegroundColor, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: const Text(
          'Notifications',
          style: TextStyle(
              color: appBarForegroundColor,
              fontWeight: FontWeight.w600,
              fontSize: 18),
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 10),

          // --- Notification Toggles Group ---
          _buildCupertinoSwitchTile(
            title: 'All Notifications',
            value: _allNotificationsEnabled,
            onChanged: (bool newValue) {
              // Check if the user is trying to turn OFF
              if (newValue == false) {
                // Show confirmation dialog before turning OFF
                _showTurnOffConfirmationDialog();
              } else {
                // Turning ON: Set state directly
                setState(() {
                  _allNotificationsEnabled = true;
                });
              }
            },
          ),

          _buildThickDivider(),

          // --- Time Settings Group ---
          // Wrap time/sound settings in Opacity based on _allNotificationsEnabled
          Opacity(
            opacity: _allNotificationsEnabled
                ? 1.0
                : 0.5, // Dim if all notifications are off
            child: IgnorePointer(
              // Prevent interaction if dimmed
              ignoring: !_allNotificationsEnabled,
              child: Column(
                // Wrap the related settings in a Column
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildNavigationTile(
                    title: 'Start your Day with Emogotchi',
                    currentValue: formattedStartTime,
                    onTap: _allNotificationsEnabled
                        ? () {
                            // Only allow tap if enabled
                            _showCupertinoTimePicker(
                                context: context,
                                initialTime: _selectedStartTime,
                                onTimeChanged: (newTime) {
                                  setState(() {
                                    _selectedStartTime = newTime;
                                  });
                                });
                          }
                        : () {}, // Provide an empty function if all notifications are off
                  ),
                  _buildNavigationTile(
                    title: 'Duration',
                    currentValue: durationValue,
                    onTap: _allNotificationsEnabled
                        ? () {
                            // Only allow tap if enabled
                            _showCupertinoTimePicker(
                                context: context,
                                initialTime: _selectedEndTime,
                                onTimeChanged: (newTime) {
                                  setState(() {
                                    _selectedEndTime = newTime;
                                  });
                                });
                          }
                        : () {}, // Provide an empty function if all notifications are off
                  ),

                  _buildThickDivider(), // Divider before sound

                  // --- Sound Setting Group ---
                  _buildCupertinoSwitchTile(
                    title: 'Notification Sound',
                    value: _soundNotificationsEnabled,
                    onChanged: (bool value) {
                      // Always provide a function
                      if (_allNotificationsEnabled) {
                        setState(() {
                          _soundNotificationsEnabled = value;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
