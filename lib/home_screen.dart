import 'dart:async';

import 'package:attendify_1/admin_window/admin_homepage.dart';
import 'package:attendify_1/admin_window/users_Listpage.dart';
import 'package:attendify_1/admin_window/view_requests.dart';
import 'package:attendify_1/disable_screen.dart';
import 'package:attendify_1/employee_window/about_us_page.dart';
import 'package:attendify_1/employee_window/leave_request.dart';
import 'package:attendify_1/employee_window/mark_attedance.dart';
import 'package:attendify_1/employee_window/profile_page.dart';
import 'package:attendify_1/employee_window/status_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    super.initState();
    getUserRole();
    _userSubscription = FirebaseFirestore.instance
        .collection('attendifyUsers')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .listen((DocumentSnapshot snapshot) {
      setState(() {
        _isDisabled = snapshot['isDisabled'] ?? false;
      });
    });
  }

  bool _isDisabled = false;
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

  bool showSelectedLabels = false;
  bool showUnselectedLabels = false;

  Color selectedColor = Colors.black;
  Color unselectedColor = Colors.blueGrey;

  Gradient selectedGradient =
      const LinearGradient(colors: [Colors.red, Colors.amber]);
  Gradient unselectedGradient =
      const LinearGradient(colors: [Colors.red, Colors.blueGrey]);

  Color? containerColor;

  int _selectedIndex = 0;

  int index = 0;

  Future<int?> getUserRole() async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('attendifyUsers')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    if (userDoc.exists) {
      setState(() {
        if (userDoc['userRole'] == 'employee') {
          index = 0;
        } else if (userDoc['userRole'] == 'admin') {
          index = 1;
        }
      });

      return index;
    } else {
      return null;
    }
  }

  static final List<Widget> _widgetOptions = <Widget>[
    AttendancePageNew(),
    LeaveRequestPage(),
    StatusPage(),
    const ProfilePage(),
    AboutUsPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: Colors.white10,
      //   title: Text('BusBoard'),
      // ),
      body: _isDisabled
          ? DisabledUserScreen()
          : index == 0
              ? _widgetOptions.elementAt(_selectedIndex)
              : AdminHomepage(),
      bottomNavigationBar: index == 0
          ? SnakeNavigationBar.color(
              behaviour: snakeBarStyle,
              snakeShape: snakeShape,
              shape: bottomBarShape,
              padding: padding,

              ///configuration for SnakeNavigationBar.color
              snakeViewColor: selectedColor,
              selectedItemColor:
                  snakeShape == SnakeShape.indicator ? selectedColor : null,
              unselectedItemColor: unselectedColor,
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.file_open,
                  ),
                  label: 'Attendance',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.map),
                  label: 'Request',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.file_present_sharp),
                  label: 'User Request Status',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.groups),
                  label: 'About Us',
                ),
              ],
            )
          : null,
    );
  }
}
