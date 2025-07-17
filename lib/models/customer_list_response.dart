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
  dynamic currentpage;
  dynamic totalpage;
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
  String? gotra;
  List<Number>? number;
  dynamic alternateNumber;
  String? image;
  int? status;
  String? address;
  DateTime? dob;
  DateTime? doa;
  String? price;
  String? dueAmount;
  List<Detail>? childsDetail;
  List<Detail>? spouseDetail;
  List<AncestorsDetail>? ancestorsDetail;
  String? serviceDuration;
  DateTime? serviceEnd;
  dynamic callerId;
  dynamic followUp;
  dynamic callingRemark;
  dynamic lastCall;
  DateTime? createdAt;
  DateTime? updatedAt;
  Category? category;

  CustomerList({
    this.id,
    this.userId,
    this.categoryId,
    this.fName,
    this.lName,
    this.gotra,
    this.number,
    this.alternateNumber,
    this.image,
    this.status,
    this.address,
    this.dob,
    this.doa,
    this.price,
    this.dueAmount,
    this.childsDetail,
    this.spouseDetail,
    this.ancestorsDetail,
    this.serviceDuration,
    this.serviceEnd,
    this.callerId,
    this.followUp,
    this.callingRemark,
    this.lastCall,
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
    gotra: json["gotra"],
    number: json["number"] == null ? [] : List<Number>.from(json["number"]!.map((x) => Number.fromJson(x))),
    alternateNumber: json["alternate_number"],
    image: json["image"],
    status: json["status"],
    address: json["address"],
    dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
    doa: json["doa"] == null ? null : DateTime.parse(json["doa"]),
    price: json["price"],
    dueAmount: json["due_amount"],
    childsDetail: json["childs_detail"] == null ? [] : List<Detail>.from(json["childs_detail"]!.map((x) => Detail.fromJson(x))),
    spouseDetail: json["spouse_detail"] == null ? [] : List<Detail>.from(json["spouse_detail"]!.map((x) => Detail.fromJson(x))),
    ancestorsDetail: json["ancestors_detail"] == null ? [] : List<AncestorsDetail>.from(json["ancestors_detail"]!.map((x) => AncestorsDetail.fromJson(x))),
    serviceDuration: json["service_duration"],
    serviceEnd: json["service_end"] == null ? null : DateTime.parse(json["service_end"]),
    callerId: json["caller_id"],
    followUp: json["follow_up"],
    callingRemark: json["calling_remark"],
    lastCall: json["last_call"],
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
    "gotra": gotra,
    "number": number == null ? [] : List<dynamic>.from(number!.map((x) => x.toJson())),
    "alternate_number": alternateNumber,
    "image": image,
    "status": status,
    "address": address,
    "dob": "${dob!.year.toString().padLeft(4, '0')}-${dob!.month.toString().padLeft(2, '0')}-${dob!.day.toString().padLeft(2, '0')}",
    "doa": "${doa!.year.toString().padLeft(4, '0')}-${doa!.month.toString().padLeft(2, '0')}-${doa!.day.toString().padLeft(2, '0')}",
    "price": price,
    "due_amount": dueAmount,
    "childs_detail": childsDetail == null ? [] : List<dynamic>.from(childsDetail!.map((x) => x.toJson())),
    "spouse_detail": spouseDetail == null ? [] : List<dynamic>.from(spouseDetail!.map((x) => x.toJson())),
    "ancestors_detail": ancestorsDetail == null ? [] : List<dynamic>.from(ancestorsDetail!.map((x) => x.toJson())),
    "service_duration": serviceDuration,
    "service_end": "${serviceEnd!.year.toString().padLeft(4, '0')}-${serviceEnd!.month.toString().padLeft(2, '0')}-${serviceEnd!.day.toString().padLeft(2, '0')}",
    "caller_id": callerId,
    "follow_up": followUp,
    "calling_remark": callingRemark,
    "last_call": lastCall,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "category": category?.toJson(),
  };
}

class AncestorsDetail {
  String? name;
  String? dateOfBirth;
  DateTime? dateOfDeath;
  String? status;

  AncestorsDetail({
    this.name,
    this.dateOfBirth,
    this.dateOfDeath,
    this.status,
  });

  factory AncestorsDetail.fromJson(Map<String, dynamic> json) => AncestorsDetail(
    name: json["name"],
    dateOfBirth: json["date_of_birth"],
    dateOfDeath: json["date_of_death"] == null ? null : DateTime.parse(json["date_of_death"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "date_of_birth": dateOfBirth,
    "date_of_death": "${dateOfDeath!.year.toString().padLeft(4, '0')}-${dateOfDeath!.month.toString().padLeft(2, '0')}-${dateOfDeath!.day.toString().padLeft(2, '0')}",
    "status": status,
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

class Detail {
  String? name;
  DateTime? dateOfBirth;

  Detail({
    this.name,
    this.dateOfBirth,
  });

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
    name: json["name"],
    dateOfBirth: json["date_of_birth"] == null ? null : DateTime.parse(json["date_of_birth"]),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "date_of_birth": "${dateOfBirth!.year.toString().padLeft(4, '0')}-${dateOfBirth!.month.toString().padLeft(2, '0')}-${dateOfBirth!.day.toString().padLeft(2, '0')}",
  };
}

class Number {
  Platform? platform;
  BlongTo? blongTo;
  String? number;

  Number({
    this.platform,
    this.blongTo,
    this.number,
  });

  factory Number.fromJson(Map<String, dynamic> json) => Number(
    platform: platformValues.map[json["platform"]]!,
    blongTo: blongToValues.map[json["blong_to"]]!,
    number: json["number"],
  );

  Map<String, dynamic> toJson() => {
    "platform": platformValues.reverse[platform],
    "blong_to": blongToValues.reverse[blongTo],
    "number": number,
  };
}

enum BlongTo {
  CHILD,
  PARENT,
  SELF,
  SPOUSE
}

final blongToValues = EnumValues({
  "child": BlongTo.CHILD,
  "parent": BlongTo.PARENT,
  "self": BlongTo.SELF,
  "spouse": BlongTo.SPOUSE
});

enum Platform {
  CALL,
  SMS,
  TELEGRAM,
  WHATSAPP
}

final platformValues = EnumValues({
  "call": Platform.CALL,
  "sms": Platform.SMS,
  "telegram": Platform.TELEGRAM,
  "whatsapp": Platform.WHATSAPP
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
