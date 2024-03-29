import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serving_bd/providers/auth.dart';
import 'package:serving_bd/screens/selection_screen.dart';
import 'package:serving_bd/screens/service_provider/service_provider_screen.dart';

import '../main.dart';

class AuthScreen extends StatefulWidget {
  final int userType;
  const AuthScreen({Key? key, required this.userType}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

enum AuthMode { Signup, Login }

class _AuthScreenState extends State<AuthScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  var _isLoading = false;
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  final _passwordConroller = TextEditingController();

  Future<void> _submit() async {
    if (!_formkey.currentState!.validate()) {
      return;
    }
    _formkey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    if (_authMode == AuthMode.Login) {
      await context
          .read<Auth>()
          .login(_authData['email']!, _authData['password']!, widget.userType);
    } else {
      await context
          .read<Auth>()
          .signup(_authData['email']!, _authData['password']!, widget.userType);
    }

    final userData = context.read<Auth>().userData;

    if (userData['name'] == 0) {
      List<String> alertText = [
        'This Email is already in use as - Service Provider.Please switch mode and try again.',
        'This Email is already in use as - Customer.Please switch mode and try again.'
      ];
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text(
            alertText[widget.userType],
            style: TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              child: const Text("Close"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
      return;
    }
    
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) =>
            widget.userType == 1 ? const ServiceProviderScreen() : MainPage(),
      ),
    );
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 80,
                ),
                const Text(
                  'WELCOME',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _authMode == AuthMode.Login
                      ? 'Sign In To Continue!'
                      : 'Create An Account To Continue!',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Form(
                  key: _formkey,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'E-Mail',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            isDense: true,
                            fillColor: const Color(0xFFF5F6FB),
                            filled: true,
                            contentPadding: const EdgeInsets.all(15),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isEmpty || !value.contains('@')) {
                              return 'Invalid E-Mail';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _authData['email'] = value!;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Password',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            isDense: true,
                            fillColor: const Color(0xFFF5F6FB),
                            filled: true,
                            contentPadding: const EdgeInsets.all(15),
                          ),
                          obscureText: true,
                          controller: _passwordConroller,
                          validator: (value) {
                            if (value!.isEmpty || value.length < 5) {
                              return 'Password is too short!';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _authData['password'] = value!;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        if (_authMode == AuthMode.Signup)
                          TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Confirm Password',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              isDense: true,
                              fillColor: const Color(0xFFF5F6FB),
                              filled: true,
                              contentPadding: const EdgeInsets.all(15),
                            ),
                            obscureText: true,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value != _passwordConroller.text) {
                                return 'Passwords do not match!';
                              }
                              return null;
                            },
                          ),
                        const SizedBox(
                          height: 10,
                        ),
                        if (_isLoading)
                          const Center(
                            child: CircularProgressIndicator(),
                          )
                        else
                          GestureDetector(
                            onTap: _submit,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color(0xFFC61F62),
                              ),
                              height: 40,
                              child: Center(
                                child: Text(
                                  _authMode == AuthMode.Login
                                      ? 'LOGIN'
                                      : 'SIGN UP',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(
                          height: 30,
                        ),
                        GestureDetector(
                          onTap: _switchAuthMode,
                          child: Center(
                            child: Text(
                              _authMode == AuthMode.Login
                                  ? 'Create Account'
                                  : 'LOGIN',
                              style: const TextStyle(
                                color: Color(0xFFC61F62),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (_) {
                              return const SelectionScreen();
                            }));
                          },
                          child: const Center(
                            child: Text(
                              'Change Selection',
                              style: TextStyle(
                                color: Color(0xFFC61F62),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
