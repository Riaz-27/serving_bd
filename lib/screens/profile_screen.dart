import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serving_bd/providers/auth.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formkey = GlobalKey();

    var _isLoading = false;

    var userData = context.read<Auth>().userData;

    Widget textFormField({
      required String userDataKey,
      required TextInputType inputType,
      required title,
    }) {
      return TextFormField(
        decoration: InputDecoration(
          label: Text(title),
          border: InputBorder.none,
          fillColor: const Color(0xFFC61F62),
          isDense: true,
          contentPadding: const EdgeInsets.all(15),
        ),
        keyboardType: inputType,
        initialValue: userData[userDataKey],
        validator: (v) {
          if (v == null || v.isEmpty) {
            return 'This field cannot be empty';
          }
          return null;
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  textFormField(
                      inputType: TextInputType.name,
                      userDataKey: 'name',
                      title: 'Name'),
                  textFormField(
                      inputType: TextInputType.number,
                      userDataKey: 'mobile',
                      title: 'Phone Number'),
                  textFormField(
                      inputType: TextInputType.name,
                      userDataKey: 'email',
                      title: 'E-mail'),
                  textFormField(
                      inputType: TextInputType.name,
                      userDataKey: 'gender',
                      title: 'Gender'),
                  textFormField(
                      inputType: TextInputType.name,
                      userDataKey: 'dob',
                      title: 'Date of Birth'),
                  textFormField(
                      inputType: TextInputType.name,
                      userDataKey: 'address',
                      title: 'Address'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
