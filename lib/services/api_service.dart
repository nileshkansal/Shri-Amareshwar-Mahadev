import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shri_amareshwar_mahadev/main.dart';
import 'package:shri_amareshwar_mahadev/models/customer_list_response.dart';
import 'package:shri_amareshwar_mahadev/models/customer_response.dart';

import '../models/customer_model.dart';
import '../models/user_model.dart';

class ApiService {
  late final Dio _dio;
  static const String serverUrl = "https://shriamareshwarmahadev.org/";
  static String imageUrl = "https://shriamareshwarmahadev.org/public/";
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

  Future<UserModel> login(BuildContext context, String email, String password, Map<String, String> deviceInfo, Position position) async {
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
        showScrollableCopyableDialog(context, response.data);
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
        showScrollableCopyableDialog(context, response);
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

  Future<List<CustomerList>?> getCustomers(var body, {String? token}) async {
    final url = '$baseUrl/registration/list';
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    debugPrint('Get Customers API Call:');
    debugPrint('URL: $url');
    debugPrint('Headers: $headers');
    debugPrint('Body: $body');

    final response = await http.post(
      Uri.parse(url),
      body: body,
      headers: headers,
    );

    debugPrint('Response Status Code: ${response.statusCode}');
    debugPrint('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body);
        debugPrint('data =======> $data');
        CustomerListResponse customerListResponse = CustomerListResponse.fromJson(data);
        debugPrint("customer list length =======> ${customerListResponse.data?.length}");
        return customerListResponse.data;
      } catch (e) {
        debugPrint("catch error =======> ${e.toString()}");
        return null;
      }
    } else {
      debugPrint("customer list length =======> ${response.reasonPhrase}");
      throw Exception('Failed to get customers');
    }
  }

  Future<AddCustomerResponse> addCustomer(BuildContext context, CustomerModel customer, {String? token, File? imageFile}) async {
    try {
      final url = '$baseUrl/add/registration';
      final body = jsonEncode(customer.toJson());
      debugPrint('Add Customer API Call:');
      debugPrint('URL: $url');
      debugPrint('Request Body: $body');

      final request = http.MultipartRequest('POST', Uri.parse(url))
        ..headers.addAll({
          'Content-Type': 'multipart/form-data',
          'Authorization': 'Bearer $token',
        });

      final customerJson = customer.toJson();
      customerJson.forEach((key, value) {
        if (value != null) {
          request.fields[key] = value.toString();
        }
      });

      if (imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
        ));
      }

      debugPrint("request files ==========> ${request.files.length}");
      debugPrint("request headers ==========> ${request.headers.toString()}");
      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      debugPrint('Response status code: ${response.statusCode}');
      debugPrint('Response reason Phrase: ${response.reasonPhrase}');
      debugPrint('Response Body: ${response.body}');
      debugPrint('Response headers: ${response.headers}');
      debugPrint('Response request: ${response.request.toString()}');

      final data = jsonDecode(response.body);
      debugPrint(data["message"]);

      if (data["status"] == true) {
        return AddCustomerResponse.fromJson(data);
      } else {
        showScrollableCopyableDialog(context, response.reasonPhrase);
        throw Exception(data["message"] ?? 'Failed to add customer');
      }
    } catch(e) {
      debugPrint('Login API Error: $e');
      if (e is DioException) {
        debugPrint('Dio Error Type: ${e.type}');
        debugPrint('Dio Error Message: ${e.message}');
        debugPrint('Dio Error Response: ${e.response?.data}');
        final response = e.response?.data;
        showScrollableCopyableDialog(context, response);
        throw response?['message'] ?? 'Login failed';
      }
      throw 'Customer add failed: $e';
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

  Future<void> updateFCM({String? token}) async {
    final url = '$baseUrl/update/fcm';
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final body = jsonEncode({
      "fcm_token": fcmToken
    });

    debugPrint('Update Profile API Call:');
    debugPrint('URL: $url');
    debugPrint('Headers: $headers');
    debugPrint('Request Body: $body');

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    debugPrint('Response Status Code: ${response.statusCode}');
    debugPrint('Response Body: ${response.body}');
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