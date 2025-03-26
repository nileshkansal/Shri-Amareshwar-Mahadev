import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

import '../models/customer_model.dart';
import '../models/user_model.dart';

class ApiService {
  late final Dio _dio;
  static const String serverUrl = "https://shri-amareshwar-mahadev.brilliancetechsolutions.com/";
  final String baseUrl = "${serverUrl}api"; // Replace with your actual base URL

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        headers: {
          'Accept': 'application/json',
        },
      ),
    );
  }

  Future<UserModel> login(FormData formData) async {
    try {
      final response = await _dio.post('/login', data: formData);

      if (response.statusCode == 200 && response.data['status'] == true) {
        final responseData = response.data['data'];
        // Combine token and user data for the UserModel
        final userData = {
          ...responseData['user'],
          'token': responseData['token'],
        };
        return UserModel.fromJson({'user': userData});
      } else {
        throw response.data['message'] ?? 'Login failed';
      }
    } catch (e) {
      if (e is DioException) {
        final response = e.response?.data;
        throw response?['message'] ?? 'Login failed';
      }
      throw 'Login failed: $e';
    }
  }

  Future<void> changePassword(String currentPassword, String newPassword, {String? token}) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.post(
      Uri.parse('$baseUrl/change-password'),
      headers: headers,
      body: jsonEncode({
        'current_password': currentPassword,
        'new_password': newPassword,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to change password');
    }
  }

  Future<List<CustomerModel>> getCustomers({String? token}) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(
      Uri.parse('$baseUrl/customers'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['customers'] as List).map((customer) => CustomerModel.fromJson(customer)).toList();
    } else {
      throw Exception('Failed to get customers');
    }
  }

  Future<CustomerModel> addCustomer(CustomerModel customer, {String? token}) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.post(
      Uri.parse('$baseUrl/customers'),
      headers: headers,
      body: jsonEncode(customer.toJson()),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return CustomerModel.fromJson(data['customer']);
    } else {
      throw Exception('Failed to add customer');
    }
  }

  Future<CustomerModel> getCustomerDetails(String customerId, {String? token}) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(
      Uri.parse('$baseUrl/customers/$customerId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return CustomerModel.fromJson(data['customer']);
    } else {
      throw Exception('Failed to get customer details');
    }
  }

  Future<UserModel> updateProfile(UserModel user, {String? token}) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.put(
      Uri.parse('$baseUrl/profile'),
      headers: headers,
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
