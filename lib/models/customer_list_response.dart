// To parse this JSON data, do
//
//     final customerListResponse = customerListResponseFromJson(jsonString);

import 'dart:convert';

CustomerListResponse customerListResponseFromJson(String str) => CustomerListResponse.fromJson(json.decode(str));

String customerListResponseToJson(CustomerListResponse data) => json.encode(data.toJson());

class CustomerListResponse {
  bool? status;
  int? code;
  String? message;
  int? totalentries;
  int? currentpage;
  int? totalpage;
  List<CustomerList>? data;

  CustomerListResponse({
    this.status,
    this.code,
    this.message,
    this.totalentries,
    this.currentpage,
    this.totalpage,
    this.data,
  });

  factory CustomerListResponse.fromJson(Map<String, dynamic> json) => CustomerListResponse(
    status: json["status"],
    code: json["code"],
    message: json["message"],
    totalentries: json["totalentries"],
    currentpage: json["currentpage"],
    totalpage: json["totalpage"],
    data: json["data"] == null ? [] : List<CustomerList>.from(json["data"]!.map((x) => CustomerList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "code": code,
    "message": message,
    "totalentries": totalentries,
    "currentpage": currentpage,
    "totalpage": totalpage,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class CustomerList {
  int? id;
  int? userId;
  int? categoryId;
  String? fName;
  String? lName;
  String? spouseName;
  String? gotra;
  String? number;
  DateTime? dob;
  DateTime? doa;
  dynamic dod;
  List<ChildsDetail>? childsDetail;
  List<dynamic>? ancestorsDetail;
  String? serviceDuration;
  DateTime? serviceEnd;
  DateTime? createdAt;
  DateTime? updatedAt;
  Category? category;

  CustomerList({
    this.id,
    this.userId,
    this.categoryId,
    this.fName,
    this.lName,
    this.spouseName,
    this.gotra,
    this.number,
    this.dob,
    this.doa,
    this.dod,
    this.childsDetail,
    this.ancestorsDetail,
    this.serviceDuration,
    this.serviceEnd,
    this.createdAt,
    this.updatedAt,
    this.category,
  });

  factory CustomerList.fromJson(Map<String, dynamic> json) => CustomerList(
    id: json["id"],
    userId: json["user_id"],
    categoryId: json["category_id"],
    fName: json["f_name"],
    lName: json["l_name"],
    spouseName: json["spouse_name"],
    gotra: json["gotra"],
    number: json["number"],
    dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
    doa: json["doa"] == null ? null : DateTime.parse(json["doa"]),
    dod: json["dod"],
    childsDetail: json["childs_detail"] == null ? [] : List<ChildsDetail>.from(json["childs_detail"]!.map((x) => ChildsDetail.fromJson(x))),
    ancestorsDetail: json["ancestors_detail"] == null ? [] : List<dynamic>.from(json["ancestors_detail"]!.map((x) => x)),
    serviceDuration: json["service_duration"],
    serviceEnd: json["service_end"] == null ? null : DateTime.parse(json["service_end"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    category: json["category"] == null ? null : Category.fromJson(json["category"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "category_id": categoryId,
    "f_name": fName,
    "l_name": lName,
    "spouse_name": spouseName,
    "gotra": gotra,
    "number": number,
    "dob": "${dob!.year.toString().padLeft(4, '0')}-${dob!.month.toString().padLeft(2, '0')}-${dob!.day.toString().padLeft(2, '0')}",
    "doa": "${doa!.year.toString().padLeft(4, '0')}-${doa!.month.toString().padLeft(2, '0')}-${doa!.day.toString().padLeft(2, '0')}",
    "dod": dod,
    "childs_detail": childsDetail == null ? [] : List<dynamic>.from(childsDetail!.map((x) => x.toJson())),
    "ancestors_detail": ancestorsDetail == null ? [] : List<dynamic>.from(ancestorsDetail!.map((x) => x)),
    "service_duration": serviceDuration,
    "service_end": "${serviceEnd!.year.toString().padLeft(4, '0')}-${serviceEnd!.month.toString().padLeft(2, '0')}-${serviceEnd!.day.toString().padLeft(2, '0')}",
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "category": category?.toJson(),
  };
}

class Category {
  int? id;
  String? name;

  Category({
    this.id,
    this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}

class ChildsDetail {
  String? name;
  String? dateOfBirth;

  ChildsDetail({
    this.name,
    this.dateOfBirth,
  });

  factory ChildsDetail.fromJson(Map<String, dynamic> json) => ChildsDetail(
    name: json["name"],
    dateOfBirth: json["date_of_birth"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "date_of_birth": dateOfBirth,
  };
}
