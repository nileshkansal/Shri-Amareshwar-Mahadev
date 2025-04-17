import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shri_amareshwar_mahadev/controllers/auth_provider.dart';
import 'package:shri_amareshwar_mahadev/controllers/language_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {

  late LanguageProvider languageProvider;
  late AuthProvider authProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      languageProvider = Provider.of<LanguageProvider>(context, listen: false);
      authProvider = Provider.of<AuthProvider>(context, listen: false);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              languageProvider.changeLanguage(value);
            },
            itemBuilder: (context) => [PopupMenuItem(value: 'en_US', child: Text('english'.tr)), PopupMenuItem(value: 'hi_IN', child: Text('hindi'.tr),),],
            child: Padding(padding: const EdgeInsets.all(8.0), child: Row(children: [Icon(Icons.language), SizedBox(width: 4), Text('change_language'.tr),],),),
          ),
        ],
      ),
      body: Consumer<AuthProvider>(
        builder: (BuildContext context, AuthProvider value, Widget? child) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('welcome_back'.tr, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                const SizedBox(height: 40),
                TextFormField(controller: value.emailController, keyboardType: TextInputType.emailAddress, decoration: InputDecoration(labelText: 'email'.tr, prefixIcon: const Icon(Icons.email_outlined),),),
                const SizedBox(height: 20),
                TextFormField(controller: value.passwordController, obscureText: true, decoration: InputDecoration(labelText: 'password'.tr, prefixIcon: const Icon(Icons.lock_outline),),),
                const SizedBox(height: 40),
                ElevatedButton(onPressed: value.isLoading ? null : () => value.login(context), child: value.isLoading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : Text('login'.tr),),              ],
            ),
          );
        },
      ),
    );
  }
}