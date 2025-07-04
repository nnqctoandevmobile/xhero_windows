// To parse this JSON data, do
//
//     final resultImportdayResponse = resultImportdayResponseFromJson(jsonString);

import 'dart:convert';

ResultImportdayResponse resultImportdayResponseFromJson(String str) =>
    ResultImportdayResponse.fromJson(json.decode(str));

String resultImportdayResponseToJson(ResultImportdayResponse data) =>
    json.encode(data.toJson());

class ResultImportdayResponse {
  String? status;
  Data? data;

  ResultImportdayResponse({
    this.status,
    this.data,
  });

  factory ResultImportdayResponse.fromJson(Map<String, dynamic> json) =>
      ResultImportdayResponse(
        status: json["status"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
      };
}

class Data {
  AllAboutCanChiGiaChuInit? lichAm;
  ErrShowDayMonthShowOneDate? errShowDayMonthShowOneDate;
  ArrDate? arrDate;
  int? tuoiGiaChu;
  String? tuoiChiGiaChu;
  String? tuoiCanGiaChu;
  String? valueSelect;
  String? toaNha;
  String? dateEnd;
  String? dateStart;
  InfoGiaChu? infoGiaChu;
  AllAboutCanChiGiaChuInit? allAboutCanChiGiaChuInit;
  RangeDay? rangeDay;
  Dia? dia;

