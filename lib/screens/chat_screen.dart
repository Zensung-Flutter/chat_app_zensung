import 'package:chat_app/utlis/utilities.dart';
import 'package:chat_app/widgets/chat_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.userUid, required this.userName});

  final String userUid;
  final String userName;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageController = TextEditingController();

  bool isSendingMessage = false;
  List messagesList = [];
  List firebaseMessageList = [];

  String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
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
              height: 70,
              color: Colors.blue,
              child: Row(
                children: [
                  Container(
                    width: width * 0.80,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
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
                              if (messageController.text != "") {
                                sendMessage();
                              }
                            },
                            icon: Icon(Icons.send,
                                color: Colors.white, size: 35)),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 72,
            child: ListView.builder(
              itemCount: messagesList.length,
              itemBuilder: (BuildContext context, int index) {
                return messagesList[index]['fromId'] == uid
                    ? SenderChatBubbleWidget(
                        width: width,
                        message: messagesList[index]['messageBody'],
                        dateTime: messagesList[index]['timestamp'])
                    : RecieverChatBubbleWidget(
                        width: width,
                        message: messagesList[index]['messageBody'],
                        dateTime: messagesList[index]['timestamp']);
              },
            ),
          )
        ],
      ),
    );
  }

  void sendMessage() {
    setState(() {
      isSendingMessage = true;
    });
    String uid = FirebaseAuth.instance.currentUser!.uid;
    int timeStamp = DateTime.now().millisecondsSinceEpoch;
    String message = messageController.text;
    Map<String, dynamic> data = {
      'messageBody': message,
      'toId': widget.userUid,
      'fromId': uid,
      'timestamp': timeStamp,
      'type': MessageType.text.toString(),
    };

    FirebaseFirestore.instance.collection('messages').add(data).then((value) {
      setState(() {
        messageController.text = '';
        getMessage();
      });
    }).catchError((e) {
      setState(() {
        isSendingMessage = false;
      });
      print(e.toString());
    });
  }

  void getMessage() {
    messagesList = [];

    String uid = FirebaseAuth.instance.currentUser!.uid;

    var arraysOfUserID = [uid, widget.userUid];

    print('getting messages');
    FirebaseFirestore.instance
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .get()
        .then((event) {
      setState(() {
        firebaseMessageList = event.docs;
        // for (var i = 0; i < firbaseMessageList.length; i++) {
        //   if (arraysOfUserID.contains(firbaseMessageList[i]['toId']) &&
        //       arraysOfUserID.contains(firbaseMessageList[i]['fromId'])) {
        //     messagesList.add(firbaseMessageList[i]);
        //   }
        // }

        messagesList = firebaseMessageList
            .where((element) => (arraysOfUserID.contains(element['toId']) &&
                arraysOfUserID.contains(element['fromId'])))
            .toList();
        isSendingMessage = false;
      });
    }).catchError((e) {
      print('Error Getting messages $e');
    });
  }
}

enum MessageType { text, audio, video, image, location, contact, document }
