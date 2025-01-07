//bottomNacBar
// ignore_for_file: file_names

import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  final List<Widget> pages;

  const BottomNavBar({super.key, required this.pages});

  @override
  // ignore: library_private_types_in_public_api
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // อัปเดตสถานะเมื่อเลือกเมนู
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.pages[_selectedIndex], // แสดงหน้าที่เลือก
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFF454EC5), // สีเมนูที่เลือก
        unselectedItemColor: Colors.grey,          // สีเมนูที่ไม่ได้เลือก
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
