import 'package:flutter/material.dart';
import 'package:weather_app/models/geo_arguments.dart';
import 'package:weather_app/screens/forecast_screen.dart';

import 'package:weather_app/screens/home_screen.dart';
import 'package:weather_app/screens/location_search_screen.dart';
import 'package:weather_app/themes/themes.dart';
import 'package:weather_app/utils/theme_utils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      themeMode: getThemeMode(),
      theme: buildLightTheme(),
      darkTheme: buildDarkTheme(),
      home: const HomeScreen(),
      routes: {
        '/locationSearch': (context) => const LocationSearchScreen(),
        // '/forecast': (context) => const ForecastScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/forecast') {
          final args = settings.arguments as GeoArguments;
          return MaterialPageRoute(
            builder: (context) => ForecastScreen(lat: args.lat, lon: args.lon),
          );
        }
        return null;
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
