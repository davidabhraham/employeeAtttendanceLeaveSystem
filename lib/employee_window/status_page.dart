import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StatusPage extends StatefulWidget {
  const StatusPage({super.key});

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  //to check and get the logged in user email for searching
  final String _userEmail =
      FirebaseAuth.instance.currentUser!.email!; // Assuming user is signed in

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leave Request Status'),
        backgroundColor: Color.fromARGB(255, 168, 154, 202),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('leave_requests')
            .where('email', isEqualTo: _userEmail)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No leave requests found.'),
            );
          } else {
            final leaveRequests = snapshot.data!.docs;
            return ListView.builder(
              itemCount: leaveRequests.length,
              itemBuilder: (context, index) {
                final leaveRequest = leaveRequests[index];
                final reason = leaveRequest['reason'] ?? '';
                final timestamp = leaveRequest['timestamp'] != null
                    ? (leaveRequest['timestamp'] as Timestamp).toDate()
                    : null;
                final status = leaveRequest['Status'] ?? '';

                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  elevation: 2.0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Reason: $reason',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Timestamp: ${timestamp != null ? timestamp.toString() : "Unknown"}',
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          // displaying status
                          'Status: $status',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