  Data({
    this.lichAm,
    this.errShowDayMonthShowOneDate,
    this.arrDate,
    this.tuoiGiaChu,
    this.tuoiChiGiaChu,
    this.tuoiCanGiaChu,
    this.valueSelect,
    this.toaNha,
    this.dateEnd,
    this.dateStart,
    this.infoGiaChu,
    this.allAboutCanChiGiaChuInit,
    this.rangeDay,
    this.dia,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        lichAm: AllAboutCanChiGiaChuInit.fromJson(json["lichAm"]),
        errShowDayMonthShowOneDate: ErrShowDayMonthShowOneDate.fromJson(
            json["errShowDayMonthShowOneDate"]),
        arrDate: ArrDate.fromJson(json["arrDate"]),
        tuoiGiaChu: json["tuoiGiaChu"],
        tuoiChiGiaChu: json["tuoiChiGiaChu"],
        tuoiCanGiaChu: json["tuoiCanGiaChu"],
        valueSelect: json["valueSelect"],
        toaNha: json["toaNha"],
        dateEnd: json["dateEnd"],
        dateStart: json["dateStart"],
        infoGiaChu: InfoGiaChu.fromJson(json["infoGiaChu"]),
        allAboutCanChiGiaChuInit:
            AllAboutCanChiGiaChuInit.fromJson(json["allAboutCanChiGiaChuInit"]),
        rangeDay: RangeDay.fromJson(json["rangeDay"]),
        dia: json["dia"] != null ? Dia.fromJson(json["dia"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "lichAm": lichAm?.toJson(),
        "errShowDayMonthShowOneDate": errShowDayMonthShowOneDate?.toJson(),
        "arrDate": arrDate?.toJson(),
        "tuoiGiaChu": tuoiGiaChu,
        "tuoiChiGiaChu": tuoiChiGiaChu,
        "tuoiCanGiaChu": tuoiCanGiaChu,
        "valueSelect": valueSelect,
        "toaNha": toaNha,
        "dateEnd": dateEnd,
        "dateStart": dateStart,
        "infoGiaChu": infoGiaChu?.toJson(),
        "allAboutCanChiGiaChuInit": allAboutCanChiGiaChuInit?.toJson(),
        "rangeDay": rangeDay?.toJson(),
        "dia": dia?.toJson(),
      };
}

class AllAboutCanChiGiaChuInit {
  int? daySolar;
  String? gioCan;
  Map<String, String>? arrGioCan;
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

  AllAboutCanChiGiaChuInit({
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
  });

  factory AllAboutCanChiGiaChuInit.fromJson(Map<String, dynamic> json) =>
      AllAboutCanChiGiaChuInit(
        daySolar: json["daySolar"],
        gioCan: json["gioCan"],
        arrGioCan: Map.from(json["arrGioCan"])
            .map((k, v) => MapEntry<String, String>(k, v)),
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
      );

  Map<String, dynamic> toJson() => {
        "daySolar": daySolar,
        "gioCan": gioCan,
        "arrGioCan":
            Map.from(arrGioCan!).map((k, v) => MapEntry<String, dynamic>(k, v)),
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
      };
}

class ArrDate {
  ArrDate();

  factory ArrDate.fromJson(Map<String, dynamic> json) => ArrDate();

  Map<String, dynamic> toJson() => {};
}

class Dia {
  ToaNha? toaNha;
  List<String>? hanhNgayChon;

  Dia({
    this.toaNha,
    this.hanhNgayChon,
  });

  factory Dia.fromJson(Map<String, dynamic> json) => Dia(
        toaNha: ToaNha.fromJson(json["toaNha"]),
        hanhNgayChon: List<String>.from(json["hanhNgayChon"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "toaNha": toaNha?.toJson(),
        "hanhNgayChon": List<dynamic>.from(hanhNgayChon?.map((x) => x) ?? []),
      };
}

class ToaNha {
  String? key;
  String? nguHanh;

  ToaNha({
    this.key,
    this.nguHanh,
  });

  factory ToaNha.fromJson(Map<String, dynamic> json) => ToaNha(
        key: json["key"],
        nguHanh: json["nguHanh"],
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "nguHanh": nguHanh,
      };
}

class ErrShowDayMonthShowOneDate {
  String? day;
  String? month;
  String? hours;

  ErrShowDayMonthShowOneDate({
    this.day,
    this.month,
    this.hours,
  });

  factory ErrShowDayMonthShowOneDate.fromJson(Map<String, dynamic> json) =>
      ErrShowDayMonthShowOneDate(
        day: json["day"],
        month: json["month"],
        hours: json["hours"],
      );

  Map<String, dynamic> toJson() => {
        "day": day,
        "month": month,
        "hours": hours,
      };
}

class InfoGiaChu {
  String? namSinhNam;
  String? namSinhNu;
  String? hoTenGiaChu;
  String? tuoiGiaChu;

  InfoGiaChu({
    this.namSinhNam,
    this.namSinhNu,
    this.hoTenGiaChu,
    this.tuoiGiaChu,
  });

  factory InfoGiaChu.fromJson(Map<String, dynamic> json) => InfoGiaChu(
        namSinhNam: json["namSinhNam"],
        namSinhNu: json["namSinhNu"],
        hoTenGiaChu: json["hoTenGiaChu"],
        tuoiGiaChu: json["tuoiGiaChu"],
      );

  Map<String, dynamic> toJson() => {
        "namSinhNam": namSinhNam,
        "namSinhNu": namSinhNu,
        "hoTenGiaChu": hoTenGiaChu,
        "tuoiGiaChu": tuoiGiaChu,
      };
}

class RangeDay {
  The2024? the2024;

  RangeDay({
    this.the2024,
  });

  factory RangeDay.fromJson(Map<String, dynamic> json) => RangeDay(
        the2024: The2024.fromJson(json["2024"]),
      );

  Map<String, dynamic> toJson() => {
        "2024": the2024?.toJson(),
      };
}

class The2024 {
  The4? the4;

  The2024({
    this.the4,
  });

  factory The2024.fromJson(Map<String, dynamic> json) => The2024(
        the4: The4.fromJson(json["4"]),
      );

  Map<String, dynamic> toJson() => {
        "4": the4?.toJson(),
      };
}

class The4 {
  AllAboutCanChiGiaChuInit? the0;

  The4({
    this.the0,
  });

  factory The4.fromJson(Map<String, dynamic> json) => The4(
        the0: AllAboutCanChiGiaChuInit.fromJson(json["0"]),
      );

  Map<String, dynamic> toJson() => {
        "0": the0?.toJson(),
      };
}
