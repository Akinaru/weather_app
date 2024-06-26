import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/models/location.dart';
import 'package:weather_app/services/openweathermap_api.dart';

import 'weather_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    final openWeatherMapApi = context.read<OpenWeatherMapApi>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recherche'),
      ),
      body: Column(
        children: [
          TextField(
            onChanged: (value) {
              query = value;
            },
            decoration: const InputDecoration(
              labelText: 'Entrez une ville',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {});
            },
            child: const Text('Rechercher'),
          ),
          if (query.isEmpty)
            const Text('Saisissez une ville dans la barre de recherche.')
          else
            FutureBuilder(
              future: openWeatherMapApi.searchLocations(query),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Text('Une erreur est survenue.\n${snapshot.error}');
                }

                if (!snapshot.hasData) {
                  return const Text('Aucun résultat pour cette recherche.');
                }

                Iterable<Location> locations = snapshot.data!;
                final List<Widget> listTiles = locations.map((location) {
                  return ListTile(
                    title: Text(
                        '${location.name} (${location.country}) => lon: ${location.lon}, lat: ${location.lat}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => WeatherPage(
                            locationName: location.name,
                            latitude: location.lat,
                            longitude: location.lon,
                          ),
                        ),
                      );
                    },
                  );
                }).toList();

                return Expanded(
                  child: ListView(
                    children: listTiles,
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
