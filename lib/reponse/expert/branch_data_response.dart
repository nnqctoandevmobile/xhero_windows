// To parse this JSON data, do
//
//     final listBranchResponse = listBranchResponseFromJson(jsonString);

import 'dart:convert';

BranchesResponse listBranchResponseFromJson(String str) =>
    BranchesResponse.fromJson(json.decode(str));

String listBranchResponseToJson(BranchesResponse data) =>
    json.encode(data.toJson());

class BranchesResponse {
  Branches? data;
  bool? status;

  BranchesResponse({
    this.data,
    this.status,
  });

  factory BranchesResponse.fromJson(Map<String, dynamic> json) =>
      BranchesResponse(
        data: Branches.fromJson(json["data"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
        "status": status,
      };
}

class Branches {
  List<BranchModel>? data;
  int? total;

  Branches({
    this.data,
    this.total,
  });

  factory Branches.fromJson(Map<String, dynamic> json) => Branches(
        data: List<BranchModel>.from(
            json["data"].map((x) => BranchModel.fromJson(x))),
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data?.map((x) => x.toJson()) ?? []),
        "total": total,
      };
}

class BranchModel {
  Location? location;
  String? id;
  String? name;
  String? phoneNumber;
  String? email;
  String? imageUrl;
  String? thumbnail;
  List<String>? branchImages;
  int? v;

  BranchModel({
    this.location,
    this.id,
    this.name,
    this.phoneNumber,
    this.email,
    this.imageUrl,
    this.thumbnail,
    this.branchImages,
    this.v,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) => BranchModel(
        location: json["location"] != null
            ? Location.fromJson(json["location"])
            : null,
        id: json["_id"] ?? '',
        name: json["name"] ?? '',
        phoneNumber: json["phoneNumber"] ?? '',
        email: json["email"] ?? '',
        imageUrl: json["imageUrl"] ?? '',
        branchImages: json["branchImages"] != null
            ? List<String>.from(json["branchImages"].map((x) => x))
            : [],
        thumbnail: json["thumbnail"] ?? '',
        v: json["__v"] ?? 0,
      );
  Map<String, dynamic> toJson() => {
        "location": location?.toJson(),
        "_id": id,
        "name": name,
        "phoneNumber": phoneNumber,
        "email": email,
        "imageUrl": imageUrl,
        "thumbnail": thumbnail,
        "__v": v,
      };
}

class Location {
  List<dynamic>? coordinates;
  String? address;

  Location({
    this.coordinates,
    this.address,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        coordinates:
            List<dynamic>.from(json["coordinates"].map((x) => x.toDouble())),
        address: json["address"],
      );

  Map<String, dynamic> toJson() => {
        "coordinates": List<dynamic>.from(coordinates?.map((x) => x) ?? []),
        "address": address,
      };
}
