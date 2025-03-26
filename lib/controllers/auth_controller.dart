import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData;
import 'package:dio/dio.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:geolocator/geolocator.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
import '../models/user_model.dart';
import '../routes/app_pages.dart';
import 'package:shared_preferences.dart';

class AuthController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isLoading = false.obs;
  final user = Rxn<UserModel>();
  final isLoggedIn = false.obs;

  late final ApiService _apiService;
  late final StorageService _storageService;
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  @override
  void onInit() async {
    super.onInit();
    _storageService = await StorageService.init();
    _apiService = ApiService();
    
    // Load saved user data if available
    final savedUser = _storageService.getUserData();
    if (savedUser != null) {
      user.value = savedUser;
      Get.offAllNamed(Routes.home);
    }

    checkAuthStatus();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<bool> checkLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled
      Get.dialog(
        AlertDialog(
          title: Text('location_services_disabled'.tr),
          content: Text('enable_location_services'.tr),
          actions: [
            TextButton(
              onPressed: () async {
                Get.back();
                await Geolocator.openLocationSettings();
              },
              child: Text('open_settings'.tr),
            ),
            TextButton(
              onPressed: () => Get.back(),
              child: Text('cancel'.tr),
            ),
          ],
        ),
      );
      return false;
    }

    // Check location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar(
          'permission_denied'.tr,
          'location_permission_required'.tr,
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.dialog(
        AlertDialog(
          title: Text('location_permission'.tr),
          content: Text('location_permission_denied'.tr),
          actions: [
            TextButton(
              onPressed: () async {
                Get.back();
                await Geolocator.openAppSettings();
              },
              child: Text('open_settings'.tr),
            ),
            TextButton(
              onPressed: () => Get.back(),
              child: Text('cancel'.tr),
            ),
          ],
        ),
      );
      return false;
    }

    return true;
  }

  Future<String> _getDeviceInfo() async {
    try {
      if (GetPlatform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        return '${androidInfo.brand} ${androidInfo.model}';
      } else if (GetPlatform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        return '${iosInfo.name} ${iosInfo.model}';
      }
      return 'Unknown Device';
    } catch (e) {
      return 'Device Info Not Available';
    }
  }

  Future<Position> _getCurrentLocation() async {
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<void> checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    isLoggedIn.value = token != null;
    
    if (isLoggedIn.value) {
      await getUserProfile();
    }
  }

  Future<void> getUserProfile() async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      
      if (token != null) {
        final userData = await _apiService.getUserProfile(token);
        user.value = userData;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch user profile: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar(
        'error'.tr,
        'fill_all_fields'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;
      
      // First check location permission
      bool hasLocationPermission = await checkLocationPermission();
      if (!hasLocationPermission) {
        isLoading.value = false;
        return;
      }

      // Get current location
      final position = await _getCurrentLocation();
      
      // Get device info
      final deviceInfo = await _getDeviceInfo();

      // Prepare form data
      final formData = FormData.fromMap({
        'email': emailController.text,
        'password': passwordController.text,
        'latitude': position.latitude.toString(),
        'longitude': position.longitude.toString(),
        'fcm_token': 'not_implemented',  // Since we're skipping Firebase
        'device_info': deviceInfo,
      });

      final loggedInUser = await _apiService.login(formData);
      
      // Save user data to storage
      await _storageService.saveUserData(loggedInUser);
      
      user.value = loggedInUser;
      isLoggedIn.value = true;
      Get.offAllNamed(Routes.home);
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        'Failed to login: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _storageService.clearAll();
    user.value = null;
    isLoggedIn.value = false;
    Get.offAllNamed(Routes.login);
  }

  Future<void> changePassword(String currentPassword, String newPassword) async {
    try {
      isLoading.value = true;
      await _apiService.changePassword(currentPassword, newPassword);
      Get.back();
      Get.snackbar(
        'Success',
        'Password changed successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to change password: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile(UserModel updatedUser) async {
    try {
      isLoading.value = true;
      final updatedProfile = await _apiService.updateProfile(updatedUser);
      user.value = updatedProfile;
      Get.back();
      Get.snackbar(
        'Success',
        'Profile updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update profile: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
} 