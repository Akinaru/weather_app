import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/weather.dart';
import '../services/openweathermap_api.dart';
import 'search_page.dart';

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
  title: Text('Météo à ${widget.locationName}'),
  actions: [
    IconButton(
      onPressed: () {
              Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SearchPage()), 
        );
      },
      icon: const Row(
        children: [
          Icon(Icons.search), // Icône de recherche
          SizedBox(width: 5), // Espace entre l'icône et le texte
          Text('Rechercher'), // Texte à côté de l'icône
        ],
      ),
    ),
  ],
),
  body: FutureBuilder(
    future: openWeatherMapApi.getWeather(widget.latitude, widget.longitude),
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
      return Center(
        child: Container(
          decoration: BoxDecoration(color: Colors.blueGrey, borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                openWeatherMapApi.getIconUrl(weather.icon),
                width: 200,
                height: 200,
              ),
              const SizedBox(height: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [            
              Text(
                weather.description,
                style: const TextStyle(fontSize: 30),
              ),
              Text(
                '${weather.temperature}°C',
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 10),
              Text(
                '${weather.wind} km/h',
                style: const TextStyle(fontSize: 20),
              ),],
              )
          
            ],
          ),
        ),
      );
    },
  ),
);

}
}
