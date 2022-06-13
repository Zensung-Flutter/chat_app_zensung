import 'package:chat_app/screens/signup_screen.dart';
import 'package:chat_app/screens/users_screen.dart';
import 'package:chat_app/widgets/custom_text_field_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String emailId = '';
  String password = '';
  bool isPasswordObscure = true;
  TextEditingController emailIdTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  bool isloading = false;

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
                  'Login',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
                Image.asset(
                  'images/codeaamy_logo.png',
                  height: 110,
                  width: 110,
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
                    isObscure: isPasswordObscure,
                    textEditingController: passwordTextController,
                    iconButton:  IconButton(
                      icon: Icon(isPasswordObscure? Icons.visibility : Icons.visibility_off,),
                      onPressed: (){
                        setState(() {
                          isPasswordObscure =! isPasswordObscure;
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
                      
                       if (!isloading) {
                          loginUser();
                            setState(() => isloading= true);
                       }
                        
                    },
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      // ignore: sort_child_properties_last
                      child: Center(
                        child: isloading ? CircularProgressIndicator(color: Colors.white,)
                        :Text('Login'),
                        
                        


                      //     child: Text(
                      //   'Login',
                      //   style: TextStyle(
                      //       fontSize: 20,
                      //       fontWeight: FontWeight.bold,
                      //       color: Colors.white),
                      // )
                      ),
                      decoration: BoxDecoration(
                        color: Colors.purple,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      
                    ),
                  ),
                ),
                InkWell(
                  child: Text(
                    'Dont have account ? Sign Up',
                    style: TextStyle(
                      color: Colors.blue[900],
                    ),
                  ),
                  onTap: ()=> Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => SignupScreen())),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void loginUser() {
    emailId = emailIdTextController.text;
    password = passwordTextController.text;

    if (emailId.isNotEmpty && password.isNotEmpty) {
      emailIdTextController.clear();
      passwordTextController.clear();

      FirebaseAuth.instance.signInWithEmailAndPassword(email: emailId, password: password).
      then((value){
        var user = value.user;
        if(user!= null){
          print(user.uid);
          Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => UsersScreen()), (route) => false);
        }
      }).catchError((e){
        print(e.toString());
      });
    } 
    else {
      print('Invalid Credentials');
    }
  }
}
