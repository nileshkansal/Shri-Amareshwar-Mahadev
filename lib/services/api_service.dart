import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:geolocator/geolocator.dart';
import '../models/user_model.dart';
import '../models/customer_model.dart';

class ApiService {
  static const String baseUrl = 'YOUR_API_BASE_URL';
  final String _token;

  ApiService(this._token);

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      };

  Future<UserModel> login(String email, String password) async {
    // Get device info
    final deviceInfo = await DeviceInfoPlugin().deviceInfo;
    final deviceData = {
      'model': deviceInfo.data['model'],
      'os': deviceInfo.data['systemName'],
      'brand': deviceInfo.data['brand'],
    };

    // Get location
    final position = await Geolocator.getCurrentPosition();
    final location = {
      'latitude': position.latitude,
      'longitude': position.longitude,
    };

    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'device_info': deviceData,
        'location': location,
        'fcm_token': 'YOUR_FCM_TOKEN', // Implement FCM token retrieval
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return UserModel.fromJson(data['user']);
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<void> changePassword(String currentPassword, String newPassword) async {
    final response = await http.post(
      Uri.parse('$baseUrl/change-password'),
      headers: _headers,
      body: jsonEncode({
        'current_password': currentPassword,
        'new_password': newPassword,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to change password');
    }
  }

  Future<List<CustomerModel>> getCustomers() async {
    final response = await http.get(
      Uri.parse('$baseUrl/customers'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['customers'] as List)
          .map((customer) => CustomerModel.fromJson(customer))
          .toList();
    } else {
      throw Exception('Failed to get customers');
    }
  }

  Future<CustomerModel> addCustomer(CustomerModel customer) async {
    final response = await http.post(
      Uri.parse('$baseUrl/customers'),
      headers: _headers,
      body: jsonEncode(customer.toJson()),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return CustomerModel.fromJson(data['customer']);
    } else {
      throw Exception('Failed to add customer');
    }
  }

  Future<CustomerModel> getCustomerDetails(String customerId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/customers/$customerId'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return CustomerModel.fromJson(data['customer']);
    } else {
      throw Exception('Failed to get customer details');
    }
  }

  Future<UserModel> updateProfile(UserModel user) async {
    final response = await http.put(
      Uri.parse('$baseUrl/profile'),
      headers: _headers,
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return UserModel.fromJson(data['user']);
    } else {
      throw Exception('Failed to update profile');
    }
  }
} 