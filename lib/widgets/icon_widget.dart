import 'package:flutter/material.dart';

class WeatherIcon extends StatelessWidget {
  final String iconCode;

  const WeatherIcon({super.key, required this.iconCode});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      'https://openweathermap.org/img/w/$iconCode.png',
      height: 50,
      width: 50,
      errorBuilder: (context, error, stackTrace) {
        return const Icon(Icons.error);
      },
    );
  }
}
