import 'package:flutter/material.dart';

ThemeMode getThemeMode() {
  final hour = DateTime.now().hour;
  return (hour >= 6 && hour < 18)
      ? ThemeMode.light //Daytime 6am - 5:59pm
      : ThemeMode.dark; //Nighttime 6pm - 5:59am
}
