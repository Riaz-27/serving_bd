import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;

  var _userData;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Map<String,dynamic> get userData {
      return _userData;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    var url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyC8ZZzvvRRVjhh_B23vF1O5cJw10Ntf7os');
    var response = await http.post(
      url,
      body: json.encode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );
    final responseData = json.decode(response.body);
    print(responseData);
    _token = responseData['idToken'];
    
    _expiryDate = DateTime.now().add(
      Duration(
        seconds: int.parse(responseData['expiresIn']),
      ),
    );
    _userId = responseData['localId'];

    if (urlSegment == 'signUp') {
      url = Uri.parse(
          'https://serving-bd-2-default-rtdb.asia-southeast1.firebasedatabase.app/users/$_userId.json?auth=$_token');
      await http.put(
        url,
        body: json.encode({
          'name': 'Not Set',
          'profilePic':
              'https://firebasestorage.googleapis.com/v0/b/serving-bd-2.appspot.com/o/user_pics%2FBlank_Profile.png?alt=media&token=b911bc81-f3fd-4ea5-b128-6ba75302e79b',
          'accountType': 'customer',
          'mobile': 'Not Set',
          'address': 'Not Set',
          'email': email,
          'gender': 'Not Set',
          'dob': 'Not Set',
        }),
      );
    }

    url = Uri.parse('https://serving-bd-2-default-rtdb.asia-southeast1.firebasedatabase.app/users/$_userId.json?auth=$_token');
    response = await http.get(url);
    _userData = json.decode(response.body);

    notifyListeners();
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  void logout() {
    _token = null;
    _expiryDate = null;
    _userId = null;
    notifyListeners();
  }
}
