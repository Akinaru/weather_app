import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/services/openweathermap_api.dart';
import 'package:weather_app/ui/search_page.dart';

import 'config.dart';
import 'services/geolocation_service.dart';

void main() {
  Intl.defaultLocale = 'fr_FR';
  initializeDateFormatting();
  runApp(
    MultiProvider(
      providers: [
        Provider(
          create: (_) => OpenWeatherMapApi(apiKey: openWeatherMapApiKey),
        ),
        Provider(
          create: (_) => GeolocationService(),
        ),
      ],
      child: const WeatherApp(),
    ),
  );
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData.dark(),
      home: const SearchPage(),
    );
  }
}
