import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/models/auth_mode.dart';
import 'package:shop_app/utilities/api_url.dart';

class Auth extends ChangeNotifier {
  static const String _USER_DATA_KEY = "USER_DATA";
  String _token;
  DateTime _tokenExpiryDate;
  String _userId;
  Timer _authTimer;

  bool get isAuthenticated => token != null;

  bool get isExpired {
    return _tokenExpiryDate != null && _tokenExpiryDate.isAfter(DateTime.now());
  }

  String get token => isExpired ? _token : null;

  String get userId => isExpired ? _userId : null;

  Future<void> signUp({String email, String password}) async {
    return _authenticate(email, password, AuthMode.Signup);
  }

  Future<void> signIn({String email, String password}) async {
    return _authenticate(email, password, AuthMode.Login);
  }

  Future<bool> tryAutoLogin() async {
    final userData = await _getUserCache();
    if (userData == null) {
      return false;
    }

    final expiryDate = DateTime.parse(userData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    _token = userData['token'];
    _userId = userData['userId'];
    _tokenExpiryDate = expiryDate;

    notifyListeners();
    _autoLogout();

    return true;
  }

  Future<void> logout() async {
    _userId = null;
    _token = null;
    _tokenExpiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    _removeUserCache();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _tokenExpiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }

  Future<void> _authenticate(
    String email,
    String password,
    AuthMode mode,
  ) async {
    final requestBody = json.encode({
      'email': email,
      'password': password,
      'returnSecureToken': true,
    });
    final response = await post(
      ApiUrl.getIdentityUrl(mode),
      body: requestBody,
    );
    final responseBody = json.decode(response.body);

    if (responseBody['error'] != null) {
      throw HttpException(
          _translateErrorMessage(responseBody['error']['message']));
    }

    _token = responseBody['idToken'];
    _userId = responseBody['localId'];
    _tokenExpiryDate = DateTime.now().add(
      Duration(
        seconds: int.parse(responseBody['expiresIn']),
      ),
    );

    if (mode == AuthMode.Login) {
      _saveUserCache();
      _autoLogout();
    }

    notifyListeners();
  }

  String _translateErrorMessage(String errMessage) {
    switch (errMessage) {
      case 'EMAIL_EXISTS':
        return 'Email already used';

      case 'TOO_MANY_ATTEMPTS_TRY_LATER':
        return 'too many attempts please try again later';

      case 'EMAIL_NOT_FOUND':
        return 'Email not found';

      case 'INVALID_PASSWORD':
        return 'invalid password';

      case 'USER_DISABLED':
        return 'user disabled';
    }

    return 'Could not authenticate please try again later';
  }

  Future<void> _saveUserCache() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = json.encode({
      'token': _token,
      'userId': _userId,
      'expiryDate': _tokenExpiryDate.toIso8601String(),
    });
    prefs.setString(_USER_DATA_KEY, userData);
  }

  Future<Map<String, Object>> _getUserCache() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final userDataJson = prefs.getString(_USER_DATA_KEY);
      final Map<String, Object> userData = json.decode(userDataJson);
      return userData;
    } catch (error) {
      return null;
    }
  }

  Future<void> _removeUserCache() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_USER_DATA_KEY);
  }
}
