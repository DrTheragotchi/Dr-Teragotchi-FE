import 'package:flutter/material.dart';
import 'main/notificationSettingPage.dart';
import 'package:flutter/cupertino.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  // Helper function for action buttons with optional custom colors
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
          backgroundColor: backgroundColor ?? Colors.grey[100],
          foregroundColor: textColor ?? Colors.black,
          elevation: 0, // No shadow
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0), // Rounded corners
          ),
          padding: const EdgeInsets.symmetric(vertical: 16.0),
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
          color: Colors.grey[600],
        ),
      ),
    );
  }

  void _showDeleteAccountConfirmation(BuildContext context) {
    showCupertinoDialog(
      context: context,
      barrierDismissible:
          false, // Prevent closing the dialog by tapping outside
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Delete the account?'),
          content: Column(
            mainAxisSize: MainAxisSize.min, // Keep the column compact
            children: [
              // Display an asset image (update the asset path as needed)
              Image.asset(
                'assets/penguin/penguin_sad.png', // Replace with your actual image path
                height: 100, // Adjust the height as needed
              ),
              const SizedBox(height: 10),
              const Text(
                'Do you really want to say GoodBye to ur soulmate?',
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
          actions: <Widget>[
            // Cancel button
            CupertinoDialogAction(
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
            ),
            // Turn Off button (destructive)
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                // Place your turn-off or delete logic here if desired
                Navigator.pop(context); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // White background
      body: SafeArea(
        // Keeps content below the status bar
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Spacing from the top
              const SizedBox(height: 50),

              // --- Profile Avatar Section ---
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: const CircleAvatar(
                  radius: 55,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.pets,
                    size: 60,
                    color: Colors.blue,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'nickname',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Level',
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
              const SizedBox(height: 16),
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
                  // Show the confirmation popup when Delete Account is pressed
                  _showDeleteAccountConfirmation(context);
                },
                backgroundColor: Colors.red,
                textColor: Colors.white,
              ),

              // Spacer pushes the footer links to the bottom
              const Spacer(),

              // --- Footer Links ---
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildFooterLink('Terms of Service', () {
                      // Handle Terms
                    }),
                    Text(
                      '|',
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                    _buildFooterLink('Privacy Policy', () {
                      // Handle Privacy
                    }),
                    Text(
                      '|',
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                    _buildFooterLink('Bug Report', () {
                      // Handle Bug Report
                    }),
                    Text(
                      '|',
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                    _buildFooterLink('FeedBack', () {
                      // Handle Feedback
                    }),
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
