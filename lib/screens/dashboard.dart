import 'package:chat_app/screens/users_screen.dart';
import 'package:chat_app/widgets/custom_text_field_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class SignupScreen extends StatefulWidget {
  SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  String emailId = '';

  String password = '';

  TextEditingController emailIdTextController = TextEditingController();

  TextEditingController passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Text(
                  "Dahsboard Of June 2023",
                ),
                Text("Aniket Kharat"),
                Row(
                  children: [
                    Column(
                      children: [
                        Container(
                            height: 140,
                            width: 140,
                            child: Container(
                              margin: EdgeInsets.all(5),
                              height: 120,
                              width: 120,
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(80)),
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(90),
                                color: Colors.red))
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void loginUser(BuildContext context) {
    emailId = emailIdTextController.text;
    password = passwordTextController.text;

    if (emailId.isNotEmpty && password.isNotEmpty) {
      emailIdTextController.clear();
      passwordTextController.clear();

      FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: emailId, password: password)
          .then((value) {
        var user = value.user;
        if (user != null) {
          print(user.uid);
          addUserDataToDatabase(user.uid);
        }
      }).catchError((e) {
        print(e.toString());
      });
      // Navigator.of(context).pushAndRemoveUntil(
      //     MaterialPageRoute(builder: (_) => UsersScreen()), (route) => false);
    } else {
      print('Invalid Credentials');
    }
  }

  void addUserDataToDatabase(String uid) {
    Map<String, dynamic> data = {
      'name': 'Aniket${DateTime.now().millisecondsSinceEpoch.toString()}',
      'uid': uid,
      // 'timestamp':DateTime.now().millisecondsSinceEpoch.toString(),
      'age': 21,
      'isOnline': true
    };

    FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .set(data)
        .then((value) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => UsersScreen()), (route) => false);
    });
  }
}
