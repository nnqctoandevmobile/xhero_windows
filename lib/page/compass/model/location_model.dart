import 'dart:convert';

class LocationModel {
  String name;
  double lat;
  double long;

  LocationModel(this.name, this.lat, this.long);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'lat': lat,
      'long': long,
    };
  }

  String toJson() => json.encode(toMap());

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      map['name'],
      map['lat'],
      map['long'],
    );
  }

  factory LocationModel.fromJson(String source) =>
      LocationModel.fromMap(json.decode(source));
}