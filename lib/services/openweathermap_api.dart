import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/location.dart';
import '../models/weather.dart';

class OpenWeatherMapApi {
  OpenWeatherMapApi({
    required this.apiKey,
    this.units = 'metric',
    this.lang = 'fr',
  });

  static const String baseUrl = 'https://api.openweathermap.org';

  final String apiKey;
  final String units;
  final String lang;

  String getIconUrl(String icon) {
    return 'https://openweathermap.org/img/wn/$icon@4x.png';
  }

  Future<Iterable<Location>> searchLocations(
    String query, {
    int limit = 5,
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl/geo/1.0/direct?appid=$apiKey&q=$query&limit=$limit'),
    );

    if (response.statusCode == HttpStatus.ok) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Location.fromJson(json));
    }

    throw Exception(
        'Impossible de récupérer les données de localisation (HTTP ${response.statusCode})');
  }

  Future<Weather> getWeather(double lat, double lon) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/data/2.5/weather?appid=$apiKey&lat=$lat&lon=$lon&units=$units&lang=$lang',
      ),
    );

    if (response.statusCode == HttpStatus.ok) {
      return Weather.fromJson(json.decode(response.body));
    }

    throw Exception(
        'Impossible de récupérer les données météo (HTTP ${response.statusCode})');
  }

  Future<Iterable<Weather>> getWeatherMultipleDays(
      double lat, double lon) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/data/2.5/forecast?lat=$lat&lon=$lon&appid=$apiKey&lang=$lang&units=$units',
      ),
    );

    if (response.statusCode == HttpStatus.ok) {
      final dynamic jsonData = json.decode(response.body);
      if (jsonData is Map<String, dynamic> && jsonData.containsKey("list")) {
        final List<dynamic> forecastList = jsonData["list"];
        return forecastList.map((json) => Weather.fromJson(json)).toList();
      } else {
        throw Exception('Format de données JSON invalide');
      }
    }

    throw Exception(
        'Impossible de récupérer les données météo sur plusieurs jours (HTTP ${response.statusCode})');
  }
}
