import 'package:flutter/material.dart';
import 'package:sound_of_meme/Views/home/explore_songs.dart';
import 'package:sound_of_meme/Views/home/my_profile.dart';

import 'create_songs.dart'; // Import the Create Song screen

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    ExploreSongsScreen(), // Placeholder for Explore Songs screen
    CreateSongScreen(), // Create Song screen
    ProfileScreen(), // Placeholder for Profile screen
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore Song',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.create),
            label: 'Create Song',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
