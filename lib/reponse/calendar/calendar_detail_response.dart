// To parse this JSON data, do
//
//     final calendarDetailResponse = calendarDetailResponseFromJson(jsonString);

import 'dart:convert';

CalendarDetailResponse calendarDetailResponseFromJson(String str) =>
    CalendarDetailResponse.fromJson(json.decode(str));

String calendarDetailResponseToJson(CalendarDetailResponse data) =>
    json.encode(data.toJson());

class CalendarDetailResponse {
  bool? status;
  DetailsOfDayModel? data;

  CalendarDetailResponse({
    this.status,
    this.data,
  });

  factory CalendarDetailResponse.fromJson(Map<String, dynamic> json) =>
      CalendarDetailResponse(
        status: json["status"],
        data: DetailsOfDayModel.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
      };
}

class DetailsOfDayModel {
  int? daySolar;
  String? gioCan;
  List<String>? arrGioCan;
  String? hanhNgay;
  String? hanhThang;
  bool? isLeap;
  int? monthSolar;
  int? yearSolar;
  int? dayLunar;
  int? monthLunar;
  int? yearLunar;
  int? daysTotalInLunar;
  String? ngayCan;
  String? ngayChi;
  String? thangCan;
  String? thangChi;
  String? namCan;
  String? namChi;
  String? truc;
  String? tu;
  String? weekday;
  List<Gio>? gioHoangDao;
  Gio? gioThoTu;
  Gio? gioSatChu;
  List<TuoiXung>? tuoiXungNgay;
  List<TuoiXung>? tuoiXungThang;
  String? tiet;
  List<String>? bachKy;
  bool? isHaveEvents;
  List<Event>? events;
  bool? isHoangDaoDay;

  DetailsOfDayModel({
    this.daySolar,
    this.gioCan,
    this.arrGioCan,
    this.hanhNgay,
    this.hanhThang,
    this.isLeap,
    this.monthSolar,
    this.yearSolar,
    this.dayLunar,
    this.monthLunar,
    this.yearLunar,
    this.daysTotalInLunar,
    this.ngayCan,
    this.ngayChi,
    this.thangCan,
    this.thangChi,
    this.namCan,
    this.namChi,
    this.truc,
    this.tu,
    this.weekday,
    this.gioHoangDao,
    this.gioThoTu,
    this.gioSatChu,
    this.tuoiXungNgay,
    this.tuoiXungThang,
    this.tiet,
    this.bachKy,
    this.isHaveEvents,
    this.events,
    this.isHoangDaoDay,
  });

  factory DetailsOfDayModel.fromJson(Map<String, dynamic> json) =>
      DetailsOfDayModel(
        daySolar: json["daySolar"],
        gioCan: json["gioCan"],
        arrGioCan: List<String>.from(json["arrGioCan"].map((x) => x)),
        hanhNgay: json["hanhNgay"],
        hanhThang: json["hanhThang"],
        isLeap: json["isLeap"],
        monthSolar: json["monthSolar"],
        yearSolar: json["yearSolar"],
        dayLunar: json["dayLunar"],
        monthLunar: json["monthLunar"],
        yearLunar: json["yearLunar"],
        daysTotalInLunar: json["daysTotalInLunar"],
        ngayCan: json["ngayCan"],
        ngayChi: json["ngayChi"],
        thangCan: json["thangCan"],
        thangChi: json["thangChi"],
        namCan: json["namCan"],
        namChi: json["namChi"],
        truc: json["truc"],
        tu: json["tu"],
        weekday: json["weekday"],
        gioHoangDao:
            List<Gio>.from(json["gioHoangDao"].map((x) => Gio.fromJson(x))),
        gioThoTu: Gio.fromJson(json["gioThoTu"]),
        gioSatChu: Gio.fromJson(json["gioSatChu"]),
        tuoiXungNgay: List<TuoiXung>.from(
            json["tuoiXungNgay"].map((x) => TuoiXung.fromJson(x))),
        tuoiXungThang: List<TuoiXung>.from(
            json["tuoiXungThang"].map((x) => TuoiXung.fromJson(x))),
        tiet: json["tiet"],
        bachKy: List<String>.from(json["bachKy"].map((x) => x)),
        isHaveEvents: json["isHaveEvents"],
        events: List<Event>.from(json["events"].map((x) => Event.fromJson(x))),
        isHoangDaoDay: json["isHoangDaoDay"],
      );

