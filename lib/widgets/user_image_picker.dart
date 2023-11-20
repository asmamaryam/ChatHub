// ignore_for_file: unnecessary_null_comparison

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(File pickedpic) imagepicFn;
  UserImagePicker(this.imagepicFn);

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  XFile? _pickedImage;

  void _pickImage() async {
    final pickImageFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 40,
      maxWidth: 150,
    );
    if (pickImageFile != null) {
      setState(() {
        _pickedImage = pickImageFile;
      });
      // widget.imagepicFn(pickImageFile as File);
      widget.imagepicFn(File(pickImageFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 45,
          backgroundColor: Colors.grey,
          backgroundImage:
              _pickedImage != null ? FileImage(File(_pickedImage!.path)) : null,
        ),
        TextButton.icon(
          onPressed: _pickImage,
          icon: const Icon(
            Icons.image,
          ),
          label: Text('Add Image'),
        ),
      ],
    );
  }
}
