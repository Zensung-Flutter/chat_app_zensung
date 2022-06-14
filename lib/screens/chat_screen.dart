import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({super.key, required this.userUid, required this.userName});
  final String userUid;

  final String userName;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageController = TextEditingController();
  bool isSendingMessage = false;
  List messageList = [];
  String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMessage();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userName),
      ),
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              width: double.infinity,
              height: 80,
              color: Colors.blue,
              child: Row(
                children: [
                  Container(
                    color: Colors.white,
                    width: width * 0.80,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: TextField(
                        controller: messageController,
                        maxLines: 1,
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            enabled: true,
                            filled: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: isSendingMessage
                        ? CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : IconButton(
                            onPressed: () {
                              if (messageController.text.isNotEmpty) {
                                sendMessage();
                              }
                            },
                            icon: Icon(Icons.send),
                            color: Colors.white,
                            iconSize: 35,
                          ),
                  ),
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
              itemCount: messageList.length,
              itemBuilder: (BuildContext context, int index) {
                return Row(
                  children: [
                    messageList[index]['fromId'] == uid
                        ? Spacer()
                        : Container(),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: width * 0.8),
                      child: Card(
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(messageList[index]['messageBody']),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [Text(data)],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    messageList[index]['toId'] == uid ? Spacer() : Container()
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }

  void sendMessage() {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    int timeStamp = DateTime.now().millisecondsSinceEpoch;
    String message = messageController.text.toString();
    isSendingMessage = true;

    Map<String, dynamic> data = {
      'messageBody': message,
      'toId': widget.userUid,
      'fromId': uid,
      'timestamp': timeStamp,
      'type': MessageType.text.toString(),
    };
    FirebaseFirestore.instance.collection('messages').add(data).then((value) {
      setState(() {
        messageController.text.isEmpty;
        isSendingMessage = false;
        getMessage();
      });
    }).catchError((e) {
      setState(() {
        isSendingMessage = false;
        print(e.toString());
      });
    });
  }

  void getMessage() {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    var arraysOfUserId = [uid, widget.userUid];
    FirebaseFirestore.instance
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .get()
        .then((event) {
      setState(() {
        List firebaseMessagesList = event.docs;
        for (int i = 0; i < firebaseMessagesList.length; i++) {
          if (arraysOfUserId.contains(firebaseMessagesList[i]['toId']) &&
              arraysOfUserId.contains(firebaseMessagesList[i]['fromId'])) {
            messageList.add(firebaseMessagesList[i]);
          }
        }
        isSendingMessage = false;
        messageList = event.docs;
        print(messageList);
      });
    }).catchError((e) {
      print('errors =  $e');
    });
    // .get().then((value) {
    //   if (value != null) {
    //     setState(() {
    //       messageList = value.docs;
    //       print(messageList);
    //     });
    //   }
    // }).catchError((e) {
    //   print('Error Getting Messages $e');
    // });
  }
}

void getUser() {
  String uid = FirebaseAuth.instance.currentUser!.uid;
}

enum MessageType { text, audio, video, image, location, contact, document }
