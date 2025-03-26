import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageController extends GetxController {
  final _prefs = SharedPreferences.getInstance();
  final locale = Rx<String>('en_US');

  @override
  void onInit() {
    super.onInit();
    loadSavedLanguage();
  }

  Future<void> loadSavedLanguage() async {
    final prefs = await _prefs;
    final savedLanguage = prefs.getString('language') ?? 'en_US';
    changeLanguage(savedLanguage);
  }

  Future<void> changeLanguage(String langCode) async {
    final prefs = await _prefs;
    await prefs.setString('language', langCode);
    locale.value = langCode;
    await Get.updateLocale(Locale(langCode.split('_')[0], langCode.split('_')[1]));
  }
} 