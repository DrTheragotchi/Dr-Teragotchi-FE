import 'package:flutter/material.dart';
import 'main/notificationSettingPage.dart';
import 'package:flutter/cupertino.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  // Updated helper function for action buttons with optional custom colors
  Widget _buildActionButton(
    BuildContext context,
    String text,
    VoidCallback onPressed, {
    Color? backgroundColor,
    Color? textColor,
  }) {
    return SizedBox(
      width: double.infinity, // Make button take full width within padding
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ??
              Colors.grey[100], // Use passed value or default light grey
          foregroundColor:
              textColor ?? Colors.black, // Use passed value or default black
          elevation: 0, // No shadow
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0), // Rounded corners
          ),
          padding:
              const EdgeInsets.symmetric(vertical: 16.0), // Vertical padding
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  // Helper function for the footer links (making them tappable)
  Widget _buildFooterLink(String text, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[600], // Grey color for links
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // White background
      body: SafeArea(
        // Keeps content below the status bar
        child: Padding(
          // Horizontal padding for the main content
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Spacing from the top
              const SizedBox(height: 50),

              // --- Profile Avatar Section ---
              Container(
                padding:
                    const EdgeInsets.all(4), // Padding around the CircleAvatar
                decoration: BoxDecoration(
                  color: Colors.blue, // Blue background color
                  borderRadius: BorderRadius.circular(
                      28), // Rounded corners for the square background
                ),
                child: const CircleAvatar(
                  radius: 55, // Adjust radius as needed
                  // Placeholder background color for the avatar
                  backgroundColor: Colors.white,
                  // Replace with your actual image loading logic
                  child: Icon(
                    Icons
                        .pets, // Placeholder Icon (replace with Image.network or AssetImage)
                    size: 60,
                    color: Colors.blue,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'nickname', // Replace with actual nickname variable
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Level', // Replace with actual level or status
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[500],
                ),
              ),

              // Spacing before buttons
              const SizedBox(height: 30),

              // --- Action Buttons ---
              _buildActionButton(context, 'Change nickname', () {
                // Handle Change nickname action
              }),
              const SizedBox(height: 16), // Spacing between buttons
              _buildActionButton(context, 'Notification', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NotificationSettingsPage()),
                );
              }),
              const SizedBox(height: 16),
              _buildActionButton(context, 'Support', () {
                // Handle Support action
              }),
              const SizedBox(height: 16),
              _buildActionButton(
                context,
                'Delete Account',
                () {
                  // Handle Delete Account action
                },
                backgroundColor: Colors.red, // Set button's background to red
                textColor: Colors.white, // Set text color to white
              ),

              // This pushes the footer links to the bottom
              const Spacer(),

              // --- Footer Links ---
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 20.0), // Space from bottom edge
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly, // Distribute links evenly
                  children: [
                    _buildFooterLink('Terms of Service', () {
                      /* Handle Terms */
                    }),
                    Text('|',
                        style: TextStyle(color: Colors.grey[400])), // Separator
                    _buildFooterLink('Privacy Policy', () {
                      /* Handle Privacy */
                    }),
                    Text('|', style: TextStyle(color: Colors.grey[400])),
                    _buildFooterLink('Bug Report', () {
                      /* Handle Bug Report */
                    }),
                    Text('|', style: TextStyle(color: Colors.grey[400])),
                    _buildFooterLink('FeedBack', () {/* Handle Feedback */}),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
