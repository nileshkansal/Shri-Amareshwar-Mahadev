// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../models/customer_model.dart';
// import '../services/api_service.dart';
// import '../controllers/auth_controller.dart';
//
// class CustomerController extends GetxController {
//   final formKey = GlobalKey<FormState>();
//   final firstNameController = TextEditingController();
//   final lastNameController = TextEditingController();
//   final phoneController = TextEditingController();
//   final spouseNameController = TextEditingController();
//   final gotraController = TextEditingController();
//   final dateOfBirth = Rxn<DateTime>();
//   final dateOfAnniversary = Rxn<DateTime>();
//   final dateOfDeath = Rxn<DateTime>();
//   final serviceDuration = ServiceDuration.monthly.obs;
//   final serviceEndDate = Rxn<DateTime>();
//   final selectedCategoryId = 0.obs;
//   final isLoading = false.obs;
//   final children = <Child>[].obs;
//   final ancestors = <Ancestor>[].obs;
//
//   ApiService? apiService;
//   AuthController? authController;
//
//   final customers = <CustomerModel>[].obs;
//   final selectedCustomer = Rxn<CustomerModel>();
//
//   @override
//   void onInit() {
//     super.onInit();
//     // Reset category ID when controller is initialized
//     apiService = Get.find<ApiService>();
//     authController = Get.find<AuthController>();
//     selectedCategoryId.value = 0;
//   }
//
//   void preSelectCategory(int categoryId) {
//     selectedCategoryId(categoryId);
//     refresh();
//
//     debugPrint("selectedCategoryId ==========> ${selectedCategoryId.value}");
//   }
//
//   void addChild(String name, DateTime dateOfBirth) {
//     children.add(Child(name: name, dateOfBirth: dateOfBirth));
//   }
//
//   void removeChild(int index) {
//     children.removeAt(index);
//   }
//
//   void addAncestor(String name, DateTime dateOfBirth) {
//     ancestors.add(Ancestor(name: name, dateOfBirth: dateOfBirth));
//   }
//
//   void removeAncestor(int index) {
//     ancestors.removeAt(index);
//   }
//
//   @override
//   void onClose() {
//     firstNameController.dispose();
//     lastNameController.dispose();
//     phoneController.dispose();
//     spouseNameController.dispose();
//     gotraController.dispose();
//     super.onClose();
//   }
//
//   Future<void> fetchCustomers() async {
//     try {
//       isLoading.value = true;
//       final fetchedCustomers = await apiService!.getCustomers();
//       customers.value = fetchedCustomers;
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to fetch customers: ${e.toString()}', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   bool validateForm() {
//     if(firstNameController.text.isEmpty ||
//     lastNameController.text.isEmpty ||
//     phoneController.text.isEmpty ||
//     spouseNameController.text.isEmpty ||
//     gotraController.text.isEmpty ||
//     dateOfBirth.value == null ||
//     dateOfAnniversary.value == null ||
//     selectedCategoryId.value == 0
//     ) {
//
//     } else if (selectedCategoryId.value == 0) {
//       Get.snackbar(
//         'Error',
//         'Please select a category',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//       return false;
//     }
//
//     if (dateOfBirth.value == null) {
//       Get.snackbar(
//         'Error',
//         'Please select date of birth',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//       return false;
//     }
//
//     return true;
//   }
//
//   Future<void> addCustomer() async {
//     if (!validateForm()) return;
//
//     try {
//       isLoading.value = true;
//
//       final customer = CustomerModel(
//         firstName: firstNameController.text.toString().trim(),
//         lastName: lastNameController.text.toString().trim(),
//         phoneNumber: phoneController.text.toString().trim(),
//         dateOfBirth: dateOfBirth.value!,
//         dateOfAnniversary: dateOfAnniversary.value,
//         dateOfDeath: dateOfDeath.value,
//         serviceDuration: serviceDuration.value,
//         categoryId: selectedCategoryId.value,
//         children: children,
//         ancestors: ancestors,
//         spouseName: spouseNameController.text.toString().trim(),
//         gotra: gotraController.text.toString().trim(),
//         serviceEndDate: serviceEndDate.value!,
//       );
//
//       await apiService!.addCustomer(customer);
//       Get.back();
//       Get.snackbar(
//         'Success',
//         'Customer added successfully',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         e.toString(),
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   Future<void> fetchCustomerDetails(String customerId) async {
//     try {
//       isLoading.value = true;
//       final customer = await apiService!.getCustomerDetails(customerId);
//       selectedCustomer.value = customer;
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to fetch customer details: ${e.toString()}', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }
