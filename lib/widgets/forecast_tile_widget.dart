import 'package:flutter/material.dart';
import 'package:weather_app/widgets/icon_widget.dart';

class ForecastTile extends StatelessWidget {
  final String day;
  final String condition;
  final int high;
  final int low;
  final Color? textColor;
  final String icon;

  const ForecastTile({
    super.key,
    required this.day,
    required this.condition,
    required this.high,
    required this.low,
    required this.textColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        day,
        style: TextStyle(color: textColor),
      ),
      subtitle: Text(
        condition,
        style: TextStyle(color: textColor),
      ),
      leading: WeatherIcon(
        iconCode: icon,
      ),
      trailing: Text(
        '$high° / $low°',
        style: TextStyle(color: textColor),
      ),
    );
  }
}
