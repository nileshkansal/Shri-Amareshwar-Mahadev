import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shri_amareshwar_mahadev/controllers/auth_provider.dart';
import 'package:shri_amareshwar_mahadev/models/customer_list_response.dart';
import 'package:shri_amareshwar_mahadev/models/customer_response.dart';

import '../models/customer_model.dart';
import '../services/api_service.dart';

class CustomerProvider with ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final spouseNameController = TextEditingController();
  final gotraController = TextEditingController();
  final addressController = TextEditingController();

  DateTime? dateOfBirth;
  DateTime? dateOfAnniversary;
  DateTime? dateOfDeath;
  DateTime? serviceEndDate;
  final Map<String, String> serviceDurationMap = {'monthly': 'Monthly', 'quarterly': 'Quarterly', 'half_yearly': 'Half Yearly', 'yearly': 'Yearly'};

  String serviceDuration = "monthly";
  int selectedCategoryId = 0;

  bool isLoading = false;

  List<Child> children = [];
  List<Ancestor> ancestors = [];

  final ApiService apiService;

  List<CustomerModel> customers = [];
  CustomerModel? selectedCustomer;
  List<CustomerList>? customerList = [];

  File? selectedImageFile;


  CustomerProvider({required this.apiService});

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      selectedImageFile = File(pickedFile.path);
      notifyListeners();
    }
  }


  void preSelectCategory(int categoryId) {
    selectedCategoryId = categoryId;
    debugPrint("selectedCategoryId ==========> $selectedCategoryId");
    notifyListeners();
  }

  void addChild(String name, DateTime dob) {
    children.add(Child(name: name, dateOfBirth: dob));
    notifyListeners();
  }

  void removeChild(int index) {
    children.removeAt(index);
    notifyListeners();
  }

  void addAncestor(String name, DateTime dob) {
    ancestors.add(Ancestor(name: name, dateOfBirth: dob));
    notifyListeners();
  }

  void removeAncestor(int index) {
    ancestors.removeAt(index);
    notifyListeners();
  }

  void setDateOfBirth(DateTime date) {
    dateOfBirth = date;
    notifyListeners();
  }

  void setDateOfAnniversary(DateTime date) {
    dateOfAnniversary = date;
    notifyListeners();
  }

  void setDateOfDeath(DateTime date) {
    dateOfDeath = date;
    notifyListeners();
  }

  void setServiceEndDate(DateTime date) {
    serviceEndDate = date;
    notifyListeners();
  }

  void setServiceDuration(String duration) {
    serviceDuration = duration;
    notifyListeners();
  }

  Future<void> fetchCustomers(BuildContext context, {required int page, required String token}) async {
    try {
      isLoading = true;
      notifyListeners();

      var body = jsonEncode({"page": page, "ItemCount": 10});

      customerList = await apiService.getCustomers(body, token: token);
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to fetch customers: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to fetch customers: $e')));
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  bool validateForm(BuildContext context) {
    if (firstNameController.text.isEmpty || lastNameController.text.isEmpty || phoneController.text.isEmpty || spouseNameController.text.isEmpty || gotraController.text.isEmpty || serviceDuration.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all the required fields')));
      return false;
    }
    return true;
  }

  Future<void> addCustomer(BuildContext context, int categoryId) async {
    // if (!validateForm(context)) return;

    try {
      isLoading = true;
      notifyListeners();

      final customer = CustomerModel(
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        phoneNumber: phoneController.text.trim(),
        dateOfBirth: dateOfBirth!,
        dateOfAnniversary: dateOfAnniversary,
        dateOfDeath: dateOfDeath,
        serviceDuration: serviceDuration,
        categoryId: categoryId,
        children: children,
        ancestors: ancestors,
        spouseName: spouseNameController.text.trim(),
        gotra: gotraController.text.trim(),
        serviceEndDate: serviceEndDate!,
        address: addressController.text.toString()
      );

      debugPrint("customer ==========> ${customer.toJson()}");
      AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
      String token = authProvider.user?.data?.token ?? '';


      AddCustomerResponse response = await apiService.addCustomer(
        customer,
        token: token,
        imageFile: selectedImageFile,
      );

      if (response.status != null && response.status!) {
        clearFields();
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Customer added successfully')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response.message!)));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchCustomerDetails(BuildContext context, String customerId, {String? token}) async {
    try {
      isLoading = true;
      notifyListeners();

      selectedCustomer = await apiService.getCustomerDetails(customerId, token: token);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to fetch customer details: $e')));
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void disposeControllers() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    spouseNameController.dispose();
    gotraController.dispose();
  }

  void clearFields() {
    firstNameController.clear();
    lastNameController.clear();
    phoneController.clear();
    spouseNameController.clear();
    gotraController.clear();
    addressController.clear();
    selectedImageFile = null;

    dateOfBirth = null;
    dateOfAnniversary = null;
    dateOfDeath = null;
    serviceEndDate = null;

    serviceDuration = "monthly";
    selectedCategoryId = 0;

    isLoading = false;

    children = [];
    ancestors = [];

    customers = [];
    selectedCustomer = null;
    customerList = [];
    notifyListeners();
  }
}
