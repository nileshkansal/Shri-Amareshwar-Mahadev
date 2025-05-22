import 'package:shri_amareshwar_mahadev/controllers/customer_provider.dart';

class Child {
  final String name;
  final DateTime dateOfBirth;

  Child({required this.name, required this.dateOfBirth});

  factory Child.fromJson(Map<String, dynamic> json) {
    return Child(name: json['name'], dateOfBirth: DateTime.parse(json['date_of_birth']));
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'date_of_birth': dateOfBirth.toIso8601String().split('T')[0].replaceAll('-', '/')};
  }
}

class Ancestor {
  final String name;
  final DateTime dateOfBirth;

  Ancestor({required this.name, required this.dateOfBirth});

  factory Ancestor.fromJson(Map<String, dynamic> json) {
    return Ancestor(name: json['name'], dateOfBirth: DateTime.parse(json['date_of_birth']));
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'date_of_birth': dateOfBirth.toIso8601String().split('T')[0].replaceAll('-', '/')};
  }
}

class CustomerModel {
  final String? id;
  final String firstName;
  final String lastName;
  final String spouseName;
  final String gotra;
  final String address;
  final DateTime dateOfBirth;
  final DateTime? dateOfAnniversary;
  final DateTime? dateOfDeath;
  final String phoneNumber;
  final List<Child> children;
  final List<Ancestor> ancestors;
  final String serviceDuration;
  final DateTime serviceEndDate;
  final int categoryId;

  CustomerModel({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.spouseName,
    required this.gotra,
    required this.address,
    required this.dateOfBirth,
    this.dateOfAnniversary,
    this.dateOfDeath,
    required this.phoneNumber,
    required this.children,
    required this.ancestors,
    required this.serviceDuration,
    required this.serviceEndDate,
    required this.categoryId,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'],
      firstName: json['f_name'],
      lastName: json['l_name'],
      spouseName: json['spouse_name'],
      gotra: json['gotra'],
      address: json['address'],
      dateOfBirth: DateTime.parse(json['date_of_birth']),
      dateOfAnniversary: json['date_of_anniversary'] != null ? DateTime.parse(json['date_of_anniversary']) : null,
      dateOfDeath: json['date_of_death'] != null ? DateTime.parse(json['date_of_death']) : null,
      phoneNumber: json['number'] ?? '',
      children: (json['children_detail'] as List).map((child) => Child.fromJson(child)).toList(),
      ancestors: (json['ancestors_detail'] as List).map((ancestor) => Ancestor.fromJson(ancestor)).toList(),
      serviceDuration: json['service_duration'],
      serviceEndDate: DateTime.parse(json['service_end']),
      categoryId: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': categoryId,
      'f_name': firstName,
      'l_name': lastName,
      'spouse_name': spouseName,
      'gotra': gotra,
      'address': address,
      'date_of_birth': dateOfBirth.toIso8601String().split('T')[0].replaceAll('-', '/'),
      'date_of_anniversary': dateOfAnniversary?.toIso8601String().split('T')[0].replaceAll('-', '/'),
      'date_of_death': dateOfDeath?.toIso8601String().split('T')[0].replaceAll('-', '/'),
      'number': phoneNumber,
      'children_detail': children.map((child) => child.toJson()).toList(),
      'ancestors_detail': ancestors.map((ancestor) => ancestor.toJson()).toList(),
      'service_duration': serviceDuration.toString().split('.').last,
      'service_end': serviceEndDate.toIso8601String().split('T')[0].replaceAll('-', '/'),
    };
  }

  String get fullName => '$firstName $lastName';
}
