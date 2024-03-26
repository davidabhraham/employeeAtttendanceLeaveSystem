import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AttendancePageNew extends StatefulWidget {
  const AttendancePageNew({Key? key}) : super(key: key);

  @override
  _AttendancePageNewState createState() => _AttendancePageNewState();
}

class _AttendancePageNewState extends State<AttendancePageNew> {
  int attendanceDays = 0;

  @override
  void initState() {
    super.initState();
    fetchAttendance();
  }

  Future<void> fetchAttendance() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('attendifyUsers')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          attendanceDays = userDoc['attendanceIndays'] ?? 0;
        });
      }
    } catch (e) {
      print('Error fetching attendance: $e');
    }
  }

  Future<void> markAttendance() async {
    try {
      // Increment attendance count in Firestore
      await FirebaseFirestore.instance
          .collection('attendifyUsers')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'attendanceIndays': attendanceDays + 1});

      setState(() {
        attendanceDays++;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Attendance marked successfully!'),
        ),
      );
    } catch (e) {
      print('Error marking attendance: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to mark attendance. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 100,
          ),
          const Text(
            'Welcome Back!',
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width - 40,
            child: //Lottie.asset('assets/icons/animationtwo.json'),
                // Image.asset('assets/icons/smartphone.png'),
                attendanceImageWidget(),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Attendance This Month',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildAttendanceItem(
                            'Attendance Days: ', '$attendanceDays'),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                    _buildTimeInItem('Last Time In', '10.00 AM'),
                    SizedBox(
                      height: 10,
                    ),
                    _buildTimeOutItem('Last Time Out', '9.00 PM'),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: markAttendance,
                      child: Text('Mark Attendance'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class attendanceImageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AssetImage attendanceImage = AssetImage('assets/icons/app-store.png');
    Image image = Image(image: attendanceImage, width: 200, height: 200);
    return Container(
      child: image,
    );
  }
}

Widget _buildTimeInItem(String label, String value) {
  return Column(
    children: [
      Text(
        label,
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey[600],
        ),
      ),
      const SizedBox(height: 5),
      Text(
        value,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );
}

Widget _buildTimeOutItem(String label, String value) {
  return Column(
    children: [
      Text(
        label,
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey[600],
        ),
      ),
      const SizedBox(height: 5),
      Text(
        value,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );
}
