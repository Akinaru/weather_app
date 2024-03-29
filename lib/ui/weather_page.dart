import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  final _dateFormatter = DateFormat('dd/MM/yyyy');
  final _timeFormatter = DateFormat('hh:mm');
  @override
  Widget build(BuildContext context) {
    final openWeatherMapApi = context.read<OpenWeatherMapApi>();
    final _horizontalScrollController = ScrollController();

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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FutureBuilder(
            future:
                openWeatherMapApi.getWeather(widget.latitude, widget.longitude),
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
              Weather weather = snapshot.data!;
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.network(
                            openWeatherMapApi.getIconUrl(weather.icon),
                            width: 200,
                            height: 200,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(40.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  weather.description,
                                  style: const TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  '${weather.temperature}°C',
                                  style: const TextStyle(fontSize: 24),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  '${weather.wind} km/h',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('${weather.tempmin}°C',
                              style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w800)),
                          const SizedBox(width: 10),
                          const Text('|', style: TextStyle(fontSize: 18)),
                          const SizedBox(width: 10),
                          Text('${weather.tempmax}°C',
                              style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w700))
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          FutureBuilder(
              future: openWeatherMapApi.getWeatherMultipleDays(
                  widget.latitude, widget.longitude),
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
                Iterable<Weather> weathers = snapshot.data!;
                final List<Widget> listTiles = weathers.map((weather) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Text(_dateFormatter.format(weather.date)),
                          Text(_timeFormatter.format(weather.date)),
                          Image.network(
                            openWeatherMapApi.getIconUrl(weather.icon),
                            width: 100,
                            height: 100,
                          ),
                          Text(weather.description),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('${weather.tempmin}°C',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(width: 10),
                              const Text('|', style: TextStyle(fontSize: 14)),
                              const SizedBox(width: 10),
                              Text('${weather.tempmax}°C',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList();
                return CustomScrollbarWithSingleChildScrollView(
                  controller: _horizontalScrollController,
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: listTiles,
                  ),
                );
              })
        ],
      ),
    );
  }
}

class CustomScrollbarWithSingleChildScrollView extends StatelessWidget {
  const CustomScrollbarWithSingleChildScrollView({
    required this.controller,
    required this.child,
    required this.scrollDirection,
    super.key,
  });

  final ScrollController controller;
  final Widget child;
  final Axis scrollDirection;

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const CustomScrollBehavior(),
      child: Scrollbar(
        controller: controller,
        child: SingleChildScrollView(
          controller: controller,
          scrollDirection: scrollDirection,
          child: child,
        ),
      ),
    );
  }
}

class CustomScrollBehavior extends MaterialScrollBehavior {
  const CustomScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
        PointerDeviceKind.unknown,
      };
}
