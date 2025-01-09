// bottomNavBar
// ignore_for_file: file_names

import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  final List<Widget> pages;
  final AppBar? appBar; // Make appBar nullable

  const BottomNavBar({super.key, required this.pages, this.appBar}); // Use this.appBar

  @override
  // ignore: library_private_types_in_public_api
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update state when a menu is selected
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.appBar, // Use the appBar variable here
      body: widget.pages[_selectedIndex], // Show the selected page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFF454EC5), // Color for selected menu
        unselectedItemColor: Colors.grey,          // Color for unselected menu
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Voice',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
