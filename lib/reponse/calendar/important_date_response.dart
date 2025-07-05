// To parse this JSON data, do
//
//     final importantDateResponse = importantDateResponseFromJson(jsonString);

import 'dart:convert';

ImportantDateResponse importantDateResponseFromJson(String str) =>
    ImportantDateResponse.fromJson(json.decode(str));

String importantDateResponseToJson(ImportantDateResponse data) =>
    json.encode(data.toJson());

class ImportantDateResponse {
  bool? status;
  List<ImportantData>? data;

  ImportantDateResponse({
    this.status,
    this.data,
  });

  factory ImportantDateResponse.fromJson(Map<String, dynamic> json) =>
      ImportantDateResponse(
        status: json["status"],
        data: List<ImportantData>.from(
            json["data"].map((x) => ImportantData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data?.map((x) => x.toJson()) ?? []),
      };
}

class ImportantData {
  List<Description>? descriptions;
  String? id;
  String? key;
  String? code;
  String? name;
  String? parentId;
  int? order;
  String? createdAt;
  String? updatedAt;
  int? v;

  ImportantData({
    this.descriptions,
    this.id,
    this.key,
    this.code,
    this.name,
    this.parentId,
    this.order,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory ImportantData.fromJson(Map<String, dynamic> json) => ImportantData(
        descriptions: List<Description>.from(
            json["descriptions"].map((x) => Description.fromJson(x))),
        id: json["_id"],
        key: json["key"],
        code: json["code"],
        name: json["name"],
        parentId: json["parentId"],
        order: json["order"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "descriptions":
            List<dynamic>.from(descriptions?.map((x) => x.toJson()) ?? []),
        "_id": id,
        "key": key,
        "code": code,
        "name": name,
        "parentId": parentId,
        "order": order,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "__v": v,
      };
}

class Description {
  String? code;
  String? name;

  Description({
    this.code,
    this.name,
  });

  factory Description.fromJson(Map<String, dynamic> json) => Description(
        code: json["code"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "name": name,
      };
}
