// ignore_for_file: unused_field, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'dart:io';

import './user_image_picker.dart';

class AuthForm extends StatefulWidget {
  final void Function(String email, String pass, String username, File image,
      bool isLOG, BuildContext ctx) submitFn;
  final bool isloading;
  AuthForm(this.submitFn, this.isloading);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formkey = GlobalKey<FormState>();

  var _isLogin = true;
  var _username = '';
  var _useremial = '';
  var _userpass = '';
  File _userimageFile = File('');

  void _pickImage(File image) {
    _userimageFile = image;
  }

  void _trySubmit() {
    final isValid = _formkey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (_userimageFile == null && !_isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please pick an image'),
        backgroundColor: Theme.of(context).colorScheme.error,
      ));
      return;
    }

    if (isValid) {
      _formkey.currentState!.save();
    }
    // used this saved data to send auth request
    widget.submitFn(
      //  trim removes white spaces
      _useremial.trim(),
      _userpass.trim(),
      _username.trim(),
      _userimageFile,
      _isLogin,
      context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(30),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
                key: _formkey,
                child: Column(
                  // allow column to take as much space as needed instead of as much space as availible
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    if (!_isLogin)
                      UserImagePicker((pickedFile) {
                        _userimageFile = File(pickedFile.path);
                      }),
                    // for email
                    TextFormField(
                      key: ValueKey('email'),
                      validator: (value) {
                        if (value!.isEmpty || !value.contains('@')) {
                          return 'Please enter a valid email address.';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email address',
                      ),
                      onSaved: (value) {
                        _useremial = value!;
                      },
                    ),
                    // for username
                    if (!_isLogin)
                      TextFormField(
                        key: ValueKey('username'),
                        validator: (value) {
                          if (value!.isEmpty || value.length < 4) {
                            return 'Please enter at least 4 characters';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Username',
                        ),
                        onSaved: (value) {
                          _username = value!;
                        },
                      ),
                    // for passward
                    TextFormField(
                      key: ValueKey('passward'),
                      validator: (value) {
                        if (value!.isEmpty || value.length < 7) {
                          return 'Please enter at least 7 characters long passward';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Passward',
                      ),
                      obscureText: true,
                      onSaved: (value) {
                        _userpass = value!;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    if (widget.isloading) CircularProgressIndicator(),
                    if (!widget.isloading)
                      ElevatedButton(
                        onPressed: _trySubmit,
                        child: Text(_isLogin ? 'Login' : 'SignUP'),
                      ),
                    if (!widget.isloading)
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        },
                        child: Text(_isLogin
                            ? 'Create new account'
                            : 'I already have a account'),
                      ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
