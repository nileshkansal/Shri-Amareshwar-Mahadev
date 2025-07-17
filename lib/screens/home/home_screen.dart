import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shri_amareshwar_mahadev/controllers/auth_provider.dart';
import 'package:shri_amareshwar_mahadev/screens/customer/add_customer_screen.dart';
import 'package:shri_amareshwar_mahadev/screens/customer/customer_list_screen.dart';
import 'package:shri_amareshwar_mahadev/screens/profile/profile_screen.dart';
import 'package:shri_amareshwar_mahadev/services/api_service.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  late AuthProvider authProvider;

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of<AuthProvider>(context);
    authProvider.updateFCM();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return ProfileScreen();
              },));
            },
          ),
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return CustomerListScreen();
              },));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Welcome, ${authProvider.user?.data?.user?.name ?? "User"}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              const Text('Our Services', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Builder(
                builder: (context) {
                  debugPrint("user selected categories ========> ${authProvider.user?.data?.user?.categories}");
                  final categories = authProvider.user?.data?.user?.categories ?? [];
                  if (categories.isEmpty) {
                    return const Center(child: Text('No services available'));
                  }
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 15, mainAxisSpacing: 15, childAspectRatio: 1.1),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      mainAxisExtent: 190,),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: InkWell(
                          onTap: () {
                            debugPrint("category id ==========> ${category.id}");
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                              return AddCustomerScreen(categoryId: category.id!);
                            },));
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (category.image != null && category.image != "")
                                  CachedNetworkImage(
                                    imageUrl: "${ApiService.imageUrl}${category.image}",
                                    height: 50,
                                    width: 50,
                                    errorWidget: (context, url, error) {
                                      return Icon(Icons.category, size: 40, color: Colors.orange);
                                    },
                                    placeholder: (context, url) {
                                      return CircularProgressIndicator(color: Colors.orange, padding: EdgeInsets.all(5.0),);
                                    },
                                  )
                                else
                                  Icon(Icons.category, size: 40, color: Theme.of(context).primaryColor),
                                const SizedBox(height: 8),
                                Text(category.name ?? "", textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
