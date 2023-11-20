// ignore_for_file: unused_field, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewMsg extends StatefulWidget {
  const NewMsg({super.key});

  @override
  State<NewMsg> createState() => _NewMsgState();
}

class _NewMsgState extends State<NewMsg> {
  final _controller = TextEditingController();
  var _enterdMesage = '';

  // void _sendMessage() async {
  //   try {
  //     FocusScope.of(context).unfocus();
  //     //  this gives us future
  //     final user = await FirebaseAuth.instance.currentUser;
  //     if (user == null) {
  //       print("User not authenticated.");
  //       return;
  //     }
  //     // final userId = user.uid; // Add this line for debugging
  //     // print("User ID: $userId"); // Add this line for debugging

  //     final userData = await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(user.uid)
  //         .get();
  //     print("User data exists: ${userData.exists}");
  //     if (!userData.exists) {
  //       print("User data not found.");
  //       return;
  //     }

  //     if (_enterdMesage.isEmpty) {
  //       print("Message is empty.");
  //       return;
  //     }

  //     FirebaseFirestore.instance.collection('chat').add({
  //       'text': _enterdMesage,
  //       'created': Timestamp.now(),
  //       'userId': user.uid,
  //       'username': userData['username'],
  //       'userimage': userData['image_url'],
  //     });

  //     _controller.clear();
  //   } catch (e) {
  //     print("Error sending message: $e");
  //   }
  // }

  void _sendMessage() async {
    try {
      FocusScope.of(context).unfocus();
      final user = await FirebaseAuth.instance.currentUser;
      if (user == null) {
        print("User not authenticated.");
        return;
      }

      final userDataSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      print("User data exists: ${userDataSnapshot.exists}");
      if (!userDataSnapshot.exists) {
        print("User data not found.");
        return;
      }

      final userData = userDataSnapshot.data();
      if (userData == null) {
        print("User data is null.");
        return;
      }

      final String username = userData['username'];
      final String userimage = userData['image_url'];

      if (username == null || userimage == null) {
        print("Username or user image is null.");
        return;
      }

      if (_enterdMesage.isEmpty) {
        print("Message is empty.");
        return;
      }

      FirebaseFirestore.instance.collection('chat').add({
        'text': _enterdMesage,
        'created': Timestamp.now(),
        'userId': user.uid,
        'username': username,
        'userimage': userimage,
      });

      _controller.clear();
    } catch (e) {
      print("Error sending message: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Expanded(
              child: TextField(
            controller: _controller,
            textCapitalization: TextCapitalization.sentences,
            autocorrect: true,
            decoration: InputDecoration(labelText: 'Send a meassage....'),
            onChanged: (value) {
              setState(() {
                _enterdMesage = value;
              });
            },
          )),
          IconButton(
            onPressed: _enterdMesage.trim().isEmpty ? null : _sendMessage,
            icon: Icon(Icons.send),
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}
