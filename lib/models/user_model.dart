// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  bool? status;
  int? code;
  String? message;
  Data? data;

  UserModel({
    this.status,
    this.code,
    this.message,
    this.data,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    status: json["status"],
    code: json["code"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "code": code,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  String? token;
  User? user;

  Data({
    this.token,
    this.user,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    token: json["token"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "token": token,
    "user": user?.toJson(),
  };
}

class User {
  int? id;
  String? name;
  String? email;
  String? phone;
  dynamic image;
  String? categoryId;
  int? status;
  int? editStatus;
  int? viewStatus;
  dynamic emailVerifiedAt;
  String? latitude;
  String? longitude;
  String? fcmToken;
  DeviceInfo? deviceInfo;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<Category>? categories;

  User({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.image,
    this.categoryId,
    this.status,
    this.editStatus,
    this.viewStatus,
    this.emailVerifiedAt,
    this.latitude,
    this.longitude,
    this.fcmToken,
    this.deviceInfo,
    this.createdAt,
    this.updatedAt,
    this.categories,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    image: json["image"],
    categoryId: json["category_id"],
    status: json["status"],
    editStatus: json["edit_status"],
    viewStatus: json["view_status"],
    emailVerifiedAt: json["email_verified_at"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    fcmToken: json["fcm_token"],
    deviceInfo: json["device_info"] == null ? null : DeviceInfo.fromJson(json["device_info"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    categories: json["categories"] == null ? [] : List<Category>.from(json["categories"]!.map((x) => Category.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "phone": phone,
    "image": image,
    "category_id": categoryId,
    "status": status,
    "edit_status": editStatus,
    "view_status": viewStatus,
    "email_verified_at": emailVerifiedAt,
    "latitude": latitude,
    "longitude": longitude,
    "fcm_token": fcmToken,
    "device_info": deviceInfo?.toJson(),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "categories": categories == null ? [] : List<dynamic>.from(categories!.map((x) => x.toJson())),
  };
}

class Category {
  int? id;
  String? name;
  String? image;
  String? alt;
  int? status;
  int? priority;
  DateTime? createdAt;
  DateTime? updatedAt;

  Category({
    this.id,
    this.name,
    this.image,
    this.alt,
    this.status,
    this.priority,
    this.createdAt,
    this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"],
    name: json["name"],
    image: json["image"],
    alt: json["alt"],
    status: json["status"],
    priority: json["priority"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
    "alt": alt,
    "status": status,
    "priority": priority,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class DeviceInfo {
  String? model;
  String? brand;
  String? osType;
  String? osVersion;

  DeviceInfo({
    this.model,
    this.brand,
    this.osType,
    this.osVersion,
  });

  factory DeviceInfo.fromJson(Map<String, dynamic> json) => DeviceInfo(
    model: json["model"],
    brand: json["brand"],
    osType: json["os_type"],
    osVersion: json["os_version"],
  );

  Map<String, dynamic> toJson() => {
    "model": model,
    "brand": brand,
    "os_type": osType,
    "os_version": osVersion,
  };
}