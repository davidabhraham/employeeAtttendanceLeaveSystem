import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UsersListPage extends StatefulWidget {
  // page for showing Users details
  const UsersListPage({super.key});

  @override
  State<UsersListPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<UsersListPage> {
  final UserService _userService = UserService();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: Icon(Icons.logout))
        ],
        title: Text('Administration Desk'),
        backgroundColor: Color.fromARGB(255, 54, 180, 186),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _userService.getStudentUsersStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No employees found.'));
          } else {
            List<Map<String, dynamic>> users = snapshot.data!;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> user = users[index];
                bool isDisabled =
                    user['isDisabled'] ?? false; // Check if user is disabled

                return GestureDetector(
                  onTap: () {},
                  child: Card(
                    elevation: 3.0,
                    margin:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: ListTile(
                      title: Text(
                        user['userName'] ?? '',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user['userEmail'] ?? ''),
                          SizedBox(height: 8.0),
                          Text(
                            'Attendance Days: $attendanceDays',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 4, 96, 52)),
                          ),
                        ],
                      ),
                      trailing: Switch(
                        value:
                            !isDisabled, // Invert value for better user understanding
                        onChanged: (newValue) {
                          _userService.updateUserDisabledStatus(
                              user['userId'], !newValue);
                        },
                      ),
                      onTap: () {
                        // Add any additional functionality when tapping on a user
                      },
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

class UserService {
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('attendifyUsers');

  Stream<List<Map<String, dynamic>>> getStudentUsersStream() {
    return _usersCollection
        .where('userRole', isEqualTo: 'employee')
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList());
  }

  Future<void> updateUserDisabledStatus(String userId, bool isDisabled) {
    // for updating user disbled ststus in the admin UserListpage
    return _usersCollection.doc(userId).update({'isDisabled': isDisabled});
  }
}
