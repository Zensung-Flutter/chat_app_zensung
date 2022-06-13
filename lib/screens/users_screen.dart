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
  void initState()//initiallisation state, initstate is same as oncreate fxn in android 
  {
    super.initState();
    getUser();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: (){
              signOutUser();
            },  icon: Icon(Icons.logout,),),
        ],
      ),
      body: ListView.builder(

        itemCount: users.length,
        itemBuilder: (BuildContext context, int index,){
          return InkWell(
            onTap: () {
              Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => ChatScreen(useruid: users[index]['uid'] , userName: users[index]['firstname'] ,),),);
            },
            child: Card(
              child: Center(
                child: Column(
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              '${users[index]['firstname']}${users[index]['lastname']}', 
                            ),
                             SizedBox(width: 100,),
                              Container(height: 10, width: 10, 
                                decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color:users[index]['isOnline'] ? Colors.green : Colors.red,),),
                          ],
                        ),
                            SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${users[index]['age']}'
                                ),
                                Text('${users[index]['timestamp']}'
                                ),
                              ],
                            )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }


  void signOutUser(){
    FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(context, 
    MaterialPageRoute(builder: (_) => LoginScreen()), (route) => false);
  }


  void getUser(){
    FirebaseFirestore.instance.collection('users').get().then((value) {
      setState(() {
        users = value.docs;//docs returns list which array
      });
       
      print(users);
    }).catchError((e){
      print(e.toString());
    });
  }
}


/*
initstate()
dispose()
*/