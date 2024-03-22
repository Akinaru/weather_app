import 'package:geolocator/geolocator.dart';

class GeolocationService {
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

  Future<Position?> getCurrentPosition() async {
    final status = await checkStatus();

    if (status != GeolocationStatus.available) {
      return null;
    }

    var position = await Geolocator.getLastKnownPosition();

    if (position != null) {
      return position;
    }

    return await Geolocator.getCurrentPosition();
  }
}

enum GeolocationStatus {
  available,
  disabled,
  denied,
  deniedForever,
}
