import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';
import 'package:geolocator/geolocator.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shri_amareshwar_mahadev/models/customer_response.dart';

import '../models/customer_model.dart';
import '../models/user_model.dart';

class ApiService {
  late final Dio _dio;
  static const String serverUrl = "https://shri-amareshwar-mahadev.brilliancetechsolutions.com/";
  static String imageUrl = "https://shri-amareshwar-mahadev.brilliancetechsolutions.com/public/";
  final String baseUrl = "${serverUrl}api"; // Replace with your actual base URL
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

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

  Future<UserModel> login(String email, String password, Map<String, String> deviceInfo, Position position) async {
    try {
      debugPrint('URL ==========> $baseUrl/login');

      // Create FormData
      final formData = FormData.fromMap({
        'email': email,
        'password': password,
        'latitude': position.latitude,
        'longitude': position.longitude,
        'fcm_token': 'test',
        'device_info': deviceInfo,
      });

      debugPrint('Form Data: ${formData.fields}');

      Response response = await _dio.post('/login', data: formData);

      debugPrint('Response Status Code ==========> ${response.statusCode}');
      debugPrint('Response Data ==========> ${response.data}');

      if (response.statusCode == 200 && response.data['status'] == true) {
        debugPrint('Response data ======> ${jsonEncode(response.data)}');
        return UserModel.fromJson(response.data);
      } else {
        debugPrint('Login failed with response: ${response.data}');
        throw response.data['message'] ?? 'Login failed';
      }
    } catch (e) {
      debugPrint('Login API Error: $e');
      if (e is DioException) {
        debugPrint('Dio Error Type: ${e.type}');
        debugPrint('Dio Error Message: ${e.message}');
        debugPrint('Dio Error Response: ${e.response?.data}');
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
    final url = '$baseUrl/customers';
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    debugPrint('Get Customers API Call:');
    debugPrint('URL: $url');
    debugPrint('Headers: $headers');

    final response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    debugPrint('Response Status Code: ${response.statusCode}');
    debugPrint('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['customers'] as List).map((customer) => CustomerModel.fromJson(customer)).toList();
    } else {
      throw Exception('Failed to get customers');
    }
  }

  Future<AddCustomerResponse> addCustomer(CustomerModel customer, {String? token}) async {
    final url = '$baseUrl/add/registration';
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final body = jsonEncode(customer.toJson());
    debugPrint('Add Customer API Call:');
    debugPrint('URL: $url');
    debugPrint('Headers: $headers');
    debugPrint('Request Body: $body');

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );
    debugPrint('Response Body: ${response.body}');
    final data = jsonDecode(response.body);
    if (data["status"] == true) {
      return AddCustomerResponse.fromJson(data);
    } else {
      throw Exception('Failed to add customer');
    }
  }

  Future<CustomerModel> getCustomerDetails(String customerId, {String? token}) async {
    final url = '$baseUrl/customers/$customerId';
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    debugPrint('Get Customer Details API Call:');
    debugPrint('URL: $url');
    debugPrint('Headers: $headers');

    final response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    debugPrint('Response Status Code: ${response.statusCode}');
    debugPrint('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return CustomerModel.fromJson(data['customer']);
    } else {
      throw Exception('Failed to get customer details');
    }
  }

  Future<UserModel> getUserProfile({String? token}) async {
    final url = '$baseUrl/user/profile';
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    debugPrint('Get User Profile API Call:');
    debugPrint('URL: $url');
    debugPrint('Headers: $headers');

    final response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    debugPrint('Response Status Code: ${response.statusCode}');
    debugPrint('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return UserModel.fromJson(data);
    } else {
      throw Exception('Failed to get user profile');
    }
  }

  Future<UserModel> updateProfile(UserModel user, {String? token}) async {
    final url = '$baseUrl/user/profile';
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final body = jsonEncode(user.toJson());

    debugPrint('Update Profile API Call:');
    debugPrint('URL: $url');
    debugPrint('Headers: $headers');
    debugPrint('Request Body: $body');

    final response = await http.put(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    debugPrint('Response Status Code: ${response.statusCode}');
    debugPrint('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return UserModel.fromJson(data);
    } else {
      throw Exception('Failed to update profile');
    }
  }
}