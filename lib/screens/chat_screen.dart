import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.userUid, required this.userName});
  final String userUid;
  final String userName;
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List messages = [];
  String uid = FirebaseAuth.instance.currentUser!.uid;
  @override
  void initState() {
    super.initState();
    getChat();
  }

  TextEditingController messageController = TextEditingController();
  bool issendingMessage = false;
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
            bottom: 70,
            left: 0,
            right: 0,
            top: 0,
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (BuildContext context, int index) {
                return Row(
                  children: [
                    if (messages[index]['fromId'] == uid) Spacer(),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: width * 0.8),
                      child: Card(
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${messages[index]['messageBody']}',
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      DateTime.fromMillisecondsSinceEpoch(
                                              messages[index]['timeStamp'])
                                          .toString(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (messages[index]['toId'] == uid) Spacer(),
                  ],
                );
              },
            ),
          ),
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
                      padding: const EdgeInsets.only(
                        left: 10.0,
                      ),
                      child: TextField(
                        controller: messageController,
                        maxLines: 1,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          enabled: true,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(
                      8.0,
                    ),
                    child: issendingMessage
                        ? CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : IconButton(
                            onPressed: () {
                              if (messageController.text.isNotEmpty)
                                sendMessage();
                            },
                            icon: Icon(
                              Icons.send,
                              color: Colors.white,
                              size: 35,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void sendMessage() {
    setState(() {
      issendingMessage = true;
    });

    var message = messageController.text;
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    Map<String, dynamic> data = {
      'messageBody': message,
      'fromId': uid,
      'toId': widget.userUid,
      'timeStamp': timestamp,
      'type': MessageType.text.toString(),
    };
    FirebaseFirestore.instance.collection('messages').add(data).then((value) {
      setState(() {
        messageController.text = '';
        issendingMessage = false;
      });
      getChat();
    }).catchError((e) {
      setState(() {
        issendingMessage = false;
      });
      print('Erro while sending message - $e');
    });
  }

  void getChat() {
    var arrayOfUserId = [uid, widget.userUid];
    FirebaseFirestore.instance
        .collection('messages')
        .orderBy('timeStamp', descending: false)
        .get()
        .then((value) {
      var tempMessages = value.docs;

      messages = [];

      // tempMessages.forEach(
      //   (element) {
      //     if (element['toId'] == widget.userUid && element['fromId'] == uid) {
      //       messages.add(element);
      //     }
      //   },
      // );
      setState(() {
        messages = tempMessages
            .where((e) =>
                (e['toId'] == widget.userUid && e['fromId'] == uid) ||
                (e['fromId'] == widget.userUid && e['toId'] == uid))
            .toList();
      });
    }).catchError((e) {
      print('Erro while geting message list - $e');
    });
  }
}

enum MessageType { text, audio, video, image, location, contact, document }
