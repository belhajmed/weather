import 'dart:convert';


import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weather/models/weather_model.dart';

class WeatherService {
  static const BASE_URL = "http://api.openweathermap.org/data/2.5/weather";
  final String apiKey;

  WeatherService(this.apiKey);

Future<Weather> getWeather(String cityName) async {
  final response = await http.get(Uri.parse("$BASE_URL?q=$cityName&appid=$apiKey&units=metric"));

  if (response.statusCode == 200) {
    return Weather.fromJson(jsonDecode(response.body));
  } else {
    print("Failed to load weather. Status Code: ${response.statusCode}, Body: ${response.body}");
    throw Exception("Failed to load weather");
  }
}

Future<String> getCurrentCity() async {
  try {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

    String? city = placemarks.isNotEmpty ? placemarks[0].locality : null;
    return city ?? "";
  } catch (e) {
    // Handle exceptions or errors, e.g., show an error message
    print("Error getting current city: $e");
    return ""; // Return a default value or handle the error in your own way
  }
}

}
