import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 20.0, bottom: 20.0),
                            child: Text(
                                '${users[index]['firstName']} ${users[index]['lastName']}'),
                          ),
                          Text(
                            users[index]['age'].toString(),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: users[index]['isOnline']
                                      ? Colors.green
                                      : Colors.red),
                            ),
                          ),
                          Text(users[index]['timestamp']),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ChatScreen(
                            userUid: users[index]['uid'],
                            userName: users[index]['firstName'])));
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
