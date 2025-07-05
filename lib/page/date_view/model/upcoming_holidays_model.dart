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