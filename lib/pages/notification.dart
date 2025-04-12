import 'package:flutter/material.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({Key? key}) : super(key: key);

  @override
  State<NotificationSettingsPage> createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  // State variables for the toggles
  bool _allNotificationsEnabled = true;
  bool _likeNotificationsEnabled = true;
  bool _commentNotificationsEnabled = false;
  // Add more state variables as needed

  // Helper for SwitchListTile styling
  Widget _buildSwitchTile({
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile.adaptive( // .adaptive uses appropriate switch style for iOS/Android
      title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
      subtitle: subtitle != null
          ? Text(subtitle, style: TextStyle(color: Colors.grey[400], fontSize: 13))
          : null,
      value: value,
      onChanged: onChanged,
      activeColor: Colors.tealAccent[100], // Example active color for dark theme
      inactiveTrackColor: Colors.grey[700],
      inactiveThumbColor: Colors.grey[400],
      contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
    );
  }

  // Helper for Navigation ListTile styling
  Widget _buildNavigationTile({
    required String title,
    String? currentValue, // e.g., show selected time slot
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

  @override
  Widget build(BuildContext context) {
    // Define dark theme colors (could also be part of app theme)
    const Color darkBackgroundColor = Color(0xFF1A1A1A); // Very dark grey
    const Color appBarColor = Color(0xFF222222); // Slightly lighter dark grey
    final Color dividerColor = Colors.grey[800]!;

    return Scaffold(
      backgroundColor: darkBackgroundColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        elevation: 0, // No shadow
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Notifications', // Changed title
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        // Optional: Add progress bar like in the image if needed
        // bottom: PreferredSize(
        //   preferredSize: const Size.fromHeight(4.0),
        //   child: LinearProgressIndicator(
        //     value: 0.5, // Example progress value
        //     backgroundColor: Colors.grey[700],
        //     valueColor: const AlwaysStoppedAnimation<Color>(Colors.tealAccent),
        //   ),
        // ),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20), // Space from AppBar

          // Example Header Text (like the image)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'Manage your notifications', // Changed Header
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'Choose what updates you want to receive.', // Changed Subheader
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 25),

          // --- Notification Toggles ---
          _buildSwitchTile(
            title: 'All Notifications',
            subtitle: 'Enable or disable all app alerts',
            value: _allNotificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                _allNotificationsEnabled = value;
                // Optionally update other toggles based on this one
                _likeNotificationsEnabled = value;
                _commentNotificationsEnabled = value;
              });
            },
          ),
          Divider(height: 1, thickness: 1, color: dividerColor, indent: 20, endIndent: 20),

          // Only show specific toggles if all notifications are enabled
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
            // Add more specific notification types here...
          ],

          // --- Other Settings ---
          _buildNavigationTile(
            title: 'Notification Time Slot',
            currentValue: 'Always', // Replace with actual setting value
            onTap: () {
              // Navigate to time slot selection page or show dialog
            },
          ),
          Divider(height: 1, thickness: 1, color: dividerColor, indent: 20, endIndent: 20),

           _buildNavigationTile(
            title: 'Notification Sound',
            currentValue: 'Default', // Replace with actual setting value
            onTap: () {
              // Navigate to sound selection
            },
          ),
           Divider(height: 1, thickness: 1, color: dividerColor, indent: 20, endIndent: 20),


          const SizedBox(height: 30), // Space at the bottom
        ],
      ),
    );
  }
}