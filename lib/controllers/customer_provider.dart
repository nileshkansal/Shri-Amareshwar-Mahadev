import 'dart:convert';
import 'dart:io';

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
  final gotraController = TextEditingController();
  final addressController = TextEditingController();
  final priceController = TextEditingController();
  final dueAmountController = TextEditingController();

  DateTime? dateOfBirth;
  DateTime? dateOfAnniversary;
  DateTime? dateOfDeath;
  DateTime? serviceEndDate;
  final Map<String, String> serviceDurationMap = {'monthly': 'Monthly', 'quarterly': 'Quarterly', 'half_yearly': 'Half Yearly', 'yearly': 'Yearly'};
  final Map<String, String> mobileTypeMap = {'whatsapp': 'WhatsApp', 'call': 'Call', 'telegram': 'Telegram', 'sms': 'SMS'};
  final Map<String, String> belongsToMap = {'self': 'Self', 'spouse': 'Spouse', 'child': 'Child', 'parent': 'Parent'};

  String serviceDuration = "monthly";
  String mobileType = "whatsapp";
  String belongsTo = "self";
  int selectedCategoryId = 0;

  bool isLoading = true;

  List<PhoneNumber> phoneNumber = [];
  List<Child> spouse = [];
  List<Child> children = [];
  List<Ancestor> ancestors = [];

  final ApiService apiService;

  List<CustomerModel> customers = [];
  CustomerModel? selectedCustomer;
  List<CustomerList>? customerList = [];

  File? selectedImageFile;

  CustomerProvider({required this.apiService});

  Future<void> pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile;
    if(source == ImageSource.gallery) {
      pickedFile = await picker.pickImage(source: source);
    } else {
      pickedFile = await picker.pickImage(source: source, maxWidth: 512, maxHeight: 512);
    }

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

  void addNumber(String number, String mobileType, String belongsTo) {
    phoneNumber.add(PhoneNumber(number: number, mobileType: mobileType, belongsTo: belongsTo));
    notifyListeners();
  }

  void removeNumber(int index) {
    phoneNumber.removeAt(index);
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

  void addAncestor(String name, DateTime dob, DateTime? dod, String status) {
    final correctedDod = status == "Alive" ? null : dod;
    ancestors.add(Ancestor(name: name, dateOfBirth: dob, dateOfDeath: correctedDod, status: status));
    notifyListeners();
    notifyListeners();
  }

  void removeAncestor(int index) {
    ancestors.removeAt(index);
    notifyListeners();
  }

  void addSpouse(String name, DateTime dob) {
    spouse.add(Child(name: name, dateOfBirth: dob));
    notifyListeners();
  }

  void removeSpouse(int index) {
    spouse.removeAt(index);
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
    if (firstNameController.text.isEmpty || lastNameController.text.isEmpty /*|| phoneController.text.isEmpty || spouseNameController.text.isEmpty*/ || gotraController.text.isEmpty || serviceDuration.isEmpty) {
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
        dateOfBirth: dateOfBirth!,
        dateOfAnniversary: dateOfAnniversary,
        dateOfDeath: dateOfDeath,
        serviceDuration: serviceDuration,
        categoryId: categoryId,
        children: children,
        ancestors: ancestors,
        gotra: gotraController.text.trim(),
        serviceEndDate: serviceEndDate!,
        address: addressController.text.toString(),
        spouseDetail: spouse,
        number: phoneNumber,
        price: int.parse(priceController.text.trim()),
        dueAmount: int.parse(dueAmountController.text.trim()),
      );

      debugPrint("customer ==========> ${customer.toJson()}");
      AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
      String token = authProvider.user?.data?.token ?? '';

      AddCustomerResponse response = await apiService.addCustomer(
        context,
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
      showScrollableCopyableDialog(context, e.toString());
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
    gotraController.dispose();
  }

  void clearFields() {
    firstNameController.clear();
    lastNameController.clear();
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
    spouse = [];
    phoneNumber = [];

    customers = [];
    selectedCustomer = null;
    customerList = [];
    notifyListeners();
  }

  void showScrollableCopyableDialog(BuildContext context, String? message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: const EdgeInsets.all(16),
        content: SizedBox(
          width: double.infinity,
          height: 400,
          child: Scrollbar(
            child: SingleChildScrollView(
              child: SelectableText(
                message ?? "",
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
