import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Lottie.asset(
              'assets/icons/community.json',
              width: 200,
              height: 200,
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Text(
                    'Attendify - Attendance and Leave Management System',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Attendify is a comprehensive attendance and leave management system designed to streamline attendance tracking and leave management processes. It provides fingerprint authentication for attendance marking and displays the attendance records efficiently. Moreover, it offers a leave request feature and can display the status of leave requests for employees.',
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            ContactCard(),
          ],
        ),
      ),
    );
  }
}

class ContactCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 20),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contact Us',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            ListTile(
              leading: Icon(Icons.mail),
              title: Text('attendify@gmail.com'),
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('+91 9656543222'),
            ),
          ],
        ),
      ),
    );
  }
}
