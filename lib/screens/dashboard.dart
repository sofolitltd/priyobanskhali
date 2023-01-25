import 'package:flutter/material.dart';
import 'package:priyobanskhali/screens/profile/profile.dart';

import '../shelf.dart';
import 'home/home.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

List screenList = [const Home(), const Shelf(), const Profile()];

class _DashboardState extends State<Dashboard> {
  int _selectedScreen = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _selectedScreen,
        onTap: (index) => setState(() => _selectedScreen = index),
        items: const [
          //
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          //
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Shelf',
          ),
          //
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      //
      body: screenList[_selectedScreen],
    );
  }
}