  Map<String, dynamic> toJson() => {
        "daySolar": daySolar,
        "gioCan": gioCan,
        "arrGioCan": List<dynamic>.from(arrGioCan?.map((x) => x) ?? []),
        "hanhNgay": hanhNgay,
        "hanhThang": hanhThang,
        "isLeap": isLeap,
        "monthSolar": monthSolar,
        "yearSolar": yearSolar,
        "dayLunar": dayLunar,
        "monthLunar": monthLunar,
        "yearLunar": yearLunar,
        "daysTotalInLunar": daysTotalInLunar,
        "ngayCan": ngayCan,
        "ngayChi": ngayChi,
        "thangCan": thangCan,
        "thangChi": thangChi,
        "namCan": namCan,
        "namChi": namChi,
        "truc": truc,
        "tu": tu,
        "weekday": weekday,
        "gioHoangDao":
            List<dynamic>.from(gioHoangDao?.map((x) => x.toJson()) ?? []),
        "gioThoTu": gioThoTu?.toJson(),
        "gioSatChu": gioSatChu?.toJson(),
        "tuoiXungNgay":
            List<dynamic>.from(tuoiXungNgay?.map((x) => x.toJson()) ?? []),
        "tuoiXungThang":
            List<dynamic>.from(tuoiXungThang?.map((x) => x.toJson()) ?? []),
        "tiet": tiet,
        "bachKy": List<dynamic>.from(bachKy?.map((x) => x) ?? []),
        "isHaveEvents": isHaveEvents,
        "events": List<dynamic>.from(events?.map((x) => x.toJson()) ?? []),
        "isHoangDaoDay": isHoangDaoDay,
      };
}

class Event {
  String? id;
  String? name;
  String? date;
  String? type;
  String? time;
  bool? isLunarHoliday;
  String? solarDate;
  String? lunarDate;
  int? remainingDays;

  Event({
    this.id,
    this.name,
    this.date,
    this.type,
    this.time,
    this.isLunarHoliday,
    this.solarDate,
    this.lunarDate,
    this.remainingDays,
  });

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        id: json["_id"],
        name: json["name"],
        date: json["date"],
        type: json["type"],
        time: json["time"],
        isLunarHoliday: json["isLunarHoliday"],
        solarDate: json["solarDate"],
        lunarDate: json["lunarDate"],
        remainingDays: json["remainingDays"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "date": date,
        "type": type,
        "time": time,
        "isLunarHoliday": isLunarHoliday,
        "solarDate": solarDate,
        "lunarDate": lunarDate,
        "remainingDays": remainingDays,
      };
}

class Gio {
  String? name;
  int? start;
  int? end;
  int? order;

  Gio({
    this.name,
    this.start,
    this.end,
    this.order,
  });

  factory Gio.fromJson(Map<String, dynamic> json) => Gio(
        name: json["name"],
        start: json["start"],
        end: json["end"],
        order: json["order"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "start": start,
        "end": end,
        "order": order,
      };
}

class TuoiXung {
  String? key;
  String? nguHanh;
  int? order;

  TuoiXung({
    this.key,
    this.nguHanh,
    this.order,
  });

  factory TuoiXung.fromJson(Map<String, dynamic> json) => TuoiXung(
        key: json["key"],
        nguHanh: json["nguHanh"],
        order: json["order"],
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "nguHanh": nguHanh,
        "order": order,
      };
}
