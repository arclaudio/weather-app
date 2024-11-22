import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CompassWidget extends StatelessWidget {
  final double speed;
  final int deg;

  const CompassWidget({
    super.key,
    required this.speed,
    required this.deg,
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Wind speed text
          Expanded(
            child: Row(
              children: [
                const Icon(CupertinoIcons.wind), // Wind icon
                const SizedBox(width: 8),
                Text(
                  '$speed m/s', // Display wind speed
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Custom compass widget
          CustomCompass(deg: deg),
        ],
      ),
    );
  }
}

class CustomCompass extends StatelessWidget {
  final int deg;

  const CustomCompass({
    super.key,
    required this.deg,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 75,
      height: 75,
      child: Stack(
        children: [
          // Outer circle
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border:
                  Border.all(color: Theme.of(context).dividerColor, width: 2),
            ),
          ),
          // Compass labels
          Positioned(
            top: 1, // Adjusted position for N
            right: 32, // Adjusted position for N
            child: Text(
              'N',
              style: TextStyle(
                  fontSize: 11,
                  color: Theme.of(context).textTheme.bodyLarge!.color),
            ),
          ),
          Positioned(
            top: 25, // Adjusted position for E
            right: 10, // Adjusted position for E
            child: Text(
              'E',
              style: TextStyle(
                  fontSize: 11,
                  color: Theme.of(context).textTheme.bodyLarge!.color),
            ),
          ),
          Positioned(
            bottom: 1, // Adjusted position for S
            left: 35, // Adjusted position for S
            child: Text(
              'S',
              style: TextStyle(
                  fontSize: 11,
                  color: Theme.of(context).textTheme.bodyLarge!.color),
            ),
          ),
          Positioned(
            top: 25, // Adjusted position for W
            left: 10, // Adjusted position for W
            child: Text(
              'W',
              style: TextStyle(
                  fontSize: 11,
                  color: Theme.of(context).textTheme.bodyLarge!.color),
            ),
          ),
          // Arrow
          Positioned(
            top: 30,
            left: 35,
            child: Transform.rotate(
              angle: deg * (pi / 180), // Convert degrees to radians
              child: Container(
                width: 2,
                height: 10, // Adjusted height for arrow
                color: Colors.red, // Change arrow color as needed
              ),
            ),
          ),
        ],
      ),
    );
  }
}
