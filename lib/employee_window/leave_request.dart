import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LeaveRequestPage extends StatefulWidget {
  @override
  _LeaveRequestPageState createState() => _LeaveRequestPageState();
}

class _LeaveRequestPageState extends State<LeaveRequestPage> {
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _branchController = TextEditingController();

  Future<void> _submitLeaveRequest() async {
    try {
      await FirebaseFirestore.instance.collection('leave_requests').add({
        'branch': _branchController.text,
        'reason': _reasonController.text,
        'email': _emailController.text,
        'description': _descriptionController.text,
        'timestamp': FieldValue.serverTimestamp(),
        'Status': 'pending...',
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Leave request submitted successfully!'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('Error submitting leave request: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to submit leave request. Please try again.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leave Request'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reason for leave:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _reasonController,
              maxLines: 3,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your reason for leave',
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Your Email:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your email address',
              ),
            ),
            Text(
              'Branchname:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            TextField(
              controller: _branchController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your Branch Name',
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Description (Optional):',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter any additional information (optional)',
              ),
            ),
            SizedBox(height: 15),
            Center(
              child: ElevatedButton(
                onPressed: _submitLeaveRequest,
                child: Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
