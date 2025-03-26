import 'category_model.dart';

class UserModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String? image;
  final String categoryId;
  final int status;
  final int editStatus;
  final int viewStatus;
  final String? emailVerifiedAt;
  final String latitude;
  final String longitude;
  final String fcmToken;
  final String deviceInfo;
  final String createdAt;
  final String updatedAt;
  final List<CategoryModel> categories;
  final String? token;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.image,
    required this.categoryId,
    required this.status,
    required this.editStatus,
    required this.viewStatus,
    this.emailVerifiedAt,
    required this.latitude,
    required this.longitude,
    required this.fcmToken,
    required this.deviceInfo,
    required this.createdAt,
    required this.updatedAt,
    required this.categories,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    var categoriesList = <CategoryModel>[];
    if (json['user']?['categories'] != null) {
      categoriesList = (json['user']['categories'] as List)
          .map((category) => CategoryModel.fromJson(category))
          .toList();
    }

    final userData = json['user'] ?? json;
    
    return UserModel(
      id: userData['id'] ?? 0,
      name: userData['name'] ?? '',
      email: userData['email'] ?? '',
      phone: userData['phone'] ?? '',
      image: userData['image'],
      categoryId: userData['category_id']?.toString() ?? '',
      status: userData['status'] ?? 0,
      editStatus: userData['edit_status'] ?? 0,
      viewStatus: userData['view_status'] ?? 0,
      emailVerifiedAt: userData['email_verified_at'],
      latitude: userData['latitude'] ?? '',
      longitude: userData['longitude'] ?? '',
      fcmToken: userData['fcm_token'] ?? '',
      deviceInfo: userData['device_info'] ?? '',
      createdAt: userData['created_at'] ?? '',
      updatedAt: userData['updated_at'] ?? '',
      categories: categoriesList,
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'image': image,
      'category_id': categoryId,
      'status': status,
      'edit_status': editStatus,
      'view_status': viewStatus,
      'email_verified_at': emailVerifiedAt,
      'latitude': latitude,
      'longitude': longitude,
      'fcm_token': fcmToken,
      'device_info': deviceInfo,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'categories': categories.map((category) => category.toJson()).toList(),
      'token': token,
    };
  }
} 