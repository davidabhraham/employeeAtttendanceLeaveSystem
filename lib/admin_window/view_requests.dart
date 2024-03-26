import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewLeaveRequestsPage extends StatelessWidget {
  final CollectionReference userRequestRef =
      FirebaseFirestore.instance.collection('user_requests'); //newly added

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 168, 154, 202),
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: Icon(Icons.logout))
        ],
        title: Text('Leave Requests'),
      ),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('leave_requests').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No leave requests found.'),
            );
          } else {
            final leaveRequests = snapshot.data!.docs;
            return ListView.builder(
              itemCount: leaveRequests.length,
              itemBuilder: (context, index) {
                final leaveRequest = leaveRequests[index];
                final branch = leaveRequest['branch'] ?? '';
                final reason = leaveRequest['reason'] ?? '';
                final email = leaveRequest['email'] ?? '';
                final timestamp = leaveRequest['timestamp'] != null
                    ? (leaveRequest['timestamp'] as Timestamp).toDate()
                    : null;

                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  elevation: 2.0,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LeaveRequestDetailPage(
                            reason: reason,
                            email: email,
                            timestamp: timestamp,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Reason: $reason',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'Email: $email',
                            style: TextStyle(fontSize: 14),
                          ),
                          SizedBox(height: 4.0),
                          Text(
                            'Timestamp: ${timestamp != null ? timestamp.toString() : "Unknown"}',
                            style: TextStyle(fontSize: 14),
                          ),
                          ElevatedButton(
                              onPressed: () {
                                // id obtained from leaveRequest
                                updateLeaveRequestStatus(
                                    leaveRequest.id, 'Approved');
                              },
                              child: Text('Accept')),
                          SizedBox(height: 4.0),
                          ElevatedButton(
                              onPressed: () {
                                updateLeaveRequestStatus(
                                    leaveRequest.id, 'Rejected');
                              },
                              child: Text('Reject')),
                        ],
                      ),
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

class LeaveRequestDetailPage extends StatelessWidget {
  final String reason;
  final String email;
  final DateTime? timestamp;

  LeaveRequestDetailPage({
    required this.reason,
    required this.email,
    this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leave Request Detail'),
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
            SizedBox(height: 8.0),
            Text(
              reason,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20.0),
            Text(
              'Email:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              email,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20.0),
            Text(
              'Timestamp:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              timestamp != null ? timestamp!.toString() : 'Unknown',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> updateLeaveRequestStatus(String docId, String newStatus) async {
  // function for updating new status in leave request collection
  final docRef =
      FirebaseFirestore.instance.collection('leave_requests').doc(docId);
  await docRef.update({'Status': newStatus});
}
