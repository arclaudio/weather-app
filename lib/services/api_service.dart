import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/forecast.dart';
import 'package:weather_app/models/geo_location.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/services/api_config.dart';
import 'package:weather_app/services/api_identifier.dart';

List<GeoLocation> parseLocations(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<GeoLocation>((json) => GeoLocation.fromJson(json)).toList();
}

Uri buildUri(ApiIdentifier apiIdentifier,
    {double? lat, double? lon, String? locationName, String? countryCode}) {
  String path;
  Map<String, String> queryParameters = {'appid': ApiConfig.apiKey};

  switch (apiIdentifier) {
    case ApiIdentifier.geo:
      path = ApiConfig.geoPath;
      if (locationName != null && countryCode != null) {
        queryParameters['q'] = '$locationName,$countryCode';
      } else {
        queryParameters['q'] = locationName!;
      }
      queryParameters['limit'] = ApiConfig.limit;
      break;
    case ApiIdentifier.weather:
      path = ApiConfig.weatherPath;
      if (lat != null && lon != null) {
        queryParameters['lat'] = lat.toString();
        queryParameters['lon'] = lon.toString();
        queryParameters['units'] = ApiConfig.unit; //for celcius
      }
      break;
    case ApiIdentifier.forecast:
      path = ApiConfig.forecastPath;
      if (lat != null && lon != null) {
        queryParameters['lat'] = lat.toString();
        queryParameters['lon'] = lon.toString();
        queryParameters['units'] = ApiConfig.unit; //for celcius
      }
      break;
    default:
      throw ArgumentError('Invalid API identifier: $apiIdentifier');
  }

  return Uri(
    scheme: ApiConfig.scheme,
    host: ApiConfig.host,
    path: path,
    queryParameters: queryParameters,
  );
}

Future<List<GeoLocation>> fetchLocations(String query) async {
  final parts = query.split(','); // Split the query by comma

  final locationName =
      parts[0].trim(); // Trim whitespace around the location name
  String? countryCode; // Make country code nullable

  if (parts.length > 1) {
    // Check if there is a comma in the query
    countryCode = parts[1].trim(); // Assign country code if available
  }

  Uri geoUri = buildUri(ApiIdentifier.geo,
      locationName: locationName, countryCode: countryCode);
  final response = await http.get(geoUri);

  if (response.statusCode == 200) {
    List<GeoLocation> locations = parseLocations(response.body);
    return locations;
  } else {
    throw Exception('Failed to load locations');
  }
}

Future<ForecastResponse> fetchForecast(double lat, double lon) async {
  final Uri uri = buildUri(ApiIdentifier.forecast, lat: lat, lon: lon);
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    return ForecastResponse.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to fetch forecast data');
  }
}

Future<WeatherResponse> fetchWeather(double lat, double lon) async {
  final Uri uri = buildUri(ApiIdentifier.weather, lat: lat, lon: lon);
  print(uri);
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    return WeatherResponse.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to fetch weather data');
  }
}
