import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  List users = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                SignOutUser();
              },
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              ),
            )
          ],
        ),
        body: ListView.builder(
          itemCount: users.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (_) => ChatScreen(
                            userid: users[index]['uid'],
                            username: users[index]['name'],
                          )),
                );
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(users[index]['name']),
                          ),
                          Text(users[index]['age']),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            height: 10,
                            width: 10,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: users[index]['isOnline']
                                  ? Colors.green
                                  : Colors.grey,
                            ),
                          ),
                          Text(users[index]['timestamp']),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ));
  }

  void SignOutUser() {
    FirebaseAuth.instance.signOut();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => LoginScreen()), (route) => false);
  }

  void GetUsers() {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection('users')
        .where('uid', isNotEqualTo: uid)
        .get()
        .then((value) {
      setState(() {
        users = value.docs;
      });
    }).catchError(
      (e) {
        print(e.toString());
      },
    );
  }
}
