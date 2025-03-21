class Child {
  final String name;
  final DateTime dateOfBirth;

  Child({
    required this.name,
    required this.dateOfBirth,
  });

  factory Child.fromJson(Map<String, dynamic> json) {
    return Child(
      name: json['name'],
      dateOfBirth: DateTime.parse(json['date_of_birth']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'date_of_birth': dateOfBirth.toIso8601String(),
    };
  }
}

class Ancestor {
  final String name;
  final DateTime deathAnniversary;

  Ancestor({
    required this.name,
    required this.deathAnniversary,
  });

  factory Ancestor.fromJson(Map<String, dynamic> json) {
    return Ancestor(
      name: json['name'],
      deathAnniversary: DateTime.parse(json['death_anniversary']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'death_anniversary': deathAnniversary.toIso8601String(),
    };
  }
}

enum ServiceDuration {
  monthly,
  quarterly,
  halfYearly,
  yearly,
}

class CustomerModel {
  final String id;
  final String firstName;
  final String lastName;
  final String spouseName;
  final String gotra;
  final DateTime dateOfBirth;
  final DateTime? dateOfAnniversary;
  final List<Child> children;
  final List<Ancestor> ancestors;
  final ServiceDuration serviceDuration;
  final DateTime serviceDurationStartDate;
  final DateTime serviceDurationEndDate;
  final String selectedService;

  CustomerModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.spouseName,
    required this.gotra,
    required this.dateOfBirth,
    this.dateOfAnniversary,
    required this.children,
    required this.ancestors,
    required this.serviceDuration,
    required this.serviceDurationStartDate,
    required this.serviceDurationEndDate,
    required this.selectedService,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      spouseName: json['spouse_name'],
      gotra: json['gotra'],
      dateOfBirth: DateTime.parse(json['date_of_birth']),
      dateOfAnniversary: json['date_of_anniversary'] != null
          ? DateTime.parse(json['date_of_anniversary'])
          : null,
      children: (json['children'] as List)
          .map((child) => Child.fromJson(child))
          .toList(),
      ancestors: (json['ancestors'] as List)
          .map((ancestor) => Ancestor.fromJson(ancestor))
          .toList(),
      serviceDuration: ServiceDuration.values.firstWhere(
          (e) => e.toString() == 'ServiceDuration.${json['service_duration']}'),
      serviceDurationStartDate:
          DateTime.parse(json['service_duration_start_date']),
      serviceDurationEndDate: DateTime.parse(json['service_duration_end_date']),
      selectedService: json['selected_service'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'spouse_name': spouseName,
      'gotra': gotra,
      'date_of_birth': dateOfBirth.toIso8601String(),
      'date_of_anniversary': dateOfAnniversary?.toIso8601String(),
      'children': children.map((child) => child.toJson()).toList(),
      'ancestors': ancestors.map((ancestor) => ancestor.toJson()).toList(),
      'service_duration': serviceDuration.toString().split('.').last,
      'service_duration_start_date': serviceDurationStartDate.toIso8601String(),
      'service_duration_end_date': serviceDurationEndDate.toIso8601String(),
      'selected_service': selectedService,
    };
  }

  String get fullName => '$firstName $lastName';
} 