import 'package:geolocator/geolocator.dart';

class GeolocationService {
  /// Donne le statut du service de localisation.
  Future<GeolocationStatus> checkStatus() async {
    final enabled = await Geolocator.isLocationServiceEnabled();

    if (!enabled) {
      return GeolocationStatus.disabled;
    }

    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return GeolocationStatus.denied;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return GeolocationStatus.deniedForever;
    }

    return GeolocationStatus.available;
  }

  /// Donne la position actuelle de l'appareil.
  Future<Position?> getCurrentPosition() async {
    final status = await checkStatus();

    if (status != GeolocationStatus.available) {
      return null;
    }

    Position? position;

    try {
      position = await Geolocator.getLastKnownPosition();
    } catch (_) {
      // Impossible de récupérer la dernière position connue, on ignore l'erreur.
    }

    if (position != null) {
      return position;
    }

    try {
      position = await Geolocator.getCurrentPosition();
    } catch (_) {
      // Impossible de récupérer la position actuelle, on ignore l'erreur.
    }

    return position;
  }
}

/// Représente les statuts du service de localisation.
enum GeolocationStatus {
  available,
  disabled,
  denied,
  deniedForever,
}
