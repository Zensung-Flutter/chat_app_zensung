import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.userid, required this.username});
  final String userid;
  final String username;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageController = TextEditingController();
  bool issendMessage = false;
  List messsgeList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      GetMessages();
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    String tempuid = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      appBar: AppBar(title: Text(widget.username)),
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 70,
              width: double.infinity,
              color: Colors.blue,
              child: Row(
                children: [
                  Container(
                    width: width * 0.75,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                      ),
                      child: TextField(
                        controller: messageController,
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            enabled: true,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: issendMessage
                        ? CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : IconButton(
                            color: Colors.white,
                            iconSize: 35,
                            icon: Icon(Icons.send),
                            onPressed: () {
                              if (messageController.text.isNotEmpty) {
                                SendMessage();
                              }
                            },
                          ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 68,
            child: ListView.builder(
                itemCount: messsgeList.length,
                itemBuilder: (BuildContext context, int index) {
                  {
                    return Row(
                      children: [
                        messsgeList[index]['fromId'] == tempuid
                            ? Spacer()
                            : Container(),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: width * 0.8,
                          ),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                children: [
                                  Text(messsgeList[index]['messageBody']),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(messsgeList[index]['timestanp']
                                          .toString()),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                }),
          )
        ],
      ),
    );
  }

  void SendMessage() {
    setState(() {
      issendMessage = true;
    });
    String message = messageController.text;
    String uid = FirebaseAuth.instance.currentUser!.uid;
    int timestamp = DateTime.now().millisecondsSinceEpoch;

    Map<String, dynamic> data = {
      'messageBody': message,
      'toId': widget.userid,
      'fromId': uid,
      'timestanp': timestamp,
      'type': MessageType.text.toString(),
    };
    FirebaseFirestore.instance.collection('messages').add(data).then((value) {
      print('call');
      setState(() {
        GetMessages();
        issendMessage = false;
      });
      messageController.text.isEmpty;
    }).catchError((e) {
      print(e.toString());
      setState(() {
        issendMessage = false;
      });
    });
  }

  // void GetMessages() {
  //   String uid = FirebaseAuth.instance.currentUser!.uid;
  //   var arrayOfUserIds = [uid, widget.userid];
  //   FirebaseFirestore.instance
  //       .collection('messages')
  //       .orderBy('timestanp', descending: false)
  //       .where('toId', whereIn: arrayOfUserIds)
  //       .snapshots()
  //       .listen((event) {
  //     setState(() {
  //       messsgeList = event.docs;
  //     });
  //   }).onError((e) {
  //     print(e.toString());
  //   });
  // }

  void GetMessages() {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    var arrayOfUserIds = [uid, widget.userid];
    FirebaseFirestore.instance
        .collection('messages')
        .orderBy('timestanp', descending: false)
//.where('toId', whereNotIn: arrayOfUserIds)
        .get()
        .then((value) {
      setState(() {
        messsgeList.clear();
        List firebaseMessageList = value.docs;
        // for (int i = 0; i < firebaseMessageList.length; i++) {
        //   if ((firebaseMessageList[i]['toId'] == widget.userid &&
        //           firebaseMessageList[i]['fromId'] == uid) ||
        //       (firebaseMessageList[i]['fromId'] == widget.userid &&
        //           firebaseMessageList[i]['toId'] == uid)) {
        //     messsgeList.add(firebaseMessageList[i]);
        //   }
        // }
        //   messsgeList = value.docs;
        messsgeList = firebaseMessageList
            .where((element) =>
                arrayOfUserIds.contains(element['toId']) &&
                arrayOfUserIds.contains(element['fromId']))
            .toList();
      });
    }).catchError(
      (e) {
        print(e.toString());
      },
    );
  }
}

enum MessageType { text, audio, video }
