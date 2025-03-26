import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class StorageService {
  static const String _userKey = 'user_data';
  static const String _tokenKey = 'auth_token';

  final SharedPreferences _prefs;

  StorageService(this._prefs);

  static Future<StorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return StorageService(prefs);
  }

  // Save user data
  Future<void> saveUserData(UserModel user) async {
    await _prefs.setString(_userKey, jsonEncode(user.toJson()));
    if (user.token != null) {
      await _prefs.setString(_tokenKey, user.token!);
    }
  }

  // Get saved user data
  UserModel? getUserData() {
    final userStr = _prefs.getString(_userKey);
    if (userStr != null) {
      try {
        return UserModel.fromJson(jsonDecode(userStr));
      } catch (e) {
        print('Error parsing user data: $e');
        return null;
      }
    }
    return null;
  }

  // Get auth token
  String? getToken() {
    return _prefs.getString(_tokenKey);
  }

  // Clear all stored data
  Future<void> clearAll() async {
    await _prefs.remove(_userKey);
    await _prefs.remove(_tokenKey);
  }
} 