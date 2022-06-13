import 'package:chat_app/screens/signup_screen.dart';
import 'package:chat_app/screens/users_screen.dart';
import 'package:chat_app/widgets/custom_text_field_widget.dart';
import 'package:chat_app/widgets/overlay_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String emailId = '';
  String password = '';
  bool isPasswordObsure = true;
  TextEditingController emailIdTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _load = false;
  bool _isCallOnce = false;
  OverlayEntry? entry;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
                  'Login',
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
                    isObscure: isPasswordObsure,
                    textEditingController: passwordTextController,
                    iconButton: IconButton(
                      icon: Icon(isPasswordObsure
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          isPasswordObsure = !isPasswordObsure;
                        });
                      },
                    ),
                  ),
                ),
                Text(
                  'Forgot Password ?',
                  style: TextStyle(
                    color: Colors.blue[900],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: InkWell(
                    onTap: () {
                      if (!_isCallOnce) {
                        loginUser();
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      child: Center(
                          child: Text(
                        'Login',
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
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => SignupScreen()),
                        (route) => false);
                  },
                  child: Text(
                    'Dont have account ? Sign Up',
                    style: TextStyle(
                      color: Colors.blue[900],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // void ShowOverLay() {
  //   entry = OverlayEntry(
  //     builder: (context) => Positioned(
  //       left: 20,
  //       top: 30,
  //       child: _load
  //           ? Container(
  //               color: Colors.white,
  //               width: 70.0,
  //               height: 70.0,
  //               child: Padding(
  //                 padding: const EdgeInsets.all(10.0),
  //                 child: Center(child: CircularProgressIndicator()),
  //               ))
  //           : Container(),
  //     ),
  //   );
  //   final overlay = Overlay.of(context);
  //   overlay?.insert(entry!);
  // }

  // void RemoveOverLay() {
  //   entry?.remove();
  // }

  void InsertOverLay() {
    double middleX = MediaQuery.of(context).size.width / 2;
    double middleY = MediaQuery.of(context).size.height / 2;
    entry = OverlayEntry(
      builder: (context) => OverlLayWidget(middleX: middleX, middleY: middleY),
    );
    final overlay = Overlay.of(context);
    overlay?.insert(entry!);
  }

  void RemoveOverLay() {
    entry?.remove();
  }

  void loginUser() async {
    print('login call');
    setState(() => _isCallOnce = true);
    InsertOverLay();

    emailId = emailIdTextController.text;
    password = passwordTextController.text;

    if (emailId.isNotEmpty && password.isNotEmpty) {
      await Future.delayed(Duration(milliseconds: 1000), () {
        FirebaseAuth.instance
            .signInWithEmailAndPassword(email: emailId, password: password)
            .then((value) {
          var user = value.user;
          if (user != null) {
            RemoveOverLay();
            print(user.uid);
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => UsersScreen()),
                (route) => false);
          }
        }).catchError((e) {
          RemoveOverLay();
          setState(() => _isCallOnce = false);
          print(e.toString());
        });
      });
    } else {
      setState(() => _isCallOnce = false);
      print('Invalid Credentials');
    }
  }
}
