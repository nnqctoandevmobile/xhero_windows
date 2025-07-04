// To parse this JSON data, do
//
//     final calendarResponse = calendarResponseFromJson(jsonString);

import 'dart:convert';

CalendarResponse calendarResponseFromJson(String str) =>
    CalendarResponse.fromJson(json.decode(str));

String calendarResponseToJson(CalendarResponse data) =>
    json.encode(data.toJson());

class CalendarResponse {
  bool? status;
  Data? data;

  CalendarResponse({
    this.status,
    this.data,
  });

  factory CalendarResponse.fromJson(Map<String, dynamic> json) =>
      CalendarResponse(
        status: json["status"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
      };
}

class Data {
  String? auspiciousDayId;
  List<Calendar>? calendar;
  List<UpcomingHoliday>? upcomingHolidays;

  Data({
    this.auspiciousDayId,
    this.calendar,
    this.upcomingHolidays,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        auspiciousDayId: json['auspiciousDayId'],
        calendar: List<Calendar>.from(
            json["calendar"].map((x) => Calendar.fromJson(x))),
        upcomingHolidays: List<UpcomingHoliday>.from(
            json["upcomingHolidays"].map((x) => UpcomingHoliday.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "auspiciousDayId": auspiciousDayId,
        "calendar": List<dynamic>.from(calendar?.map((x) => x.toJson()) ?? []),
        "upcomingHolidays":
            List<dynamic>.from(upcomingHolidays?.map((x) => x.toJson()) ?? []),
      };
}

class Calendar {
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
  bool? isHavePersonalEvents;
  List<UpcomingHoliday>? events;
  List<IncenseAndLamps>? incenseAndLamps;
  bool? isHoangDaoDay;

  Calendar({
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
    this.incenseAndLamps,
    this.events,
    this.isHavePersonalEvents,
    this.isHoangDaoDay,
  });

  factory Calendar.fromJson(Map<String, dynamic> json) => Calendar(
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
        incenseAndLamps: List<IncenseAndLamps>.from(
            json["incenseAndLamps"].map((x) => IncenseAndLamps.fromJson(x))),
        isHavePersonalEvents: json["isHavePersonalEvents"],
        events: List<UpcomingHoliday>.from(
            json["events"].map((x) => UpcomingHoliday.fromJson(x))),
        isHoangDaoDay: json["isHoangDaoDay"],
      );

  Map<String, dynamic> toJson() => {
        "daySolar": daySolar,
        "gioCan": gioCan,
        "arrGioCan": List<dynamic>.from(arrGioCan?.map((x) => x) ?? []),
        "hanhNgay": hanhNgayValues.reverse[hanhNgay],
        "hanhThang": hanhNgayValues.reverse[hanhThang],
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
        "incenseAndLamps": incenseAndLamps,
        "isHavePersonalEvents": isHavePersonalEvents,
        "events": List<dynamic>.from(events?.map((x) => x.toJson()) ?? []),
        "isHoangDaoDay": isHoangDaoDay,
      };
}

class Event {
  String? name;
  String? solarDate;
  String? lunarDate;

  Event({
    this.name,
    this.solarDate,
    this.lunarDate,
  });

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        name: json["name"],
        solarDate: json["solarDate"],
        lunarDate: json["lunarDate"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "solarDate": solarDate,
        "lunarDate": lunarDate,
      };
}

class UpcomingHoliday {
  String? id;
  String? name;
  String? date;
  String? type;
  String? time;
  bool? isLunarHoliday;
  String? solarDate;
  String? color;
  String? lunarDate;
  int? remainingDays;

  UpcomingHoliday({
    this.id,
    this.name,
    this.date,
    this.type,
    this.time,
    this.isLunarHoliday,
    this.solarDate,
    this.color,
    this.lunarDate,
    this.remainingDays,
  });

  factory UpcomingHoliday.fromJson(Map<String, dynamic> json) =>
      UpcomingHoliday(
        id: json["_id"],
        name: json["name"],
        date: json["date"],
        type: json["type"],
        time: json["time"],
        isLunarHoliday: json["isLunarHoliday"],
        solarDate: json["solarDate"],
        color: json["color"],
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
        "color": color,
        "lunarDate": lunarDate,
        "remainingDays": remainingDays,
      };
}

class IncenseAndLamps {
  String? id;
  String? name;
  List<Descriptions>? descriptions;

  // Constructor
  IncenseAndLamps({
    this.id,
    this.name,
    this.descriptions,
  });

  // Factory method for creating an instance from JSON
  factory IncenseAndLamps.fromJson(Map<String, dynamic> json) =>
      IncenseAndLamps(
        id: json["_id"], // id không cần null check vì có thể là null
        name: json[
            "name"], // name có thể là null, không cần kiểm tra nếu bạn muốn giữ nguyên
        descriptions: json["descriptions"] != null
            ? List<Descriptions>.from(
                json["descriptions"].map((x) => Descriptions.fromJson(x)))
            : [], // Nếu descriptions là null thì trả về danh sách rỗng
      );

  // Convert to JSON
  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "descriptions": descriptions?.map((x) => x.toJson()).toList() ??
            [], // Xử lý null cho descriptions
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

enum HanhNgay { HOA, KIM, MOC, THO, THUY }

final hanhNgayValues = EnumValues({
  "hoa": HanhNgay.HOA,
  "kim": HanhNgay.KIM,
  "moc": HanhNgay.MOC,
  "tho": HanhNgay.THO,
  "thuy": HanhNgay.THUY
});

enum Chi { THIN, TY }

final chiValues = EnumValues({"thin": Chi.THIN, "ty": Chi.TY});

enum Tiet { COC_VU, LAP_HA, TIEU_MAN }

final tietValues = EnumValues(
    {"coc_vu": Tiet.COC_VU, "lap_ha": Tiet.LAP_HA, "tieu_man": Tiet.TIEU_MAN});

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

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
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
