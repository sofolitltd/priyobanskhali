import 'package:flutter/material.dart';
import '/screens/profile/profile.dart';
import '/screens/shop/shop.dart';

import 'blog/blog_screen.dart';
import 'home/home.dart';
import 'shelf/shelf.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

List screenList = [
  const Home(),
  const BlogScreen(),
  const Shop(),
  const Profile(),
];

class _DashboardState extends State<Dashboard> {
  int _selectedScreen = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _selectedScreen,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _selectedScreen = index),
        items: const [
          //
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          //
          BottomNavigationBarItem(
            icon: Icon(Icons.pages_outlined),
            label: 'Blog',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            label: 'Shop',
          ),

          //
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
      //
      body: screenList[_selectedScreen],
    );
  }
}
