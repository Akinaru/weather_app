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
  centerTitle: true,
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
return Column(
  children: [
    // Première partie avec la carte de température actuelle
    Expanded(
      child: Padding(
        padding: const EdgeInsets.all(40), // Ajouter du padding pour centrer la carte verticalement
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 78, 80, 82), // Couleur de fond de la carte
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [              
                  Image.network(
                    openWeatherMapApi.getIconUrl(weather.icon),
                    width: 200,
                    height: 200,
                  ),
              
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [            
                      Text(
                        weather.description,
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        '${weather.temperature}°C',
                        style: TextStyle(fontSize: 24),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${weather.wind} km/h',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Text('${weather.tempmin}°C', style: TextStyle(fontSize: 18, color: Colors.blue, fontWeight: FontWeight.bold)),
                const SizedBox(width: 10),
                const Text('|', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 10),
                Text('${weather.tempmax}°C', style: TextStyle(fontSize: 18, color: Colors.red, fontWeight: FontWeight.bold))
              ],),
            ],
          ),
          
        ),
      ),
    ),
    // Seconde partie (pour l'instant vide)
    Expanded(
      child: Container(
        color: Colors.grey, // Couleur de fond de la deuxième partie (à remplacer)
        // Ajoutez les widgets pour la deuxième partie ici
      ),
    ),
  ],
);



    },
  ),
);

}
}
