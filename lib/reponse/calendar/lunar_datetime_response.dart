// To parse this JSON data, do
//
//     final lunarDatetimeResponse = lunarDatetimeResponseFromJson(jsonString);

import 'dart:convert';

LunarDatetimeResponse lunarDatetimeResponseFromJson(String str) =>
    LunarDatetimeResponse.fromJson(json.decode(str));

String lunarDatetimeResponseToJson(LunarDatetimeResponse data) =>
    json.encode(data.toJson());

class LunarDatetimeResponse {
  bool? status;
  LunarDatetimeData? data;

  LunarDatetimeResponse({
    this.status,
    this.data,
  });

  factory LunarDatetimeResponse.fromJson(Map<String, dynamic> json) =>
      LunarDatetimeResponse(
        status: json["status"],
        data: LunarDatetimeData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
      };
}

class LunarDatetimeData {
  int? daySolar;
  int? monthSolar;
  int? yearSolar;
  int? dayLunar;
  int? monthLunar;
  int? yearLunar;
  String? ngayCan;
  String? ngayChi;
  String? thangCan;
  String? thangChi;
  String? namCan;
  String? namChi;
  String? gioCan;
  String? gioChi;

  LunarDatetimeData({
    this.daySolar,
    this.monthSolar,
    this.yearSolar,
    this.dayLunar,
    this.monthLunar,
    this.yearLunar,
    this.ngayCan,
    this.ngayChi,
    this.thangCan,
    this.thangChi,
    this.namCan,
    this.namChi,
    this.gioCan,
    this.gioChi,
  });

  factory LunarDatetimeData.fromJson(Map<String, dynamic> json) =>
      LunarDatetimeData(
        daySolar: json["daySolar"],
        monthSolar: json["monthSolar"],
        yearSolar: json["yearSolar"],
        dayLunar: json["dayLunar"],
        monthLunar: json["monthLunar"],
        yearLunar: json["yearLunar"],
        ngayCan: json["ngayCan"],
        ngayChi: json["ngayChi"],
        thangCan: json["thangCan"],
        thangChi: json["thangChi"],
        namCan: json["namCan"],
        namChi: json["namChi"],
        gioCan: json["gioCan"],
        gioChi: json["gioChi"],
      );

  Map<String, dynamic> toJson() => {
        "daySolar": daySolar,
        "monthSolar": monthSolar,
        "yearSolar": yearSolar,
        "dayLunar": dayLunar,
        "monthLunar": monthLunar,
        "yearLunar": yearLunar,
        "ngayCan": ngayCan,
        "ngayChi": ngayChi,
        "thangCan": thangCan,
        "thangChi": thangChi,
        "namCan": namCan,
        "namChi": namChi,
        "gioCan": gioCan,
        "gioChi": gioChi,
      };
}
