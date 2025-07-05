// lib/Widgets/hourly_forecast_section.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:droplet/Pages/hourly_forecast.dart'; // Make sure this path is correct
import 'package:droplet/Utils/weather_icon_helper.dart'; // Make sure this path is correct

class HourlyForecastSection extends StatelessWidget {
  final List<dynamic> forecastList;

  const HourlyForecastSection({
    super.key,
    required this.forecastList,
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> hourlyForecastWidgets = [];
    final int numberOfForecastsToShow = forecastList.length < 5 ? forecastList.length : 5;

    for (int i = 0; i < numberOfForecastsToShow; i++) {
      final forecastItem = forecastList[i];
      final forecastTime = DateFormat('hh:mm a').format(
        DateTime.fromMillisecondsSinceEpoch(forecastItem['dt'] * 1000),
      );
      final forecastSky = forecastItem['weather'][0]['main'];
      final forecastTemp = forecastItem['main']['temp'];

      hourlyForecastWidgets.add(
        HourlyForecast(
          time: forecastTime,
          icon: getWeatherIcon(forecastSky),
          temp: forecastTemp,
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        const double minWidthForExpandedRow = 700.0; // Adjust as needed for tablet/desktop

        if (constraints.maxWidth > minWidthForExpandedRow) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: hourlyForecastWidgets,
          );
        } else {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: hourlyForecastWidgets,
            ),
          );
        }
      },
    );
  }
}