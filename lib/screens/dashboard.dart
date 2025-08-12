import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '/screens/profile/profile.dart';
import '/screens/shop/shop.dart';
import 'blog/blog_screen.dart';
import 'home/home.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedScreen = 0;

  List screenList = [
    const Home(),
    const BlogScreen(),
    const Shop(),
    const Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        selectedIndex: _selectedScreen,
        onDestinationSelected: (index) =>
            setState(() => _selectedScreen = index),
        destinations: const [
          //
          NavigationDestination(
            icon: Icon(Iconsax.home),
            label: 'Home',
          ),
          //

          NavigationDestination(
            icon: Icon(Iconsax.box),
            label: 'Blog',
          ),

          NavigationDestination(
            icon: Icon(Iconsax.shopping_bag),
            label: 'Shop',
          ),

          NavigationDestination(
            icon: Icon(Iconsax.profile_2user),
            label: 'Profile',
          ),
        ],
      ),
      //
      body: screenList[_selectedScreen],
    );
  }
}
