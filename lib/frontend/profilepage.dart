import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.blueGrey.shade100,
            ),
            SizedBox(height: 20),
            Text(
              'Sreya',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blueGrey.shade700),
            ),
            SizedBox(height: 8),
            Text(
              'Sreya@example.com',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      '50',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey.shade700,
                      ),
                    ),
                    Text('Tasks Completed'),
                  ],
                ),
                SizedBox(width: 40),
                Column(
                  children: [
                    Text(
                      '100',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey.shade700,
                      ),
                    ),
                    Text('Total Tasks'),
                  ],
                ),
              ],
            ),
            SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.edit),
              label: Text('Edit Profile'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 36, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.logout, color: Colors.red),
              label: Text('Logout', style: TextStyle(color: Colors.red)),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 36, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                side: BorderSide(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
