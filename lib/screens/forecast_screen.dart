import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:weather_app/models/forecast.dart';
import 'package:weather_app/services/api_service.dart';
import 'package:weather_app/services/favorite_location.dart';
import 'package:weather_app/utils/date_utils.dart';
import 'package:weather_app/widgets/icon_widget.dart';

class ForecastScreen extends StatefulWidget {
  final double lat;
  final double lon;

  const ForecastScreen({super.key, required this.lat, required this.lon});

  @override
  ForecastScreenState createState() => ForecastScreenState();
}

class ForecastScreenState extends State<ForecastScreen> {
  late Future<ForecastResponse> _forecastFuture;
  late FavoriteLocations _favoriteLocations;
  bool _isFavorite = false;
  late bool _isDefaultLocation;

  @override
  void initState() {
    super.initState();
    _fetchForecastData();
    _favoriteLocations = FavoriteLocations();
    _checkIfFavorite();
  }

  void _checkIfFavorite() async {
    final locations = await _favoriteLocations.getLocations();
    setState(() {
      _isDefaultLocation =
          _favoriteLocations.isDefaultLocation(widget.lat, widget.lon);
      _isFavorite = locations.any((location) =>
          location['lat'] == widget.lat && location['lon'] == widget.lon);
    });
  }

  void _fetchForecastData() {
    setState(() {
      _forecastFuture = fetchForecast(widget.lat, widget.lon);
    });
  }

  void _toggleFavorite() async {
    try {
      final forecastResponse = await _forecastFuture;
      final cityName = forecastResponse.city.name;
      final country = forecastResponse.city.country;
      if (_isFavorite) {
        await _favoriteLocations.removeLocation(widget.lat, widget.lon);
      } else {
        await _favoriteLocations.addLocation(
            cityName, country, widget.lat, widget.lon);
      }
      setState(() {
        _isFavorite = !_isFavorite;
      });
    } catch (e) {
      log('Error fetching forecast data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.1),
        title: Text(
          '5 Day Forecast',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.bodyLarge!.color,
          ),
        ),
        scrolledUnderElevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).textTheme.bodyLarge!.color,
          ),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
        actions: !_isDefaultLocation
            ? [
                IconButton(
                  onPressed: _toggleFavorite,
                  icon: Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: _isFavorite ? Colors.red : null,
                  ),
                ),
              ]
            : null,
      ),
      body: FutureBuilder<ForecastResponse>(
        future: _forecastFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final ForecastResponse forecastResponse = snapshot.data!;
            final List<ForecastItem> forecast = forecastResponse.list;

            // Group forecast items by date
            Map<String, List<ForecastItem>> groupedForecast = {};
            for (var item in forecast) {
              String date = item.dtTxt.split(' ')[0];
              if (!groupedForecast.containsKey(date)) {
                //check if the group does not contains an entry for the crrent date in loop
                groupedForecast[date] =
                    []; //initialize empty list for a specific date
              }
              groupedForecast[date]!.add(item);
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    forecastResponse.city.name,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                  ),
                ),

                // Display the grouped forecast data
                Expanded(
                  child: ListView.builder(
                    itemCount: groupedForecast.length,
                    itemBuilder: (context, index) {
                      String date = groupedForecast.keys.elementAt(index);
                      List<ForecastItem> items = groupedForecast[date]!;

                      // Display forecast items for the day horizontally
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                CustomDateUtils.getDay(date),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color,
                                ),
                              ),
                              // Display forecast items horizontally
                              SizedBox(
                                height: 160,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: items.length,
                                  itemBuilder: (context, index) {
                                    ForecastItem item = items[index];

                                    String weatherIcon =
                                        item.weather.first.icon;
                                    double temperature = item.main.temp;
                                    String description =
                                        item.weather.first.description;
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 9.0),
                                      child: Container(
                                        padding: const EdgeInsets.all(8.0),
                                        width: 120,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 4.0),
                                        decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        child: Column(
                                          children: [
                                            Text(
                                              CustomDateUtils.getFormattedTime2(
                                                  item.dt),
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                            WeatherIcon(iconCode: weatherIcon),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              textBaseline:
                                                  TextBaseline.alphabetic,
                                              children: [
                                                Text(
                                                  temperature
                                                      .toStringAsFixed(1),
                                                  style: const TextStyle(
                                                    fontSize: 24,
                                                  ),
                                                ),
                                                const Text(
                                                  '°C',
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              description,
                                              style:
                                                  const TextStyle(fontSize: 11),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
