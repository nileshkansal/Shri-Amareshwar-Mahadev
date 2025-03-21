import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/customer_model.dart';
import '../services/api_service.dart';

class CustomerController extends GetxController {
  final ApiService _apiService;
  final isLoading = false.obs;
  final customers = <CustomerModel>[].obs;
  final selectedCustomer = Rxn<CustomerModel>();

  // Form controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final spouseNameController = TextEditingController();
  final gotraController = TextEditingController();
  final dateOfBirth = Rxn<DateTime>();
  final dateOfAnniversary = Rxn<DateTime>();
  final children = <Child>[].obs;
  final ancestors = <Ancestor>[].obs;
  final selectedService = ''.obs;
  final serviceDuration = ServiceDuration.monthly.obs;
  final serviceDurationStartDate = Rxn<DateTime>();
  final serviceDurationEndDate = Rxn<DateTime>();

  CustomerController(this._apiService);

  @override
  void onInit() {
    super.onInit();
    fetchCustomers();
  }

  void preSelectService(String service) {
    selectedService.value = service;
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    spouseNameController.dispose();
    gotraController.dispose();
    super.onClose();
  }

  Future<void> fetchCustomers() async {
    try {
      isLoading.value = true;
      final fetchedCustomers = await _apiService.getCustomers();
      customers.value = fetchedCustomers;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch customers: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addCustomer() async {
    if (!validateForm()) return;

    try {
      isLoading.value = true;
      final customer = CustomerModel(
        id: '', // Will be assigned by the server
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        spouseName: spouseNameController.text,
        gotra: gotraController.text,
        dateOfBirth: dateOfBirth.value!,
        dateOfAnniversary: dateOfAnniversary.value,
        children: children,
        ancestors: ancestors,
        serviceDuration: serviceDuration.value,
        serviceDurationStartDate: serviceDurationStartDate.value!,
        serviceDurationEndDate: serviceDurationEndDate.value!,
        selectedService: selectedService.value,
      );

      await _apiService.addCustomer(customer);
      clearForm();
      Get.back();
      Get.snackbar(
        'Success',
        'Customer added successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      fetchCustomers();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add customer: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchCustomerDetails(String customerId) async {
    try {
      isLoading.value = true;
      final customer = await _apiService.getCustomerDetails(customerId);
      selectedCustomer.value = customer;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch customer details: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  bool validateForm() {
    if (firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        spouseNameController.text.isEmpty ||
        gotraController.text.isEmpty ||
        dateOfBirth.value == null ||
        selectedService.value.isEmpty ||
        serviceDurationStartDate.value == null ||
        serviceDurationEndDate.value == null) {
      Get.snackbar(
        'Error',
        'Please fill in all required fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
    return true;
  }

  void clearForm() {
    firstNameController.clear();
    lastNameController.clear();
    spouseNameController.clear();
    gotraController.clear();
    dateOfBirth.value = null;
    dateOfAnniversary.value = null;
    children.clear();
    ancestors.clear();
    selectedService.value = '';
    serviceDuration.value = ServiceDuration.monthly;
    serviceDurationStartDate.value = null;
    serviceDurationEndDate.value = null;
  }

  void addChild(String name, DateTime dateOfBirth) {
    children.add(Child(name: name, dateOfBirth: dateOfBirth));
  }

  void removeChild(int index) {
    children.removeAt(index);
  }

  void addAncestor(String name, DateTime deathAnniversary) {
    ancestors.add(Ancestor(name: name, deathAnniversary: deathAnniversary));
  }

  void removeAncestor(int index) {
    ancestors.removeAt(index);
  }
} 