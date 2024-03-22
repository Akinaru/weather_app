import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/weather.dart';
import '../services/openweathermap_api.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({
    required this.locationName,
    required this.latitude,
    required this.longitude,
    super.key,
  });

  final String locationName;
  final double latitude;
  final double longitude;

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  @override
  Widget build(BuildContext context) {
    final openWeatherMapApi = context.read<OpenWeatherMapApi>();

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.locationName),
        ),
        body: FutureBuilder(
            future:
                openWeatherMapApi.getWeather(widget.latitude, widget.longitude),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Text('Une erreur est survenue.\n${snapshot.error}');
              }

              if (!snapshot.hasData) {
                return Text('Aucun résultat pour cette recherche.');
              }
              Weather weather = snapshot.data!;
              return Scaffold(
                body: Image.network(openWeatherMapApi.getIconUrl(weather.icon)),
              );
            }));
  }
}
