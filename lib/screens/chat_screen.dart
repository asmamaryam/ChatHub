// ignore_for_file: override_on_non_overriding_member

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../chat/messages.dart';
import '../chat/new_msg.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final fbm = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();

    // Request permission for receiving notifications
    fbm.requestPermission();

    // Handle incoming messages when the app is in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage msg) {
      print("onMessage: $msg");
    });

    // Handle when the app is launched from a terminated state
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage msg) {
      print("onLaunch: $msg");
    });

    // Handle when the app is resumed from the background
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Subscribe the device to the 'chat' topic
    fbm.subscribeToTopic('chat');
  }

  // Define the background message handler
  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage msg) async {
    print("onResume: $msg");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('chatbox'),
        actions: [
          DropdownButton(
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
            items: [
              DropdownMenuItem(
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.exit_to_app),
                      SizedBox(
                        height: 8,
                      ),
                      Text('Logout'),
                    ],
                  ),
                ),
                value: 'Logout',
              ),
            ],
            onChanged: (itemidentifier) {
              if (itemidentifier == 'Logout') {
                FirebaseAuth.instance.signOut();
              }
            },
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Messages(),
            ),
            NewMsg(),
          ],
        ),
      ),
      // StreamBuilder(
      //   stream: FirebaseFirestore.instance
      //       .collection('chats/yK8pTXmE8xYx9JHkwElG/messages')
      //       .snapshots(),
      //   builder: (ctx, streamSnapshot) {
      //     if (streamSnapshot.connectionState == ConnectionState.waiting) {
      //       return Center(
      //         child: CircularProgressIndicator(),
      //       );
      //     }
      //     final doccument = streamSnapshot.data!.docs;
      //     return ListView.builder(
      //       itemCount: doccument.length,
      //       itemBuilder: ((context, index) => Container(
      //             padding: EdgeInsets.all(10),
      //             child: Text(doccument[index]['text']),
      //           )),
      //     );
      //   },
      // ),
    );
  }
}
