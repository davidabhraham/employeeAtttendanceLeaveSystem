import 'dart:async';

import 'package:attendify_1/constants.dart';
import 'package:attendify_1/employee_window/profile_page.dart';
import 'package:attendify_1/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseUIAuth.configureProviders([EmailAuthProvider()]);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        primaryColor: defaultPropertyBackgroundColour,
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      home: const AuthWidget(),
    );
  }
}

class AuthWidget extends StatefulWidget {
  const AuthWidget({super.key});

  @override
  State<AuthWidget> createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  final FirestoreService firestoreService = FirestoreService();
  int segmentedControlGroupValue = 0; // for Role selection access control
  final Map<int, Widget> myTabs = const <int, Widget>{
    0: Text('Employee'),
    1: Text('Admin'),
  };

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Homepage();
        }
        return SignInScreen(
          subtitleBuilder: (context, action) {
            final actionText = switch (action) {
              AuthAction.signIn => 'Please sign in to continue.',
              AuthAction.signUp => 'Please create an account to continue',
              _ => throw Exception('Invalid action: $action'),
            };

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text('Welcome to Attendify! $actionText.'),
            );
          },
          footerBuilder: (context, action) {
            final actionText = switch (action) {
              AuthAction.signIn => 'signing in',
              AuthAction.signUp => 'registering',
              _ => throw Exception('Invalid action: $action'),
            };

            return Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                CupertinoSlidingSegmentedControl(
                    groupValue: segmentedControlGroupValue,
                    children: myTabs,
                    onValueChanged: (i) {
                      setState(() {
                        segmentedControlGroupValue = i!;
                      });

                      print(segmentedControlGroupValue);
                    }),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      'By $actionText, you agree to our terms and conditions.',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ],
            );
          },
          headerBuilder: (context, constraints, shrinkOffset) {
            return Center(
              child: Image.asset('assets/icons/smartphone.png',
                  width: 100, height: 100),
            );
          },
          providers: [EmailAuthProvider()],
          actions: [
            AuthStateChangeAction<UserCreated>((context, state) async {
              _createUserDocument(state.credential.user!);// creating user documnent based on Uid
              if (kDebugMode) {
                print('New User Created');
              }
            }),
            AuthStateChangeAction<SignedIn>((context, state) {}),
          ],
        );
      },
    );
  }

  void _createUserDocument(User user) async {
    try {
      // Creation of user document in Firestore at the time of registering the user
      await FirebaseFirestore.instance
          .collection('attendifyUsers')
          .doc(user.uid)
          .set({
        'isDisabled': false,
        'userId': user.uid,
        'userAlias': "User",
        'attendanceIndays': '',
        'timeIn':'',
        'timeOut': '',
        'userName': "User",
        'userEmail': user.email,
        'userRole': segmentedControlGroupValue == 0 ? 'employee' : 'admin',
        'userPhone': '',
        'userDepartment': '',
        'userGender': '',
        'userAge': '',
        'userProfileImage':
            'https://cdn-icons-png.flaticon.com/512/666/666201.png',
        'userAddress': '',
      });
      if (kDebugMode) {
        print('New User Created');
      }
    } catch (e) {
      // Handle any errors that occur during the document creation process
      print('Error creating user document: $e');
      // You can show an error message to the user or handle the error in any other way
    }
  }
}
