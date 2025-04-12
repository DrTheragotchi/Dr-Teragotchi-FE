import 'package:emogotchi/pages/settingpage.dart';
import 'package:flutter/material.dart';
// Import the SettingPage class from its file


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // You might want to set the default scaffold background color
        // if you want consistency across pages before navigation
        // scaffoldBackgroundColor: Colors.grey[50],
      ),
      // Define the home page
      home: const HomePage(),
    );
  }
}

// A simple example home page
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          // Add an icon button to the AppBar
          IconButton(
            icon: const Icon(Icons.settings), // Settings icon
            tooltip: 'Open Settings',
            onPressed: () {
              // Action to navigate to SettingPage
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingPage()),
              );
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('This is the Home Page.\nTap the settings icon in the AppBar.'),
      ),
    );
  }
}