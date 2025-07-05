import 'dart:convert';
import 'dart:ui';
import 'package:droplet/Pages/additional_info.dart';
import 'package:droplet/Pages/hourly_forecast.dart';
import 'package:droplet/Pages/secrets.dart';
import 'package:droplet/Utils/weather_icon_helper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class DropletMaterialPage extends StatefulWidget {
  const DropletMaterialPage({super.key});

  @override
  State<DropletMaterialPage> createState() => _DropletMaterialPageState();
}

class _DropletMaterialPageState extends State<DropletMaterialPage> {
  late Future<Map<String, dynamic>> _weatherFuture;
  // double temp = 0;
  // @override
  // initState() {
  //   super.initState();
  //   getCurrentWeather();
  // } commenting for an easy way.

  /// api takes time to call. so we used future and async stuff. So this will execute in future. While the time
  /// the build function will get called. so now the temp is assigned to 0 , as we didn't call the getCurrentWeather()
  /// function before build func to get the temp value initialized to live update.
  /// to solve this error we wrap the temp in setState() function which is a void callback func
  /// by this the temp will first set to zero. as it is assigned to zero previously. then it will again assigned to
  /// the real value by the setState function.first it will show zero then the real value.
  /// but it's not a good user experience.

  void _loadWeather() {
    setState(() {
      // print("Reloading weather future...");
      _weatherFuture = getCurrentWeather();
    });
  }

  @override
  void initState() {
    super.initState();
    _loadWeather(); // fetch data on launch
  }

  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String cityName = 'Rajshahi';
      final forecastRes = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherAPIKey',
        ),
      );

      /// we did all of the stuffs. but there's an easy way to do it.
      final forecastData = jsonDecode(forecastRes.body);
      if (forecastData['cod'] != "200") {
        throw 'An unexpected error occured';
      }
      // setState(() {
      // data['main']['temp'];
      // });

      // Fetch current weather data
      final currentRes = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$cityName&APPID=$openWeatherAPIKey',
        ),
      );

      final currentData = jsonDecode(currentRes.body);
      if (currentRes.statusCode != 200) {
        throw 'An unexpected error occurred while fetching current weather';
      }

      return {'current': currentData, 'forecast': forecastData};
    } catch (e) {
      throw e.toString();
    }
  }

  /// we can't call the function in build function. because the build func always should be free from async stuff.
  /// so we have to use stateful widget instead of stateless and call the initState function there and call the function there.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Droplet',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Refreshing weather...')));
              _loadWeather(); 
            },
            icon: Icon(Icons.refresh),
            color: Colors.white,
          ),
        ],
      ),

      ///
      /// we did all of the stuffs. but there's an easy way to do it.
      body: //temp==0 ? const CircularProgressIndicator()
      FutureBuilder(
        future:  _weatherFuture,
        builder: (context, snapshot) {
            // print("Fetching new weather data at: ${DateTime.now()}"); // ✅ Add this

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: const CircularProgressIndicator.adaptive());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          final data = snapshot.data!;
          final currentData = data['current'];
          final forecastData = data['forecast']['list'];
          // final currentTime = DateTime.fromMillisecondsSinceEpoch(
          //   currentData['dt'] * 1000,
          // );
          // final currentFormattedTime = DateFormat(
          //   'hh:mm a, MMM d',
          // ).format(currentTime);

          final currentTemp = currentData['main']['temp'];
          final currentSkyMain = currentData['weather'][0]['main'];
          final currentPressure = currentData['main']['pressure'];
          final currentHumidity = currentData['main']['humidity'];
          final currentWindSpeed = currentData['wind']['speed'];
          final f1Time = DateFormat('hh:mm a').format(
            DateTime.fromMillisecondsSinceEpoch(forecastData[0]['dt'] * 1000),
          );
          final f2Time = DateFormat('hh:mm a').format(
            DateTime.fromMillisecondsSinceEpoch(forecastData[1]['dt'] * 1000),
          );
          final f3Time = DateFormat('hh:mm a').format(
            DateTime.fromMillisecondsSinceEpoch(forecastData[2]['dt'] * 1000),
          );
          final f4Time = DateFormat('hh:mm a').format(
            DateTime.fromMillisecondsSinceEpoch(forecastData[3]['dt'] * 1000),
          );
          final f5Time = DateFormat('hh:mm a').format(
            DateTime.fromMillisecondsSinceEpoch(forecastData[4]['dt'] * 1000),
          );

          final forcastSky1 = forecastData[0]['weather'][0]['main'];
          final forcastSky2 = forecastData[1]['weather'][0]['main'];
          final forcastSky3 = forecastData[2]['weather'][0]['main'];
          final forcastSky4 = forecastData[3]['weather'][0]['main'];
          final forcastSky5 = forecastData[4]['weather'][0]['main'];

          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                '$currentTemp K',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Icon(getWeatherIcon(currentSkyMain), size: 64),

                              const SizedBox(height: 20),
                              Text(
                                currentSkyMain,
                                style: TextStyle(fontSize: 20),
                              ),
                              const SizedBox(height: 14),
                              Text(
                                'Updated: ${DateTime.now()}',
                                style: TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Align(
                //   alignment: Alignment.centerLeft,
                //   child:  we can use the cross axis alignment in the main column to do this at once for all
                const Text(
                  'Weather Forecast',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 14),

                /// forecast
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      HourlyForecast(
                        time: f1Time,
                        icon: getWeatherIcon(forcastSky1),
                        temp: forecastData[0]['main']['temp'],
                      ),
                      HourlyForecast(
                        time: f2Time,
                        icon: getWeatherIcon(forcastSky2),
                        temp: forecastData[1]['main']['temp'],
                      ),
                      HourlyForecast(
                        time: f3Time,
                        icon: getWeatherIcon(forcastSky3),
                        temp: forecastData[2]['main']['temp'],
                      ),
                      HourlyForecast(
                        time: f4Time,
                        icon: getWeatherIcon(forcastSky4),
                        temp: forecastData[3]['main']['temp'],
                      ),
                      HourlyForecast(
                        time: f5Time,
                        icon: getWeatherIcon(forcastSky5),
                        temp: forecastData[4]['main']['temp'],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Align(
                //   alignment: Alignment.centerLeft,
                //   child:  we can use the cross axis alignment in the main column to do this at once for all
                const Text(
                  'Additional Inormation',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 13),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AdditionalInfo(
                      icon: Icons.water_drop,
                      property: "Humidity",
                      propvalue: currentHumidity.toString(),
                    ),
                    AdditionalInfo(
                      icon: Icons.air,
                      property: "Wind Speed",
                      propvalue: currentWindSpeed.toString(),
                    ),
                    AdditionalInfo(
                      icon: Icons.beach_access,
                      property: "Pressure",
                      propvalue: currentPressure.toString(),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
