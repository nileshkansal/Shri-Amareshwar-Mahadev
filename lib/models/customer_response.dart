// To parse this JSON data, do
//
//     final addCustomerResponse = addCustomerResponseFromJson(jsonString);

import 'dart:convert';

AddCustomerResponse addCustomerResponseFromJson(String str) => AddCustomerResponse.fromJson(json.decode(str));

String addCustomerResponseToJson(AddCustomerResponse data) => json.encode(data.toJson());

class AddCustomerResponse {
  bool? status;
  int? code;
  String? message;
  List<dynamic>? data;

  AddCustomerResponse({
    this.status,
    this.code,
    this.message,
    this.data,
  });

  factory AddCustomerResponse.fromJson(Map<String, dynamic> json) => AddCustomerResponse(
    status: json["status"],
    code: json["code"],
    message: json["message"],
    data: json["data"] == null ? [] : List<dynamic>.from(json["data"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "code": code,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x)),
  };
}
