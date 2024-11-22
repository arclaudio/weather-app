import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:weather_app/utils/date_utils.dart';

class SunriseSunsetWidget extends StatelessWidget {
  final int sunrise;
  final int sunset;

  const SunriseSunsetWidget({
    super.key,
    required this.sunrise,
    required this.sunset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.black.withOpacity(0.5),
      ),
      height: 100,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              const Icon(CupertinoIcons.sunrise), // Sunrise icon
              const SizedBox(width: 8),
              Text(
                'Sunrise: ${CustomDateUtils.getFormattedTime(sunrise)}',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(CupertinoIcons.sunset), // Sunset icon
              const SizedBox(width: 8),
              Text(
                'Sunset: ${CustomDateUtils.getFormattedTime(sunset)}',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
