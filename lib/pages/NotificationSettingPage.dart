import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // Import Cupertino widgets
import 'package:intl/intl.dart';      // Import intl package for date formatting

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({Key? key}) : super(key: key);

  @override
  State<NotificationSettingsPage> createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool _allNotificationsEnabled = true;
  bool _likeNotificationsEnabled = true;
  bool _commentNotificationsEnabled = false;

  // State variable to store the selected time
  TimeOfDay? _selectedStartTime; // Default to null initially
  TimeOfDay? _selectedEndTime; // Example for Duration End Time

  // --- Helper Widgets (Keep _buildSwitchTile and _buildNavigationTile as they are) ---
  Widget _buildSwitchTile({
     required String title,
     String? subtitle,
     required bool value,
     required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile.adaptive(
      title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
      subtitle: subtitle != null
          ? Text(subtitle, style: TextStyle(color: Colors.grey[400], fontSize: 13))
          : null,
      value: value,
      onChanged: onChanged,
      activeColor: Colors.tealAccent[100],
      inactiveTrackColor: Colors.grey[700],
      inactiveThumbColor: Colors.grey[400],
      contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
    );
  }

  Widget _buildNavigationTile({
     required String title,
     String? currentValue,
     required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (currentValue != null)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(
                currentValue,
                style: TextStyle(color: Colors.grey[400], fontSize: 15),
              ),
            ),
          Icon(Icons.chevron_right, color: Colors.grey[500], size: 24),
        ],
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
    );
  }
  // --- End Helper Widgets ---


  // --- Function to show Cupertino Time Picker ---
  void _showCupertinoTimePicker({
      required BuildContext context,
      required TimeOfDay? initialTime,
      required ValueChanged<TimeOfDay> onTimeChanged // Callback to update state
  }) {
    // Default to current time if initialTime is null
    final TimeOfDay initialPickerTime = initialTime ?? TimeOfDay.now();
    // Convert TimeOfDay to DateTime for the picker
    final DateTime now = DateTime.now();
    DateTime initialDateTime = DateTime(now.year, now.month, now.day, initialPickerTime.hour, initialPickerTime.minute);

    TimeOfDay selectedTime = initialPickerTime; // Temp variable to hold selection within picker

    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 250, // Adjust height as needed
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context), // Adapts to light/dark
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // --- Done Button ---
            Align(
              alignment: Alignment.centerRight,
              child: CupertinoButton(
                child: const Text('Done', style: TextStyle(fontWeight: FontWeight.bold)),
                onPressed: () {
                  Navigator.pop(context); // Close the modal
                  onTimeChanged(selectedTime); // Update the state with the selected time
                },
              ),
            ),
            // --- Picker ---
            Expanded(
              child: CupertinoDatePicker(
                initialDateTime: initialDateTime,
                mode: CupertinoDatePickerMode.time,
                use24hFormat: false, // Set to true for 24-hour format
                onDateTimeChanged: (DateTime newDateTime) {
                  // Update the temporary variable as the picker scrolls
                  selectedTime = TimeOfDay.fromDateTime(newDateTime);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  // --- End Time Picker Function ---


  @override
  Widget build(BuildContext context) {
    const Color darkBackgroundColor = Color(0xFF1A1A1A);
    const Color appBarColor = Color(0xFF222222);
    final Color dividerColor = Colors.grey[800]!;

    // Format the selected time for display, handle null case
    final String formattedStartTime = _selectedStartTime != null
        ? MaterialLocalizations.of(context).formatTimeOfDay(_selectedStartTime!, alwaysUse24HourFormat: false) // Use MaterialLocalizations for locale-aware format
        : 'Not Set'; // Placeholder text

    // Example formatting for Duration End Time (you'll need a similar _showCupertinoTimePicker call for it)
    final String formattedEndTime = _selectedEndTime != null
        ? MaterialLocalizations.of(context).formatTimeOfDay(_selectedEndTime!)
        : 'Not Set';

     // Combine start and end time for Duration display if needed
    final String durationValue = (_selectedStartTime != null && _selectedEndTime != null)
        ? '$formattedStartTime - $formattedEndTime'
        : 'Set Duration';


    return Scaffold(
      backgroundColor: darkBackgroundColor,
      appBar: AppBar( /* ... AppBar code remains the same ... */
         backgroundColor: appBarColor,
         elevation: 0,
         leading: IconButton(
           icon: const Icon(Icons.arrow_back, color: Colors.white),
           onPressed: () => Navigator.of(context).pop(),
         ),
         title: const Text(
           'Notifications',
           style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
         ),
      ),
      body: ListView(
        children: [
          /* ... Header Text and Toggles remain the same ... */
           const SizedBox(height: 20),
           Padding(
             padding: const EdgeInsets.symmetric(horizontal: 20.0),
             child: Text(
               'Set Your Valuable Emotion Time',
               style: TextStyle(
                 color: Colors.white,
                 fontSize: 20,
                 fontWeight: FontWeight.bold,
               ),
             ),
           ),
           const SizedBox(height: 8),
           Padding(
             padding: const EdgeInsets.symmetric(horizontal: 20.0),
             child: Text(
               'Choose when Partner want to notify You.',
               style: TextStyle(
                 color: Colors.grey[400],
                 fontSize: 14,
               ),
             ),
           ),
           const SizedBox(height: 25),
           _buildSwitchTile(
             title: 'All Notifications',
             subtitle: 'Enable or disable all app alerts',
             value: _allNotificationsEnabled,
             onChanged: (bool value) {
               setState(() {
                 _allNotificationsEnabled = value;
                 _likeNotificationsEnabled = value;
                 _commentNotificationsEnabled = value;
               });
             },
           ),
           Divider(height: 1, thickness: 1, color: dividerColor, indent: 20, endIndent: 20),
           if (_allNotificationsEnabled) ...[
             _buildSwitchTile(
               title: 'Likes',
               value: _likeNotificationsEnabled,
               onChanged: (bool value) {
                 setState(() {
                   _likeNotificationsEnabled = value;
                 });
               },
             ),
             Divider(height: 1, thickness: 1, color: dividerColor, indent: 20, endIndent: 20),
             _buildSwitchTile(
               title: 'Comments',
               value: _commentNotificationsEnabled,
               onChanged: (bool value) {
                 setState(() {
                   _commentNotificationsEnabled = value;
                 });
               },
             ),
             Divider(height: 1, thickness: 1, color: dividerColor, indent: 20, endIndent: 20),
           ],


          // --- Modified Navigation Tile for Start Time ---
          _buildNavigationTile(
            title: 'Start your Day with Emogotchi',
            // Display the formatted time, or 'Not Set'
            currentValue: formattedStartTime,
            onTap: () {
              _showCupertinoTimePicker(
                  context: context,
                  initialTime: _selectedStartTime, // Pass current value as initial
                  onTimeChanged: (newTime) {
                    setState(() {
                      _selectedStartTime = newTime; // Update state when Done is pressed
                    });
                  }
              );
            },
          ),
          Divider(height: 1, thickness: 1, color: dividerColor, indent: 20, endIndent: 20),


          // --- Navigation Tile for Duration (Example) ---
          _buildNavigationTile(
            title: 'Duration',
            // Display combined start/end time or placeholder
            currentValue: durationValue, // This requires setting _selectedEndTime too
            onTap: () {
              // You would need two pickers or a custom range picker here.
              // Example: Show picker for End Time
               _showCupertinoTimePicker(
                  context: context,
                  initialTime: _selectedEndTime,
                  onTimeChanged: (newTime) {
                    setState(() {
                      _selectedEndTime = newTime;
                    });
                  }
              );
              print("Duration Tapped - Implement time range selection logic");
            },
          ),
          Divider(height: 1, thickness: 1, color: dividerColor, indent: 20, endIndent: 20),

          // --- Other Settings (Notification Sound) ---
          _buildNavigationTile(
            title: 'Notification Sound',
            currentValue: 'Default', // Replace with actual setting value
            onTap: () {
              // Navigate to sound selection
            },
          ),
          Divider(height: 1, thickness: 1, color: dividerColor, indent: 20, endIndent: 20),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}