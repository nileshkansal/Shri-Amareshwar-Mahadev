
class PhoneNumber {
  final String number;
  final String mobileType;
  final String belongsTo;

  PhoneNumber({required this.number, required this.mobileType, required this.belongsTo});

  factory PhoneNumber.fromJson(Map<String, dynamic> json) {
    return PhoneNumber(number: json['number'], mobileType: json['platform'], belongsTo: json['blong_to']);
  }

  Map<String, dynamic> toJson() {
    return {"platform": mobileType, "blong_to": belongsTo,"number": number};
  }
}

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
  final DateTime? dateOfDeath;
  final String status;

  Ancestor({required this.name, required this.dateOfBirth, required this.dateOfDeath, required this.status});

  factory Ancestor.fromJson(Map<String, dynamic> json) {
    return Ancestor(
      name: json['name'],
      dateOfBirth: DateTime.parse(json['date_of_birth']),
      dateOfDeath: json['date_of_death'] != null && json['date_of_death'].toString().isNotEmpty ? DateTime.parse(json['date_of_death']) : null,
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'date_of_birth': dateOfBirth.toIso8601String().split('T')[0].replaceAll('-', '/'),
      'date_of_death': dateOfDeath != null ? dateOfDeath!.toIso8601String().split('T')[0].replaceAll('-', '/') : null,
      'status': status,
    };
  }
}

class CustomerModel {
  final String? id;
  final String firstName;
  final String lastName;
  final String gotra;
  final String address;
  final DateTime dateOfBirth;
  final DateTime? dateOfAnniversary;
  final DateTime? dateOfDeath;
  final List<Child> children;
  final List<Ancestor> ancestors;
  final String serviceDuration;
  final DateTime serviceEndDate;
  final int categoryId;
  final List<Child> spouseDetail;
  final List<PhoneNumber> number;
  final int price;
  final int dueAmount;

  CustomerModel({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.gotra,
    required this.address,
    required this.dateOfBirth,
    this.dateOfAnniversary,
    this.dateOfDeath,
    required this.children,
    required this.ancestors,
    required this.serviceDuration,
    required this.serviceEndDate,
    required this.categoryId,
    required this.number,
    required this.spouseDetail,
    required this.dueAmount,
    required this.price,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'],
      firstName: json['f_name'],
      lastName: json['l_name'],
      gotra: json['gotra'],
      address: json['address'],
      dateOfBirth: DateTime.parse(json['date_of_birth']),
      dateOfAnniversary: json['date_of_anniversary'] != null ? DateTime.parse(json['date_of_anniversary']) : null,
      dateOfDeath: json['date_of_death'] != null ? DateTime.parse(json['date_of_death']) : null,
      number: (json['number']as List).map((child) => PhoneNumber.fromJson(child)).toList(),
      children: (json['children_detail'] as List).map((child) => Child.fromJson(child)).toList(),
      spouseDetail: (json['spouse_detail'] as List).map((child) => Child.fromJson(child)).toList(),
      ancestors: (json['ancestors_detail'] as List).map((ancestor) => Ancestor.fromJson(ancestor)).toList(),
      serviceDuration: json['service_duration'],
      serviceEndDate: DateTime.parse(json['service_end']),
      categoryId: json['category'],
      dueAmount: json['due_amount'],
      price: json['price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': categoryId,
      'f_name': firstName,
      'l_name': lastName,
      'gotra': gotra,
      'address': address,
      'date_of_birth': dateOfBirth.toIso8601String().split('T')[0].replaceAll('-', '/'),
      'date_of_anniversary': dateOfAnniversary?.toIso8601String().split('T')[0].replaceAll('-', '/'),
      'date_of_death': dateOfDeath?.toIso8601String().split('T')[0].replaceAll('-', '/'),
      'number': number.map((child) => child.toJson()).toList(),
      'children_detail': children.map((child) => child.toJson()).toList(),
      'ancestors_detail': ancestors.map((ancestor) => ancestor.toJson()).toList(),
      'service_duration': serviceDuration.toString().split('.').last,
      'service_end': serviceEndDate.toIso8601String().split('T')[0].replaceAll('-', '/'),
      'spouse_detail': spouseDetail,
      'price': price,
      'due_amount': dueAmount,
    };
  }

  String get fullName => '$firstName $lastName';
}
