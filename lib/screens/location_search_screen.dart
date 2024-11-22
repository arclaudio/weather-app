import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:weather_app/models/geo_arguments.dart';
import 'package:weather_app/models/geo_location.dart';
import 'package:weather_app/screens/location_selection_screen.dart';
import 'package:weather_app/services/api_service.dart';
import 'package:weather_app/services/favorite_location.dart';

class LocationSearchScreen extends StatefulWidget {
  const LocationSearchScreen({super.key});

  @override
  LocationSearchScreenState createState() => LocationSearchScreenState();
}

class LocationSearchScreenState extends State<LocationSearchScreen> {
  late TextEditingController _searchController;
  List<GeoLocation> _searchResults = [];
  List<Map<String, dynamic>> _favoriteLocations = [];
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _loadFavoriteLocations();
  }

  void _loadFavoriteLocations() async {
    final locations = await FavoriteLocations().getLocations();
    setState(() {
      _favoriteLocations = locations;
    });
    // print(_favoriteLocations.isNotEmpty);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
    // _searchController.clear();
    // _searchResults.clear();
    // _showSuggestions = false;
  }

  void _reset() {
    _searchController.clear();
    _searchResults.clear();
    _showSuggestions = false;
  }

  Future<List<GeoLocation>> _fetchLocations(String query) async {
    try {
      return await fetchLocations(query);
    } catch (e) {
      log('Error fetching locations: $e');
      return [];
    }
  }

  void _hideSuggestionsList() {
    setState(() {
      _showSuggestions = false;
    });
  }

  void _searchLocations(String pattern) async {
    _hideSuggestionsList();
    List<GeoLocation> locations = await _fetchLocations(pattern);
    setState(() {
      _searchResults = locations;
      _showSuggestions = true; // Show the results list after fetching
    });
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
      _reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.1),
        title: Text(
          'Location Search',
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
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                      controller: _searchController,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle: const TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                        prefixIcon:
                            const Icon(Icons.search, color: Colors.grey),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _reset();
                            });
                          },
                          icon: const Icon(Icons.clear, color: Colors.grey),
                        ),
                      ),
                      onSubmitted: (pattern) {
                        _searchLocations(pattern);
                      },
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LocationSelectionScreen(),
                      ),
                    ).then((selectedLocation) {
                      if (selectedLocation != null) {
                        // Navigate to forecast screen with selected latitude and longitude
                        _navigateToForecastScreen(
                            context,
                            selectedLocation.latitude,
                            selectedLocation.longitude);
                      }
                    });
                  },
                  icon: const Icon(Icons.location_on, color: Colors.white),
                ),
              ],
            ),
          ),
          if (_showSuggestions && _searchResults.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      '${_searchResults[index].name} - ${_searchResults[index].state}',
                      style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge!.color),
                    ),
                    subtitle: Text(
                      '${_searchResults[index].lat}, ${_searchResults[index].lon}',
                      style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge!.color),
                    ),
                    onTap: () {
                      _navigateToForecastScreen(
                        context,
                        _searchResults[index].lat,
                        _searchResults[index].lon,
                      );
                    },
                  );
                },
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Favorites',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyLarge!.color,
              ),
            ),
          ),
          if (_favoriteLocations.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: _favoriteLocations.length,
                itemBuilder: (context, index) {
                  final location = _favoriteLocations[index];
                  return Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blue,
                        ),
                        child: ListTile(
                          title: Text(
                            '${location['cityName']} - ${location['country']}',
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyLarge!.color,
                            ),
                          ),
                          subtitle: Text(
                            '${location['lat']}, ${location['lon']}',
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyLarge!.color,
                            ),
                          ),
                          onTap: () {
                            _navigateToForecastScreen(
                              context,
                              location['lat'],
                              location['lon'],
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
