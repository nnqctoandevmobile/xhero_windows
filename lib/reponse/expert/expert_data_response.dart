// To parse this JSON data, do
//
//     final expertDataResponse = expertDataResponseFromJson(jsonString);

import 'dart:convert';

ExpertDataResponse expertDataResponseFromJson(String str) =>
    ExpertDataResponse.fromJson(json.decode(str));

String expertDataResponseToJson(ExpertDataResponse data) =>
    json.encode(data.toJson());

class ExpertDataResponse {
  bool? status;
  ExpertData? data;

  ExpertDataResponse({
    this.status,
    this.data,
  });

  factory ExpertDataResponse.fromJson(Map<String, dynamic> json) =>
      ExpertDataResponse(
        status: json["status"],
        data: ExpertData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
      };
}

class ExpertData {
  List<ExpertModel>? data;
  int? total;

  ExpertData({
    this.data,
    this.total,
  });

  factory ExpertData.fromJson(Map<String, dynamic> json) => ExpertData(
        data: List<ExpertModel>.from(
            json["data"].map((x) => ExpertModel.fromJson(x))),
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data?.map((x) => x.toJson()) ?? []),
        "total": total,
      };
}

class ExpertModel {
  LocationExpert? location;
  String? status;
  String? id;
  String? fullName;
  String? avatar;
  String? title;
  String? profileLink;
  int? exp;
  List<Cert>? certs;
  List<Cert>? certificates;
  double? rate;
  String? createdAt;
  String? updatedAt;
  List<String>? majors;
  int? achievement;
  String? position;
  String? branchEmail;
  String? branchName;
  List<Review>? reviews;
  String? personalPhoneNumber;
  String? branchPhoneNumber;
  String? thumbnail;

  ExpertModel({
    this.location,
    this.status,
    this.id,
    this.fullName,
    this.avatar,
    this.title,
    this.profileLink,
    this.exp,
    this.certs,
    this.certificates,
    this.rate,
    this.createdAt,
    this.updatedAt,
    this.majors,
    this.achievement,
    this.position,
    this.branchEmail,
    this.branchName,
    this.reviews,
    this.personalPhoneNumber,
    this.branchPhoneNumber,
    this.thumbnail,
  });

  factory ExpertModel.fromJson(Map<String, dynamic> json) => ExpertModel(
        location: LocationExpert.fromJson(json["location"]),
        status: json["status"],
        id: json["_id"],
        fullName: json["fullName"],
        avatar: json["avatar"],
        title: json["title"],
        exp: json["exp"],
        profileLink: json["profileLink"],
        certs: json["certs"] == null
            ? []
            : List<Cert>.from(json["certs"].map((x) => Cert.fromJson(x))),
        certificates: json["certificates"] == null
            ? []
            : List<Cert>.from(
                json["certificates"].map((x) => Cert.fromJson(x))),
        rate: json["rate"].toDouble(),
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        majors: List<String>.from(json["majors"].map((x) => x)),
        achievement: json["achievement"],
        position: json["position"],
        branchEmail: json["branchEmail"],
        branchName: json["branchName"],
        personalPhoneNumber: json["personalPhoneNumber"],
        branchPhoneNumber: json["branchPhoneNumber"],
        reviews:
            List<Review>.from(json["reviews"].map((x) => Review.fromJson(x))),
        thumbnail: json["thumbnail"],
      );

  Map<String, dynamic> toJson() => {
        "location": location?.toJson(),
        "status": status,
        "_id": id,
        "fullName": fullName,
        "avatar": avatar,
        "title": title,
        "exp": exp,
        "profileLink": profileLink,
        "certs": List<dynamic>.from(certs?.map((x) => x.toJson()) ?? []),
        "certificates":
            List<dynamic>.from(certificates?.map((x) => x.toJson()) ?? []),
        "rate": rate,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "majors": List<dynamic>.from(majors?.map((x) => x) ?? []),
        "achievement": achievement,
        "position": position,
        "personalPhoneNumber": personalPhoneNumber,
        "branchPhoneNumber": branchPhoneNumber,
        "thumbnail": thumbnail,
      };
}

class Cert {
  String? certName;
  String? certImg;
  String? certDescription;
  String? id;

  Cert({
    this.certName,
    this.certImg,
    this.certDescription,
    this.id,
  });

  factory Cert.fromJson(Map<String, dynamic> json) => Cert(
        certName: json["certName"],
        certImg: json["certImg"],
        certDescription: json["certDescription"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "certName": certName,
        "certImg": certImg,
        "certDescription": certDescription,
        "_id": id,
      };
}

class LocationExpert {
  String? address;
  List<double>? coordinates;
  int? provinceCode;

  LocationExpert({
    this.address,
    this.coordinates,
    this.provinceCode,
  });

  factory LocationExpert.fromJson(Map<String, dynamic> json) => LocationExpert(
        address: json["address"],
        coordinates: List<double>.from(json["coordinates"].map((x) => x)),
        provinceCode: json["provinceCode"],
      );

  Map<String, dynamic> toJson() => {
        "address": address,
        "coordinates": List<double>.from(coordinates?.map((x) => x) ?? []),
        "provinceCode": provinceCode,
      };
}

class Review {
  String? name;
  String? comment;

  Review({
    this.name,
    this.comment,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        name: json["name"],
        comment: json["comment"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "comment": comment,
      };
}
