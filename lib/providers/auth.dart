import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;

  final List<String> _userTypes = ['customers', 'providers'];

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

  String get userId {
    return _userId!;
  }

  Map<String, dynamic> get userData {
    return _userData;
  }

  Future<void> updateUserData(
      Map<String, dynamic> userData, int userType) async {
    final url = Uri.parse(
        'https://serving-bd-2-default-rtdb.asia-southeast1.firebasedatabase.app/${_userTypes[userType]}/$_userId.json?auth=$_token');

    if (userType == 1) {
      await http.patch(
        url,
        body: json.encode({
          'name': userData['name'],
          'profilePic': userData['profilePic'],
          'mobile': userData['mobile'],
          'address': userData['address'],
          'email': userData['email'],
          'gender': userData['gender'],
          'dob': userData['dob'],
          'NID': userData['NID'],
          'serviceType': userData['serviceType'],
          'experience': userData['experience'],
          'drivingLicense': userData['drivingLicense'],
          'totalEarning': userData['totalEarning'],
          'isVerified': userData['isVerified'],
          'userId': userData['userId'],
        }),
      );
    } else {
      await http.patch(
        url,
        body: json.encode({
          'name': userData['name'],
          'mobile': userData['mobile'],
          'address': userData['address'],
          'email': userData['email'],
          'gender': userData['gender'],
          'dob': userData['dob'],
          'profilePic': userData['profilePic'],
          'userId': userData['userId'],
        }),
      );
    }
    notifyListeners();
  }

  Future<void> updateEarning(double amount) async {
    var url = Uri.parse(
        'https://serving-bd-2-default-rtdb.asia-southeast1.firebasedatabase.app/${_userTypes[1]}/$_userId.json?auth=$_token');

    await http.patch(
      url,
      body: json.encode(
        {
          'totalEarning': amount,
        },
      ),
    );
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment, int userType) async {
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
    _token = responseData['idToken'];

    _expiryDate = DateTime.now().add(
      Duration(
        seconds: int.parse(responseData['expiresIn']),
      ),
    );
    _userId = responseData['localId'];

    if (urlSegment == 'signUp') {
      url = Uri.parse(
          'https://serving-bd-2-default-rtdb.asia-southeast1.firebasedatabase.app/${_userTypes[userType]}/$_userId.json?auth=$_token');
      if (userType == 1) {
        await http.put(
          url,
          body: json.encode(
            {
              'name': 'Not Set',
              'profilePic':
                  'https://firebasestorage.googleapis.com/v0/b/serving-bd-2.appspot.com/o/user_pics%2FBlank_Profile.png?alt=media&token=c2e09f66-a4df-4a96-9858-94b04463a6ee',
              'mobile': 'Not Set',
              'address': 'Not Set',
              'email': email,
              'gender': 'Not Set',
              'dob': 'Not Set',
              'NID': 'NA',
              'serviceType': 'NA',
              'experience': 0,
              'drivingLicense': 'NA',
              'totalEarning': 0,
              'isVerified': false,
              'userId': _userId,
            },
          ),
        );
      } else {
        await http.put(
          url,
          body: json.encode(
            {
              'name': 'Not Set',
              'profilePic':
                  'https://firebasestorage.googleapis.com/v0/b/serving-bd-2.appspot.com/o/user_pics%2FBlank_Profile.png?alt=media&token=c2e09f66-a4df-4a96-9858-94b04463a6ee',
              'mobile': 'Not Set',
              'address': 'Not Set',
              'email': email,
              'gender': 'Not Set',
              'dob': 'Not Set',
              'userId': _userId,
            },
          ),
        );
      }
    }

    url = Uri.parse(
        'https://serving-bd-2-default-rtdb.asia-southeast1.firebasedatabase.app/${_userTypes[userType]}/$_userId.json?auth=$_token');
    response = await http.get(url);
    _userData = json.decode(response.body);
    _userData ??= {'name': 0};
    print(_userData);

    notifyListeners();
  }

  Future<void> signup(String email, String password, int userType) async {
    return _authenticate(email, password, 'signUp', userType);
  }

  Future<void> login(String email, String password, int userType) async {
    return _authenticate(email, password, 'signInWithPassword', userType);
  }

  void logout() {
    _token = null;
    _expiryDate = null;
    _userId = null;
    notifyListeners();
  }
}
