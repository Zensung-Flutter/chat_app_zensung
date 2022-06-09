import 'package:chat_app/screens/users_screen.dart';
import 'package:chat_app/widgets/custom_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

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
                  'Sign Up',
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
                      loginUser(context);
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
                InkWell(
                  child: Text(
                    'Already have an account ? login',
                    style: TextStyle(
                      color: Colors.blue[900],
                    ),
                  ),
                  onTap: (){
                    Navigator.pop(context);
                  }
                ),
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

    if (emailId == 'login' && password == '12') {
      emailIdTextController.clear();
      passwordTextController.clear();
      
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => UsersScreen()), (route) => false);
    } else {
      print('Invalid Credentials');
    }
  }
}
