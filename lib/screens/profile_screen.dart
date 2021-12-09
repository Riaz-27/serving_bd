import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serving_bd/main.dart';
import 'package:serving_bd/providers/auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formkey = GlobalKey();

    var _isLoading = false;

    var userData = context.read<Auth>().userData;

    Widget textFormField({
      required String userDataKey,
      required TextInputType inputType,
      required String title,
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
      if (!_formkey.currentState!.validate()) {
        return;
      }
      _formkey.currentState!.save();
      setState(() {
        _isLoading = true;
      });

      await context.read<Auth>().updateUserData(userData);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => MainPage(),
        ),
      );
      setState(() {
        _isLoading = false;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: [
          TextButton(
            onPressed: _submit,
            child: _isLoading
                ? const CircularProgressIndicator()
                : const Text("Save"),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Padding(
            padding: const EdgeInsets.all(10),
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
