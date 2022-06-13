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

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(
            onPressed: () {
              SignOutUser();
            },
            icon: Icon(Icons.logout))
      ]),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(users[index]['name']),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(users[index]['age'].toString()),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 10,
                              width: 10,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: users[index]['isOnline']
                                      ? Colors.green
                                      : Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            onTap: () {
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => ChatScreen()));

              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => ChatScreen(
                        userName: users[index]['name'],
                        userUid: users[index]['name'],
                      )));
            },
          );
          // Text(users[index]['name']);
        },
      ),
      // body: Center(
      //   child: GestureDetector(
      //     child: Text('Users Screen'),
      //     onTap: () {
      //       getUser();
      //     },
      //   ),
      // ),
    );
  }

  void SignOutUser() async {
    showDialog(
        context: context,
        builder: (context) {
          return Center(child: CircularProgressIndicator());
        });
    // Navigator.of(context).pop();
    Future.delayed(Duration(seconds: 2), () async {
      // Navigator.pop(context);
      await FirebaseAuth.instance.signOut();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false);
    });
    // Navigator.pushAndRemoveUntil(
    //     context,
    //     MaterialPageRoute(builder: (context) => LoginScreen()),
    //     (route) => false);
  }

  void getUser() {
    FirebaseFirestore.instance.collection('users').get().then((value) {
      setState(() {
        users = value.docs;
      });
      // var users = value.docs;
      // print(users[0]['age']);
      print(users);
    }).catchError((e) {
      print(e.toString());
    });
  }
}
