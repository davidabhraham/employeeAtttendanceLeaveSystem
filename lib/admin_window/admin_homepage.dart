import 'dart:async';

import 'package:attendify_1/admin_window/users_Listpage.dart';
import 'package:attendify_1/admin_window/view_requests.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';

class AdminHomepage extends StatefulWidget {
  const AdminHomepage({Key? key}) : super(key: key);

  @override
  State<AdminHomepage> createState() => _AdminHomepageState();
}

class _AdminHomepageState extends State<AdminHomepage> {
  late StreamSubscription<DocumentSnapshot> _userSubscription;

  final BorderRadius _borderRadius = const BorderRadius.only(
    topLeft: Radius.circular(25),
    topRight: Radius.circular(25),
  );

  ShapeBorder? bottomBarShape = const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(25)),
  );
  SnakeBarBehaviour snakeBarStyle = SnakeBarBehaviour.floating;
  EdgeInsets padding = const EdgeInsets.all(12);

  SnakeShape snakeShape = SnakeShape.circle;

  Color selectedColor = Colors.black;
  Color unselectedColor = Colors.blueGrey;

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Call the function to get user role when the widget initializes
    getUserRole();
  }

  Future<void> getUserRole() async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('attendifyUsers')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    if (userDoc.exists) {
      setState(() {
        // Set the index based on the user's role
        if (userDoc['userRole'] == 'employee') {
          _selectedIndex = 0;
        } else if (userDoc['userRole'] == 'admin') {
          _selectedIndex = 1;
        }
      });
    }
  }

  static final List<Widget> _widgetOptions = <Widget>[
    const UsersListPage(),
    ViewLeaveRequestsPage(),
    // Add more pages if needed
  ];

  void _onItemTapped(int index) {
    setState(() {
      // Update the selected index when an item is tapped
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: SnakeNavigationBar.color(
        behaviour: snakeBarStyle,
        snakeShape: snakeShape,
        shape: bottomBarShape,
        padding: padding,
        snakeViewColor: selectedColor,
        selectedItemColor:
            snakeShape == SnakeShape.indicator ? selectedColor : null,
        unselectedItemColor: unselectedColor,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          // Admin Screen navigation bar icons
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Users List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.request_page),
            label: 'User Requests',
          ),
        ],
      ),
    );
  }
}
