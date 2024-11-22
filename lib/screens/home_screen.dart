import 'package:flutter/material.dart';
import 'package:weather_app/models/forecast.dart';
import 'package:weather_app/models/geo_arguments.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/services/api_service.dart';
import 'package:weather_app/services/favorite_location.dart';
import 'package:weather_app/utils/date_utils.dart';
import 'package:weather_app/utils/text_utils.dart';
import 'package:weather_app/utils/theme_utils.dart';
import 'package:weather_app/widgets/compass_widget.dart';
import 'package:weather_app/widgets/forecast_tile_widget.dart';
import 'package:weather_app/widgets/other_data_widget.dart';
import 'package:weather_app/widgets/sunrise_sunset_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late List<Map<String, dynamic>> _favoriteLocations = [];
  int _currentIndex = 0;
  late Future<WeatherResponse> _weatherFuture;
  late Future<ForecastResponse> _forecastFuture;
  ThemeMode theme = getThemeMode();

  @override
  void initState() {
    super.initState();
    _loadFavoriteLocations();
  }

  void _loadFavoriteLocations() async {
    await FavoriteLocations().addLocation();
    final locations = await FavoriteLocations().getLocations();
    setState(() {
      _currentIndex = 0;
      _favoriteLocations = locations;
      _fetchWeatherData();
      _fetchForecastData();
    });
  }

  void _fetchWeatherData() {
    setState(() {
      _weatherFuture = fetchWeather(
        _favoriteLocations[_currentIndex]['lat'],
        _favoriteLocations[_currentIndex]['lon'],
      );
    });
  }

  void _fetchForecastData() {
    setState(() {
      _forecastFuture = fetchForecast(
        _favoriteLocations[_currentIndex]['lat'],
        _favoriteLocations[_currentIndex]['lon'],
      );
    });
  }

  void _nextLocation() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _favoriteLocations.length;
      _fetchWeatherData();
      _fetchForecastData();
    });
  }

  void _prevLocation() {
    setState(() {
      _currentIndex = (_currentIndex - 1 + _favoriteLocations.length) %
          _favoriteLocations.length;
      _fetchWeatherData();
      _fetchForecastData();
    });
  }

  void _navigateToSearchLocationScreen(
    BuildContext context,
  ) async {
    final result = await Navigator.pushNamed(
      context,
      '/locationSearch',
    );
    if (result != null && result is bool && result) {
      // Reload favorite locations
      _loadFavoriteLocations();
    }
  }

  void _navigateToForecastScreen(
    BuildContext context,
    double lat,
    double lon,
  ) async {
    final result = await Navigator.pushNamed(
      context,
      '/forecast',
      arguments: GeoArguments(lat: lat, lon: lon),
    );
    if (result != null && result is bool && result) {
      // Reload favorite locations if a location has been removed
      _loadFavoriteLocations();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.1),
        flexibleSpace: Center(
          child: Text(
            _favoriteLocations.isNotEmpty
                ? _favoriteLocations[_currentIndex]['cityName']
                : 'No Favorite Locations',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyLarge!.color,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.add),
          color: Theme.of(context).textTheme.bodyLarge!.color,
          onPressed: () {
            _navigateToSearchLocationScreen(context);
          },
        ),
      ),
      body: _favoriteLocations.isEmpty
          ? const Center(
              child: Text('No Favorite Locations'),
            )
          : GestureDetector(
              onHorizontalDragEnd: (details) {
                if (details.primaryVelocity! > 0) {
                  _prevLocation();
                } else if (details.primaryVelocity! < 0) {
                  _nextLocation();
                }
              },
              child: FutureBuilder<WeatherResponse>(
                future: _weatherFuture,
                builder: (context, weatherSnapshot) {
                  if (weatherSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (weatherSnapshot.hasError) {
                    return Center(
                      child: Text('Error: ${weatherSnapshot.error}'),
                    );
                  } else {
                    final weather = weatherSnapshot.data!;
                    return FutureBuilder<ForecastResponse>(
                      future: _forecastFuture,
                      builder: (context, forecastSnapshot) {
                        if (forecastSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (forecastSnapshot.hasError) {
                          return Center(
                            child: Text('Error: ${forecastSnapshot.error}'),
                          );
                        } else {
                          final forecast = forecastSnapshot.data!;
                          return SingleChildScrollView(
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                    theme == ThemeMode.light
                                        ? 'assets/day.jpg'
                                        : 'assets/night.jpg',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    height: 50,
                                  ),
                                  Text(
                                    CustomDateUtils.getFormattedDate(
                                        weather.dt),
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .color,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 50,
                                  ),
                                  Text(
                                    CustomTextUtils.formatTemp(
                                        weather.main.temp),
                                    style: TextStyle(
                                      fontSize: 100,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black.withOpacity(0.5),
                                          offset: const Offset(3, 3),
                                          blurRadius: 2,
                                        ),
                                      ],
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .color,
                                    ),
                                  ),
                                  Text(
                                    weather.weather.first.description,
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .color,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${CustomTextUtils.formatTemp(weather.main.tempMin)} / ${CustomTextUtils.formatTemp(weather.main.tempMax)}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .color,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 90,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.black.withOpacity(0.5),
                                    ),
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      children: [
                                        ...forecast.list.take(3).map((item) {
                                          //using ... spread operator to spread the result into children list
                                          return ForecastTile(
                                            day: CustomDateUtils
                                                .getFormattedTime2(item.dt),
                                            condition:
                                                item.weather.first.description,
                                            high: item.main.tempMax.toInt(),
                                            low: item.main.tempMin.toInt(),
                                            textColor: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .color,
                                            icon: item.weather.first.icon,
                                          );
                                        }),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        SizedBox(
                                          width: double.infinity,
                                          height: 50,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              _navigateToForecastScreen(
                                                context,
                                                _favoriteLocations[
                                                    _currentIndex]['lat'],
                                                _favoriteLocations[
                                                    _currentIndex]['lon'],
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  theme == ThemeMode.light
                                                      ? Colors.grey[200]
                                                      : Colors.grey[800],
                                            ),
                                            child: Text(
                                              '5-day forecast',
                                              style: TextStyle(
                                                color: theme == ThemeMode.light
                                                    ? Colors.black
                                                    : Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(2),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                children: [
                                                  //-----------Widget for Wind direction
                                                  CompassWidget(
                                                      speed: weather.wind.speed,
                                                      deg: weather.wind.deg),
                                                  const SizedBox(height: 10),
                                                  //-----------Widget for Sunrise and Sunset
                                                  SunriseSunsetWidget(
                                                      sunrise:
                                                          weather.sys.sunrise,
                                                      sunset:
                                                          weather.sys.sunset)
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              //-----------Widget for other data
                                              child: OtherData(
                                                humidity: weather.main.humidity,
                                                pressure: weather.main.pressure,
                                                feelsLike:
                                                    weather.main.feelsLike,
                                                seaLevel:
                                                    weather.main.seaLevel ?? 0,
                                                groundLevel:
                                                    weather.main.grndLevel ?? 0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      },
                    );
                  }
                },
              ),
            ),
    );
  }
}
