import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:serving_bd/providers/auth.dart';
import 'package:serving_bd/screens/service_provider/service_provider_screen.dart';

class ProviderProfileScreen extends StatefulWidget {
  const ProviderProfileScreen({Key? key}) : super(key: key);

  @override
  _ProviderProfileScreenState createState() => _ProviderProfileScreenState();
}

class _ProviderProfileScreenState extends State<ProviderProfileScreen> {
  File? _pickedImage;

  void _pickImage() async {
    showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text("Choose image source"),
        actions: [
          TextButton(
            child: const Text("Camera"),
            onPressed: () => Navigator.pop(context, ImageSource.camera),
          ),
          TextButton(
            child: const Text("Gallery"),
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
          ),
        ],
      ),
    ).then((source) async {
      if (source != null) {
        final picker = ImagePicker();
        final pickedImage = await picker.pickImage(
          source: source,
          imageQuality: 70,
          maxWidth: 150,
        );
        final pickedImageFile = File(pickedImage!.path);
        setState(() {
          _pickedImage = pickedImageFile;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formkey = GlobalKey();

    var userData = context.read<Auth>().userData;
    var userId = context.read<Auth>().userId;

    Widget textFormField({
      required String userDataKey,
      required TextInputType inputType,
      required String title,
      bool readOnly = false,
    }) {
      return TextFormField(
        decoration: InputDecoration(
          labelText: title,
          border: InputBorder.none,
          fillColor: const Color(0xFFC61F62),
          isDense: true,
          contentPadding: const EdgeInsets.all(15),
        ),
        keyboardType: inputType,
        readOnly: readOnly,
        initialValue: userData[userDataKey].toString(),
        validator: (val) {
          if (val == null || val.isEmpty) {
            return 'This field cannot be empty';
          }
          return null;
        },
        onSaved: (val) {
          userData[userDataKey] = val;
        },
      );
    }

    Future<void> _submit() async {
      try {
        if (!_formkey.currentState!.validate()) {
          return;
        }

        _formkey.currentState!.save();
        if (_pickedImage != null) {
          final ref = FirebaseStorage.instance
              .ref()
              .child('user_pics')
              .child(userId + '.jpg');

          await ref.putFile(_pickedImage!);
          final imageUrl = await ref.getDownloadURL();
          userData['profilePic'] = imageUrl;
        }
        await context.read<Auth>().updateUserData(userData, 1);

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => ServiceProviderScreen(),
          ),
        );
      } catch (_) {
        return print(_);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: [
          TextButton(
            onPressed: _submit,
            child: const Text(
              "Save",
              style: TextStyle(
                color: Color(0xFFC61F62),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey,
                  backgroundImage: _pickedImage != null
                      ? FileImage(_pickedImage!)
                      : NetworkImage(userData['profilePic']) as ImageProvider,
                ),
              ),
              TextButton.icon(
                icon: const Icon(
                  Icons.image,
                  color: Color(0xFFC61F62),
                ),
                label: const Text(
                  'Change Image',
                  style: TextStyle(color: Color(0xFFC61F62)),
                ),
                onPressed: _pickImage,
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      textFormField(
                        inputType: TextInputType.name,
                        userDataKey: 'name',
                        title: 'Name',
                      ),
                      textFormField(
                        inputType: TextInputType.number,
                        userDataKey: 'mobile',
                        title: 'Phone Number',
                      ),
                      textFormField(
                        inputType: TextInputType.name,
                        userDataKey: 'email',
                        title: 'E-mail',
                        readOnly: true,
                      ),
                      textFormField(
                        inputType: TextInputType.name,
                        userDataKey: 'address',
                        title: 'Address',
                      ),
                      textFormField(
                        inputType: TextInputType.name,
                        userDataKey: 'gender',
                        title: 'Gender',
                      ),
                      textFormField(
                        inputType: TextInputType.name,
                        userDataKey: 'dob',
                        title: 'Date of Birth',
                      ),
                      textFormField(
                        inputType: TextInputType.name,
                        userDataKey: 'NID',
                        title: 'NID Number',
                      ),
                      textFormField(
                        inputType: TextInputType.name,
                        userDataKey: 'drivingLicense',
                        title: 'Driving License (if required)',
                      ),
                      textFormField(
                        inputType: TextInputType.name,
                        userDataKey: 'experience',
                        title: 'Work Experience',
                      ),
                      textFormField(
                        inputType: TextInputType.name,
                        userDataKey: 'serviceType',
                        title: 'Service Type You Provide',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
