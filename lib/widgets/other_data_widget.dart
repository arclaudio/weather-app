import 'package:flutter/material.dart';
import 'package:weather_app/utils/text_utils.dart';

class OtherData extends StatelessWidget {
  final int humidity;
  final int pressure;
  final double feelsLike;
  final int seaLevel;
  final int groundLevel;

  const OtherData({
    super.key,
    required this.humidity,
    required this.pressure,
    required this.feelsLike,
    required this.seaLevel,
    required this.groundLevel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.black.withOpacity(0.5),
      ),
      height: 210,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDataItem(
              'Humidity', CustomTextUtils.formatPercent(humidity), theme),
          _buildDivider(theme),
          _buildDataItem(
              'Pressure', CustomTextUtils.formatLevel(pressure), theme),
          _buildDivider(theme),
          _buildDataItem(
              'Real feel', CustomTextUtils.formatTemp(feelsLike), theme),
          _buildDivider(theme),
          _buildDataItem(
              'Sea Level', CustomTextUtils.formatLevel(seaLevel), theme),
          _buildDivider(theme),
          _buildDataItem(
              'Ground Level', CustomTextUtils.formatLevel(groundLevel), theme),
        ],
      ),
    );
  }

  Widget _buildDataItem(String label, dynamic value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(4.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: theme.textTheme.bodyLarge!.color,
            ),
          ),
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: 12,
              color: theme.textTheme.bodyLarge!.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(ThemeData theme) {
    return Divider(
      color: theme.textTheme.bodyLarge!.color,
      thickness: 0.2,
      height: 10,
    );
  }
}
