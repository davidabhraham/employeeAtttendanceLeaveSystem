import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DisabledUserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         actions: [ // logout button  for disabled screen 
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: Icon(Icons.logout))
        ],
        title: Text('Disabled Access'),
        backgroundColor: Colors.redAccent, // Customize the app bar color
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.block,
              size: 100,
              color: Colors.redAccent,
            ),
            SizedBox(height: 20),
            Text(
              'Your access to Attendify has been disabled.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
