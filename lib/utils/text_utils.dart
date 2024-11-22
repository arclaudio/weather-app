class CustomTextUtils {
  static String formatTemp(double temp) {
    final stringTemp = temp.toInt().toString();
    return '$stringTemp°';
  }

  static String formatPercent(int num) {
    final percent = num.toString();
    return '$percent%';
  }

  static String formatLevel(int num) {
    final level = num.toString();
    return '$level hPa';
  }
}
