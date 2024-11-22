class GeoLocation {
  final String name;
  final double lat;
  final double lon;
  final String country;
  final String state;

  GeoLocation(
      {required this.name,
      required this.lat,
      required this.lon,
      required this.country,
      required this.state});

  factory GeoLocation.fromJson(Map<String, dynamic> json) {
    return GeoLocation(
      name: json['name'],
      lat: json['lat'].toDouble(),
      lon: json['lon'].toDouble(),
      country: json['country'],
      state: json['state'],
    );
  }
}
