import 'dart:convert';

CategoriesDataResponse categoriesDataResponseFromJson(String str) =>
    CategoriesDataResponse.fromJson(json.decode(str));

String categoriesDataResponseToJson(CategoriesDataResponse data) =>
    json.encode(data.toJson());

class CategoriesDataResponse {
  bool? status;
  List<Categories>? data;

  CategoriesDataResponse({
    this.status,
    this.data,
  });

  factory CategoriesDataResponse.fromJson(Map<String, dynamic> json) =>
      CategoriesDataResponse(
        status: json["status"],
        data: List<Categories>.from(
            json["data"].map((x) => Categories.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data?.map((x) => x.toJson()) ?? []),
      };
}

class Categories {
  List<Descriptions>? descriptions;
  String? id;
  String? key;
  String? name;
  String? parentId;
  int? order;
  String? createdAt;
  String? updatedAt;
  int? v;

  Categories({
    this.descriptions,
    this.id,
    this.key,
    this.name,
    this.parentId,
    this.order,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Categories.fromJson(Map<String, dynamic> json) => Categories(
        descriptions: List<Descriptions>.from(
            json["descriptions"].map((x) => Descriptions.fromJson(x))),
        id: json["_id"],
        key: json["key"],
        name: json["name"],
        parentId: json["parentId"],
        order: json["order"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "descriptions": List<dynamic>.from(descriptions?.map((x) => x) ?? []),
        "_id": id,
        "key": key,
        "name": name,
        "parentId": parentId,
        "order": order,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "__v": v,
      };
}

class Descriptions {
  String title;
  String content;

  Descriptions({
    required this.title,
    required this.content,
  });

  factory Descriptions.fromJson(Map<String, dynamic> json) => Descriptions(
        title: json["title"],
        content: json["content"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "content": content,
      };
}
