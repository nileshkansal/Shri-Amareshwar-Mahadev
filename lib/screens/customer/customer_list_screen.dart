import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shri_amareshwar_mahadev/controllers/auth_provider.dart';
import 'package:shri_amareshwar_mahadev/controllers/customer_provider.dart';

class CustomerListScreen extends StatefulWidget {
  const CustomerListScreen({super.key});

  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  late CustomerProvider provider;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<CustomerProvider>(context, listen: false);
    AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.fetchCustomers(context, page: 1, token: authProvider.user!.data!.token.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Customer List')),
      body:
          Consumer<CustomerProvider>(
                builder: (BuildContext context, CustomerProvider value, Widget? child) {
                  if(provider.isLoading) {
                    return SizedBox(width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height, child: Center(child: CircularProgressIndicator(color: Colors.purple)));
                  }

                  return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child:
                        value.customerList == null || value.customerList!.isEmpty
                            ? Center(child: Text("No Data Found", style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w600)))
                            : ListView.builder(
                              padding: const EdgeInsets.all(20),
                              itemCount: value.customerList!.length,
                              itemBuilder: (context, index) {
                                final customer = value.customerList![index];
                                return Card(
                                  margin: const EdgeInsets.only(bottom: 15),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.all(15),
                                    title: Text(customer.fName.toString(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        if(customer.number!.isNotEmpty)
                                        Text('Mobile Number: ${customer.number![0].number}', style: const TextStyle(fontSize: 14)),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              flex: 1,
                                                child: Text('Service: ${customer.category!.name.toString()}', style: const TextStyle(fontSize: 14))),
                                            Expanded(
                                              flex: 1,
                                                child: Text('Service End: ${DateFormat('dd/MM/yyyy').format(customer.serviceEnd!)}', style: const TextStyle(fontSize: 14))),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                  );
                },
              ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import '../../controllers/customer_controller.dart';
// import '../../routes/app_pages.dart';
// import '../../services/api_service.dart';
//
// class CustomerListScreen extends StatelessWidget {
//   const CustomerListScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(CustomerController());
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Customer List'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.add),
//             onPressed: () => Get.toNamed(Routes.addCustomer),
//           ),
//         ],
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }
//
//         if (controller.customers.isEmpty) {
//           return const Center(
//             child: Text('No customers found'),
//           );
//         }
//
//         return ListView.builder(
//           padding: const EdgeInsets.all(20),
//           itemCount: controller.customers.length,
//           itemBuilder: (context, index) {
//             final customer = controller.customers[index];
//             return Card(
//               margin: const EdgeInsets.only(bottom: 15),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: ListTile(
//                 contentPadding: const EdgeInsets.all(15),
//                 title: Text(
//                   customer.fullName,
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 subtitle: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const SizedBox(height: 5),
//                     Text(
//                       'Service End Date: ${DateFormat('dd/MM/yyyy').format(customer.serviceEndDate)}',
//                       style: const TextStyle(fontSize: 14),
//                     ),
//                     const SizedBox(height: 5),
//                     Text(
//                       'Service: ${customer.categoryId}',
//                       style: const TextStyle(fontSize: 14),
//                     ),
//                   ],
//                 ),
//                 trailing: IconButton(
//                   icon: const Icon(Icons.arrow_forward_ios),
//                   onPressed: () {
//                     controller.selectedCustomer.value = customer;
//                     Get.toNamed(Routes.customerDetails);
//                   },
//                 ),
//               ),
//             );
//           },
//         );
//       }),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => Get.toNamed(Routes.addCustomer),
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
