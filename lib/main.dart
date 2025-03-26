import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shri_amareshwar_mahadev/services/binding_service.dart';
import 'routes/app_pages.dart';
import 'translations/app_translations.dart';
import 'controllers/language_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Check if running on web or desktop platforms
  if (!defaultTargetPlatform.isAndroidOrIOS) {
    debugPrint('This app is only supported on Android and iOS devices.');
    return;
  }
  
  // Initialize language controller
  final languageController = Get.put(LanguageController());
  await languageController.loadSavedLanguage();

  runApp(const MyApp());
}

extension PlatformExtension on TargetPlatform {
  bool get isAndroidOrIOS => this == TargetPlatform.android || this == TargetPlatform.iOS;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Shri Amareshwar Mahadev',
      debugShowCheckedModeBanner: false,
      translations: AppTranslations(),
      locale: Locale('en', 'US'),
      fallbackLocale: Locale('en', 'US'),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      initialBinding: InitialBinding(),
      initialRoute: Routes.login,
      getPages: AppPages.routes,
    );
  }
}