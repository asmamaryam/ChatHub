// ignore_for_file: unused_local_variable, unused_catch_clause, unused_field, unnecessary_null_comparison
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

import '../widgets/auth_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var _isloading = false;
  final _auth = FirebaseAuth.instance;

  void _submitAuthForm(
    String emails,
    String pass,
    String username,
    File image,
    bool islog,
    BuildContext ctx,
  ) async {
    UserCredential authResult;
    try {
      setState(() {
        _isloading = true;
      });
      if (islog) {
        authResult = await _auth.signInWithEmailAndPassword(
          email: emails,
          password: pass,
        );
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
          email: emails,
          password: pass,
        );

        Reference ref = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('${authResult.user?.uid}.jpg');

        try {
          if (image != null) {
            List<int> imageBytes = await image.readAsBytes();
            Uint8List uint8ImageBytes = Uint8List.fromList(imageBytes);

            UploadTask uploadTask = ref.putData(uint8ImageBytes);
            TaskSnapshot snap = await uploadTask;
            print('Image uploaded successfully');

            String url = await ref
                .getDownloadURL(); // Get the download URL of the uploaded image.

            await FirebaseFirestore.instance
                .collection('users')
                .doc(authResult.user?.uid)
                .set({
              'username': username,
              'email': emails,
              'image_url':
                  url, // Assign the URL to the 'image_url' field in Firestore
            });
          } else {
            // Handle the case when the 'image' parameter is null or empty.
            print('No image found. Please provide an image.');
            // You can show a SnackBar or other error handling here as well.
          }
        } catch (e) {
          // Handle the upload error and show an error message to the user.
          ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
            content: Text('Error uploading image. Please try again.'),
            backgroundColor: Theme.of(ctx).colorScheme.error,
          ));
          // If the image upload fails, you may want to return or stop the registration process.
          setState(() {
            _isloading = false;
          });
          return;
        }
      }
    } catch (erro) {
      print(erro);
      setState(() {
        _isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(
        _submitAuthForm,
        _isloading,
      ),
    );
  }
}
