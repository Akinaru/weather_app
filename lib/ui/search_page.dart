import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/models/location.dart';
import 'package:weather_app/services/openweathermap_api.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});
  @override
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
              setState(() {
                query = value;
              });
            },
            decoration: InputDecoration(
              labelText: 'Entrez une ville',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Appel de la fonction de recherche
              openWeatherMapApi.searchLocations(query);
            },
            child: Text('Rechercher'),
          ),
          FutureBuilder(
            future: openWeatherMapApi.searchLocations(query),
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

              Iterable<Location> locations = snapshot.data!;
              final List<Widget> listTiles = locations.map((location) {
                return ListTile(
                  title: Text(location.name),
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
