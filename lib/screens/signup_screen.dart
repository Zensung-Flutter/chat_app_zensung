import 'package:chat_app/screens/users_screen.dart';
import 'package:chat_app/widgets/custom_text_field_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 50,
                ),
                const Text(
                  'Sigin Up',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
                Image.asset(
                  'images/codeaamy_logo.png',
                  height: 200,
                  width: 200,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: CustomTextFieldWidget(
                    labelText: 'Email',
                    icon: Icons.email,
                    textEditingController: emailIdTextController,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: CustomTextFieldWidget(
                    labelText: 'password',
                    icon: Icons.lock,
                    isObscure: true,
                    textEditingController: passwordTextController,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: InkWell(
                    onTap: () {
                      SignupUser(context);
                    },
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      child: Center(
                          child: Text(
                        'Sign Up',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      )),
                      decoration: BoxDecoration(
                        color: Colors.purple,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                Text(
                  'Have accout? Sign In',
                  style: TextStyle(
                    color: Colors.blue[900],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void SignupUser(BuildContext context) {
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
          addUseDataToDatabase(user.uid);
        }
      }).catchError(
        (e) {
          print(e.toString());
        },
      );
    } else {
      print('Invalid Credentials');
    }
  }

  void addUseDataToDatabase(String uid) {
    String timestamp = DateTime.now().microsecondsSinceEpoch.toString();
    Map<String, dynamic> data = {
      'name': 'santosh${timestamp}',
      'uid': uid,
      'timestamp': timestamp,
      'age': "39",
      'isOnline': true
    };
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set(data)
        .then((value) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => UsersScreen()), (route) => false);
    });
  }
}
