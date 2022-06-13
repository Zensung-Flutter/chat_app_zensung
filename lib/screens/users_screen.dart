
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utlis/utilities.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  List users = [];

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  signOutUser();
                },
                icon: Icon(Icons.logout, color: Colors.white))
          ],
        ),
        body: ListView.builder(
          itemCount: users.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              child: Card(
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        getUserInitials(users[index]['firstName'],
                            users[index]['lastName']),
                        SizedBox(
                          width: 30,
                        ),
                        Text(
                          getUserName(users[index]['firstName'],
                              users[index]['lastName']),
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    )),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ChatScreen(
                            userUid: users[index]['uid'],
                            userName: getUserName(users[index]['firstName'],
                                users[index]['lastName']))));
              },
            );
          },
        ));
  }

  void signOutUser() {
    FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (_) => LoginScreen()), (route) => false);
  }

  void getUser() {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection('users')
        .where('uid', isNotEqualTo: uid)
        .get()
        .then((value) {
      setState(() {
        users = value.docs;
      });
      print(users);
    }).catchError((e) {
      print(e.toString());
    });
  }

}
