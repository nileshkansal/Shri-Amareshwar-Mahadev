import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shri_amareshwar_mahadev/controllers/auth_provider.dart';
import 'package:shri_amareshwar_mahadev/controllers/customer_provider.dart';
import 'package:shri_amareshwar_mahadev/controllers/language_provider.dart';
import 'package:shri_amareshwar_mahadev/screens/splash/splash_screen.dart';
import 'package:shri_amareshwar_mahadev/services/api_service.dart';

import 'translations/app_translations.dart';

String fcmToken = "sadkafjai";


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!defaultTargetPlatform.isAndroidOrIOS) {
    debugPrint('This app is only supported on Android and iOS devices.');
    return;
  }

  runApp(MultiProvider(providers: [ChangeNotifierProvider(create: (context) => AuthProvider()), ChangeNotifierProvider(create: (context) => LanguageProvider()), ChangeNotifierProvider(create: (context) => CustomerProvider(apiService: ApiService()))], child: const MyApp()));
}

extension PlatformExtension on TargetPlatform {
  bool get isAndroidOrIOS => this == TargetPlatform.android || this == TargetPlatform.iOS;
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  late LanguageProvider languageProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      languageProvider = Provider.of<LanguageProvider>(context, listen: false);
      await languageProvider.loadSavedLanguage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Shri Amareshwar Mahadev',
      debugShowCheckedModeBanner: false,
      translations: AppTranslations(),
      locale: Locale('en', 'US'),
      fallbackLocale: Locale('en', 'US'),
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: SplashScreen(),
    );
  }
}
