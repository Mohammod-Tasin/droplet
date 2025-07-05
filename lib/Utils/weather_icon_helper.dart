import 'package:flutter/material.dart';

IconData getWeatherIcon(String weatherCondition) {
  switch (weatherCondition.toLowerCase()) {
    case 'clear':
      return Icons.wb_sunny;
    case 'clouds':
      return Icons.cloud;
    case 'rain':
      return Icons.beach_access;
    case 'drizzle':
      return Icons.grain;
    case 'thunderstorm':
      return Icons.flash_on;
    case 'snow':
      return Icons.ac_unit;
    case 'mist':
    case 'smoke':
    case 'haze':
    case 'fog':
    case 'dust':
    case 'sand':
    case 'ash':
    case 'squall':
    case 'tornado':
      return Icons.blur_on;
    default:
      return Icons.help_outline;
  }
}
