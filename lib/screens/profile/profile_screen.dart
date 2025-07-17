import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shri_amareshwar_mahadev/controllers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  late AuthProvider authProvider;

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Profile'), actions: [IconButton(icon: const Icon(Icons.logout), onPressed: () => authProvider.logout(context))]),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Builder(
            builder: (context) {
              final user = authProvider.user?.data?.user;
              if (user == null) return const SizedBox();

              return Column(
                children: [
                  CircleAvatar(radius: 50, backgroundImage: user.image != null ? NetworkImage(user.image!) : null, child: user.image == null ? const Icon(Icons.person, size: 50) : null),
                  const SizedBox(height: 30),
                  ListTile(leading: const Icon(Icons.person_outline), title: const Text('Name'), subtitle: Text(user.name ?? "")),
                  const Divider(),
                  ListTile(leading: const Icon(Icons.email_outlined), title: const Text('Email'), subtitle: Text(user.email ?? "")),
                  const Divider(),
                  ListTile(leading: const Icon(Icons.phone_outlined), title: const Text('Phone'), subtitle: Text(user.phone ?? "")),
                  const SizedBox(height: 30),
                  // ElevatedButton.icon(
                  //   onPressed: () => Get.dialog(const ChangePasswordDialog()),
                  //   icon: const Icon(Icons.lock_outline),
                  //   label: const Text('Change Password'),
                  // ),
                ],
              );
            }
          ),
        ),
      ),
    );
  }
}
