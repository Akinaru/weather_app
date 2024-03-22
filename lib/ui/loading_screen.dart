import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';

import '../services/geolocation_service.dart';
import 'search_page.dart';
import 'weather_page.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    getLocationData();
  }

  Future<void> getLocationData() async {
    final geolocationService =
        Provider.of<GeolocationService>(context, listen: false);
    try {
      final Position? position = await geolocationService.getCurrentPosition();
      if (position != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => WeatherPage(
                  locationName: 'Votre position',
                  latitude: position.latitude,
                  longitude: position.longitude)),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SearchPage()),
        );
      }
    } catch (e) {
      print('Error getting location data: $e');
      // Handle error, maybe navigate to a default page
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
