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