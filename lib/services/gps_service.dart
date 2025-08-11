import 'package:geolocator/geolocator.dart';
import 'dart:async';

class GpsService {
  StreamSubscription<Position>? _positionStream;
  Function(Position)? onPositionUpdate;

  void startListening({required Function(Position) onUpdate}) async {
    onPositionUpdate = onUpdate;
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return;
    }
    _positionStream = Geolocator.getPositionStream(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
    ).listen((Position position) {
      if (onPositionUpdate != null) {
        onPositionUpdate!(position);
      }
    });
  }

  void stopListening() {
    _positionStream?.cancel();
    _positionStream = null;
  }
}
