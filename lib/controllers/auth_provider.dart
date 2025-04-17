import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shri_amareshwar_mahadev/screens/home/home_screen.dart';
import 'package:shri_amareshwar_mahadev/screens/login/login_screen.dart';

import '../models/user_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class AuthProvider with ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;
  UserModel? _user;
  bool _isLoggedIn = false;

  late final ApiService _apiService;
  StorageService? _storageService;
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  bool get isLoading => _isLoading;

  UserModel? get user => _user;

  bool get isLoggedIn => _isLoggedIn;

  Future<void> initialize() async {
    _storageService ??= await StorageService.init();
    _apiService = ApiService();
    final savedUser = _storageService!.getUserData();
    if (savedUser != null) {
      _user = savedUser;
      _isLoggedIn = true;
      notifyListeners();
    }
    debugPrint("user ==========> ${user?.toJson()}");

    await checkAuthStatus();
  }

  Future<bool> checkLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }
    return true;
  }

  Future<Map<String, String>> _getDeviceInfo() async {
    try {
      if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        return {'model': iosInfo.model ?? 'Unknown', 'brand': 'Apple', 'os_type': 'iOS', 'os_version': iosInfo.systemVersion ?? 'Unknown'};
      } else {
        final androidInfo = await _deviceInfo.androidInfo;
        return {'model': androidInfo.model ?? 'Unknown', 'brand': androidInfo.brand ?? 'Unknown', 'os_type': 'Android', 'os_version': androidInfo.version.release ?? 'Unknown'};
      }
    } catch (e) {
      return {'model': 'Unknown', 'brand': 'Unknown', 'os_type': 'Unknown', 'os_version': 'Unknown'};
    }
  }

  Future<void> checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getString('token') != null;
    notifyListeners();
  }

  Future<void> login(BuildContext context) async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      return;
    }
    _isLoading = true;
    notifyListeners();

    bool hasLocationPermission = await checkLocationPermission();
    if (!hasLocationPermission) {
      _isLoading = false;
      notifyListeners();
      return;
    }

    final Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final deviceInfo = await _getDeviceInfo();

    try {
      UserModel loggedInUser = await _apiService.login(emailController.text, passwordController.text, deviceInfo, position);

      if(loggedInUser != null && loggedInUser.data?.token != null) {
        debugPrint("loggedInUser ===========> ${loggedInUser.toJson()}");
        await _storageService!.saveUserData(loggedInUser);
        _user = loggedInUser;
        _isLoggedIn = true;
        _isLoading = false;
        notifyListeners();
        clearFields();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) {
              return HomeScreen();
            },
          ),
              (route) => false,
        );
      } else {
        Fluttertoast.showToast(msg: "Login Failed");
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      debugPrint("error in login api ========> $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout(BuildContext context) async {
    await _storageService!.clearAll();
    _user = null;
    _isLoggedIn = false;
    notifyListeners();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) {
          return LoginScreen();
        },
      ),
      (route) => false,
    );
  }

  Future<void> changePassword(String currentPassword, String newPassword) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _apiService.changePassword(currentPassword, newPassword);
    } catch (e) {
      // Handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile(UserModel updatedUser) async {
    _isLoading = true;
    notifyListeners();
    try {
      final updatedProfile = await _apiService.updateProfile(updatedUser);
      _user = updatedProfile;
    } catch (e) {
      // Handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void clearFields(){
    if(emailController != null) {
      emailController.clear();
    }
    if(passwordController != null) {
      passwordController.clear();
    }
  }

}