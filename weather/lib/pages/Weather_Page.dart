// ignore_for_file: non_constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:weather/models/weather_model.dart';
import 'package:weather/service/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // api key
  final WeatherService _weatherService =
      WeatherService('31641596a5faa7cfdbb9944d7dad783e');
  Weather? _weather;
  TextEditingController _cityController = TextEditingController(); // Controller for the city input

  // fetch Weather
  _fetchWeather(String cityName) async {
    // Get weather for the city
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      // Handle exceptions or errors, e.g., show an error message
      print("Error fetching weather: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    // Use a default city or leave it empty based on your requirement
    _fetchWeather('Tunis');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Input field for city
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _cityController,
                decoration: InputDecoration(
                  labelText: 'Enter City',
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            // Button to trigger weather fetching
            ElevatedButton(
              onPressed: () {
                _fetchWeather(_cityController.text);
              },
              child: Text('Fetch Weather'),
            ),

            // Display weather details
            // city name
            Text(_weather?.cityName ?? "Loading city..."),

            // temperature
            Text('${_weather?.temperature?.round() ?? ""} °C'),
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty<WeatherService>('_weatherService', _weatherService));
  }
}
