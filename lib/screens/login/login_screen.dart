import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/language_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.put(AuthController());
    final languageController = Get.find<LanguageController>();

    return Scaffold(
      appBar: AppBar(
        // title: Text('welcome_back'.tr),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              languageController.changeLanguage(value);
            },
            itemBuilder: (context) => [PopupMenuItem(value: 'en_US', child: Text('english'.tr)), PopupMenuItem(value: 'hi_IN', child: Text('hindi'.tr))],
            child: Padding(padding: const EdgeInsets.all(8.0), child: Row(children: [Icon(Icons.language), SizedBox(width: 4), Text('change_language'.tr)])),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('welcome_back'.tr, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
              const SizedBox(height: 40),
              TextFormField(controller: authController.emailController, keyboardType: TextInputType.emailAddress, decoration: InputDecoration(labelText: 'email'.tr, prefixIcon: const Icon(Icons.email_outlined))),
              const SizedBox(height: 20),
              TextFormField(controller: authController.passwordController, obscureText: true, decoration: InputDecoration(labelText: 'password'.tr, prefixIcon: const Icon(Icons.lock_outline))),
              const SizedBox(height: 40),
              Obx(() => ElevatedButton(onPressed: authController.isLoading.value ? null : () => authController.login(), child: authController.isLoading.value ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : Text('login'.tr))),
            ],
          ),
        ),
      ),
    );
  }
}
