class CategoryModel {
  final int id;
  final String name;
  final String image;
  final String alt;
  final int status;
  final int priority;
  final String createdAt;
  final String updatedAt;

  CategoryModel({
    required this.id,
    required this.name,
    required this.image,
    required this.alt,
    required this.status,
    required this.priority,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      alt: json['alt'] ?? '',
      status: json['status'] ?? 0,
      priority: json['priority'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'alt': alt,
      'status': status,
      'priority': priority,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
} 