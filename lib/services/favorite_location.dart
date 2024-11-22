import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteLocations {
  static const _key = 'favoriteLocations';
  //data below should be from the GeoLocation
  static const _defaultCityName = 'Current Location';
  static const _defaultCountry = 'PH';
  static const _defaultLat = 14.825810;
  static const _defaultLon = 121.079231;

  // Future<void> _getLocation() async {
  //   Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  //   // print(position.latitude);
  //   setState(() {
  //     _lon = position.latitude;
  //     _lon = position.longitude;
  //   });
  // }

  Future<void> addLocation([
    String? cityName,
    String? country,
    double? lat,
    double? lon,
  ]) async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> locations = await getLocations();

    // Add default location as the first item if it doesn't already exist
    if (!_hasDefaultLocation(locations)) {
      locations.insert(0, {
        'cityName': _defaultCityName,
        'lat': _defaultLat,
        'lon': _defaultLon,
        'country': _defaultCountry
      });
    }

    // Add new location
    if (cityName == null && country == null && lat == null && lon == null) {
      //do nothing
    } else {
      locations.add(
          {'cityName': cityName, 'lat': lat, 'lon': lon, 'country': country});
    }

    await prefs.setString(_key, jsonEncode(locations));
  }

  Future<void> clearAllLocations() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs
        .remove(_key); // Remove the key associated with favorite locations
  }

  Future<void> removeLocation(double lat, double lon) async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> locations = await getLocations();

    // Prevent removing default location
    if (isDefaultLocation(lat, lon)) {
      return; // Do nothing if the location matches the default
    }

    locations.removeWhere(
        (location) => location['lat'] == lat && location['lon'] == lon);
    await prefs.setString(_key, jsonEncode(locations));
  }

  Future<List<Map<String, dynamic>>> getLocations() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString != null) {
      return List<Map<String, dynamic>>.from(jsonDecode(jsonString));
    } else {
      return [];
    }
  }

  bool _hasDefaultLocation(List<Map<String, dynamic>> locations) {
    return locations.any((location) =>
        location['cityName'] == _defaultCityName &&
        location['lat'] == _defaultLat &&
        location['lon'] == _defaultLon &&
        location['country'] == _defaultCountry);
  }

  bool isDefaultLocation(double lat, double lon) {
    return lat == _defaultLat && lon == _defaultLon;
  }
}
