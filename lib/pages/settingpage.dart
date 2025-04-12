import 'package:flutter/material.dart';


class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  // Helper function to create category headers
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 24.0, bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600, // Make headers slightly bolder
          color: Colors.grey[800], // Darker grey for headers
        ),
      ),
    );
  }

  // Helper function to create setting list tiles
  Widget _buildSettingsTile({
    required String title,
    String? value, // Optional value like "ON" or "OFF"
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          color: Colors.grey[700], // Slightly lighter text for items
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min, // Row takes minimum space needed
        children: [
          if (value != null) // Show value text only if provided
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[500], // Lighter grey for value
                ),
              ),
            ),
          Icon(
            Icons.chevron_right,
            color: Colors.grey[400], // Light grey chevron
            size: 24,
          ),
        ],
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0), // Adjust padding
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Light grey background like the image
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.grey[800]), // Back icon
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text( 
          'Setting',
            style: TextStyle(
            fontFamily: 'Cursive', // Use a built-in cursive font
            fontSize: 28, // Adjust size as needed
            fontWeight: FontWeight.w700,
            color: Colors.grey[850], // Dark text color for title
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent, // Make AppBar transparent
        elevation: 0, // No shadow
      ),
      body: ListView(
        children: [
          _buildSectionHeader('System Setting'),
          _buildSettingsTile(title: 'Screen Lock', value: 'OFF', onTap: () {}),
          _buildSettingsTile(title: 'Maximum Rewards', value: 'OFF', onTap: () {}),
          _buildSettingsTile(title: 'Haptics', value: 'ON', onTap: () {}),
          _buildSettingsTile(title: 'Fix Errors', onTap: () {}),
          _buildSettingsTile(title: 'Language Setting', onTap: () {}),

          _buildSectionHeader('Notification settings'),
          _buildSettingsTile(title: 'Notifications', onTap: () {}),

          _buildSectionHeader('Personal/Privacy'),
          _buildSettingsTile(title: 'Couple Connection', onTap: () {}),
          _buildSettingsTile(title: 'Sign out', onTap: () {}),

          // Notification Banner Section (Simplified)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              decoration: BoxDecoration(
                color: Colors.yellow[100]?.withOpacity(0.7), // Light yellow, slightly transparent
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                children: [
                  Icon(Icons.notifications_off_outlined, color: Colors.orange[600], size: 24),
                  const SizedBox(width: 12),
                  Expanded( // Allows text to wrap
                    child: Text(
                      'Notifications are turned off!\nTurning them on will quickly deliver updates from others to you.',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 13,
                      ),
                    ),
                  ),
                  // You could add decorative elements here if needed
                ],
              ),
            ),
          ),
          const SizedBox(height: 80), // Add space at the bottom if needed (e.g., for ads/nav bar)
        ],
      ),
    );
  }
}