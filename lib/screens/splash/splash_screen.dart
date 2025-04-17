import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shri_amareshwar_mahadev/controllers/auth_provider.dart';
import 'package:shri_amareshwar_mahadev/screens/home/home_screen.dart';
import 'package:shri_amareshwar_mahadev/screens/login/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _checkAuth(context);
  }

  Future<void> _checkAuth(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.initialize();

    await Future.delayed(const Duration(seconds: 2), () {

      debugPrint("User response =========> ${authProvider.user?.toJson()}");

      if (authProvider.user != null && authProvider.user?.data?.token != null && context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) {
          return HomeScreen();
        },), (route) => false,);
      } else {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) {
          return LoginScreen();
        },), (route) => false,);
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}