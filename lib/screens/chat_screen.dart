import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.userUid, required this.userName});

  final String userUid;

  final String userName;
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messagecontroller = new TextEditingController();
  bool isSendingMessage = false;
  List messageList = [];
  List firebasemessageList = [];
  @override
  void initState() {
    setState(() {
      getMessage();
    });
  }

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
              height: 100,
              color: Colors.blue,
              child: Row(children: [
                Container(
                  color: Colors.blue,
                  width: width * 0.75,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: TextField(
                      controller: messagecontroller,
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          enabled: true,
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      print('Send Button Press');
                      // if (messagecontroller.text != '') {
                      sendMessage();
                      print('object');
                      // }
                    },
                    icon: Icon(
                      Icons.send,
                      size: 35,
                      color: Colors.white,
                    ))
              ]),
            ),
          ),
          Positioned(
            bottom: 72,
            top: 0,
            left: 0,
            right: 0,
            child: ListView.builder(
              itemCount: messageList.length,
              itemBuilder: (BuildContext context, int index) {
                return Row(
                  children: [
                    Spacer(),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: width * 0.8),
                      child: Card(
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(messageList[index]['message']),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                        '${DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(messageList[index]['timestamp'])).inMinutes.toString()}m ago'),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    messageList[index]['recievedId'] == widget.userUid
                        ? Spacer()
                        : Container(),
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
    setState(() {
      isSendingMessage = true;
    });
    String uid = FirebaseAuth.instance.currentUser!.uid;
    String message = messagecontroller.text;
    Map<String, dynamic> data = {
      'message': message,
      'recievedId': widget.userUid,
      'senderId': uid,
      'timestamp': Timestamp.now().millisecondsSinceEpoch,
      'type': MessageType.text.toString(),
    };
    FirebaseFirestore.instance.collection('message').add(data).then((value) {
      setState(() {
        messagecontroller.text = '';
        isSendingMessage = false;
      });
      // messagecontroller.text.isEmpty;
    }).catchError((e) {
      setState(() {
        isSendingMessage = false;
      });
      print(e.toString());
    });
  }

  void getMessage() {
    print('getting message');
    String uid = FirebaseAuth.instance.currentUser!.uid;
    var arrayOfUserID = [uid, widget.userUid];
    FirebaseFirestore.instance
        .collection('message')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .listen((event) {
      setState(() {
        firebasemessageList = event.docs;
        messageList = firebasemessageList
            .where((element) =>
                (arrayOfUserID.contains(element['recievedId']) &&
                    arrayOfUserID.contains(element['senderId'])))
            .toList();
      });
    }).onError((e) {
      print('Errow Getting');
    });
    // .get()
    // .then((value) {
    //   if (value != null) {
    //     setState(() {
    //       messageList = value.docs;
    //       print(messageList);
    //     });
    //   }
    // })
    // .catchError((e) {
    //   print('Error Occured');
    // });
  }
}

enum MessageType { text, audio, video, image, location, contact, document }
