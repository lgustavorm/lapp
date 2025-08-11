import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../models/telemetry_data.dart';

class TelemetryService {
  static final TelemetryService _instance = TelemetryService._internal();
  factory TelemetryService() => _instance;
  TelemetryService._internal();

  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  StreamSubscription<Position>? _gpsSubscription;
  final List<TelemetryData> _telemetryData = [];

  // Stream para notificar mudanças nos dados
  final StreamController<List<TelemetryData>> _dataController =
      StreamController<List<TelemetryData>>.broadcast();

  Stream<List<TelemetryData>> get telemetryStream => _dataController.stream;
  List<TelemetryData> get currentData => List.unmodifiable(_telemetryData);

  // Inicia a captura de dados
  Future<void> startTelemetry() async {
    // Verifica permissões
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Serviços de localização desabilitados');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Permissão de localização negada');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Permissão de localização negada permanentemente');
    }

    // Configura GPS para alta precisão
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 1, // 1 metro
    );

    // Inicia captura do GPS
    _gpsSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen(_onPositionUpdate);

    // Inicia captura do acelerômetro
    _accelerometerSubscription =
        accelerometerEventStream().listen(_onAccelerometerUpdate);
  }

  // Para a captura de dados
  void stopTelemetry() {
    _accelerometerSubscription?.cancel();
    _gpsSubscription?.cancel();
    _telemetryData.clear();
    _dataController.add(_telemetryData);
  }

  // Limpa os dados
  void clearData() {
    _telemetryData.clear();
    _dataController.add(_telemetryData);
  }

  // Callback para atualizações de posição
  void _onPositionUpdate(Position position) {
    // Converte velocidade de m/s para km/h
    final speedKmh = position.speed * 3.6;

    // Cria dados de telemetria com velocidade atual
    final telemetryData = TelemetryData.fromSensors(
      timestamp: position.timestamp ?? DateTime.now(),
      latitude: position.latitude,
      longitude: position.longitude,
      speed: speedKmh,
      accelerationX: 0, // Será atualizado pelo acelerômetro
      accelerationY: 0,
      accelerationZ: 0,
    );

    _addTelemetryData(telemetryData);
  }

  // Callback para atualizações do acelerômetro
  void _onAccelerometerUpdate(AccelerometerEvent event) {
    if (_telemetryData.isNotEmpty) {
      // Atualiza o último registro com dados do acelerômetro
      final lastData = _telemetryData.last;
      final updatedData = TelemetryData.fromSensors(
        timestamp: lastData.timestamp,
        latitude: lastData.latitude,
        longitude: lastData.longitude,
        speed: lastData.speed,
        accelerationX: event.x,
        accelerationY: event.y,
        accelerationZ: event.z,
      );

      // Substitui o último registro
      _telemetryData[_telemetryData.length - 1] = updatedData;
      _dataController.add(_telemetryData);
    }
  }

  // Adiciona dados de telemetria
  void _addTelemetryData(TelemetryData data) {
    _telemetryData.add(data);
    _dataController.add(_telemetryData);
  }

  // Calcula estatísticas dos dados
  Map<String, double> calculateStats() {
    if (_telemetryData.isEmpty) {
      return {
        'maxSpeed': 0,
        'avgSpeed': 0,
        'maxGForce': 0,
        'avgGForce': 0,
        'maxLateralG': 0,
        'maxLongitudinalG': 0,
      };
    }

    final speeds = _telemetryData.map((d) => d.speed).toList();
    final gForces = _telemetryData.map((d) => d.gForceTotal).toList();
    final lateralG = _telemetryData.map((d) => d.gForceLateral).toList();
    final longitudinalG =
        _telemetryData.map((d) => d.gForceLongitudinal).toList();

    return {
      'maxSpeed': speeds.reduce((a, b) => a > b ? a : b),
      'avgSpeed': speeds.reduce((a, b) => a + b) / speeds.length,
      'maxGForce': gForces.reduce((a, b) => a > b ? a : b),
      'avgGForce': gForces.reduce((a, b) => a + b) / gForces.length,
      'maxLateralG': lateralG.reduce((a, b) => a > b ? a : b),
      'maxLongitudinalG': longitudinalG.reduce((a, b) => a > b ? a : b),
    };
  }

  // Libera recursos
  void dispose() {
    stopTelemetry();
    _dataController.close();
  }
}
