import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.isRegistered<AuthController>() ? Get.find<AuthController>() : Get.put(AuthController(), permanent: true);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile'), actions: [IconButton(icon: const Icon(Icons.logout), onPressed: () => authController.logout())]),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Obx(() {
            final user = authController.user.value;
            if (user == null) return const SizedBox();

            return Column(
              children: [
                CircleAvatar(radius: 50, backgroundImage: user.image != null ? NetworkImage(user.image!) : null, child: user.image == null ? const Icon(Icons.person, size: 50) : null),
                const SizedBox(height: 30),
                ListTile(leading: const Icon(Icons.person_outline), title: const Text('Name'), subtitle: Text(user.name)),
                const Divider(),
                ListTile(leading: const Icon(Icons.email_outlined), title: const Text('Email'), subtitle: Text(user.email)),
                const Divider(),
                ListTile(leading: const Icon(Icons.phone_outlined), title: const Text('Phone'), subtitle: Text(user.phone)),
                const SizedBox(height: 30),
                // ElevatedButton.icon(
                //   onPressed: () => Get.dialog(const ChangePasswordDialog()),
                //   icon: const Icon(Icons.lock_outline),
                //   label: const Text('Change Password'),
                // ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
