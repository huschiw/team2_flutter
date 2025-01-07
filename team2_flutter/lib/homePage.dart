import 'package:flutter/material.dart';
import 'profilePage.dart';
import 'systemPage.dart';
import 'components/bottomNavBar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Widget> _pages = [
    const Center(
      child: Text(
        'Home Page',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    ),
    const SystemPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return BottomNavBar(pages: _pages); // ใช้ BottomNavBar
  }
}
