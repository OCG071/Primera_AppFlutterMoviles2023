class LocationModel {
  String? idLocation;
  double? lon;
  double? lat;
  String? name;

  LocationModel({this.idLocation, this.lon, this.lat, this.name});

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
        idLocation: map['idLocation'],
        lon: map['lon'],
        lat: map['lat'],
        name: map['name']);
  }
}
