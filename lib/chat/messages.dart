// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../chat/message_bubble.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var user = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy(
            'created',
            descending: true,
          )
          .snapshots(),
      builder: (ctx, chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final chatDocs =
            chatSnapshot.data?.docs ?? []; // Handle null data or docs
        return ListView.builder(
          reverse: true,
          itemCount: chatDocs.length,
          itemBuilder: (ctx, index) {
            final chatDoc =
                chatDocs[index].data(); // Get data from DocumentSnapshot
            if (chatDoc == null) {
              return SizedBox(); // Skip if data is null
            }

            final String text = chatDoc['text'];
            final String username = chatDoc['username'];
            final String userimage = chatDoc['userimage'];
            final String userId = chatDoc['userId'];

            return MessageBubble(
              text,
              username,
              userimage,
              userId == user!.uid,
              key: ValueKey(chatDocs[index].id),
            );
          },
        );
      },
    );
  }
}
