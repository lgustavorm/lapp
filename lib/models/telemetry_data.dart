import 'dart:math';

class TelemetryData {
  final DateTime timestamp;
  final double latitude;
  final double longitude;
  final double speed; // km/h
  final double accelerationX; // m/s²
  final double accelerationY; // m/s²
  final double accelerationZ; // m/s²
  final double gForceLateral; // G lateral (curvas)
  final double gForceLongitudinal; // G longitudinal (aceleração/frenagem)
  final double gForceTotal; // G total

  TelemetryData({
    required this.timestamp,
    required this.latitude,
    required this.longitude,
    required this.speed,
    required this.accelerationX,
    required this.accelerationY,
    required this.accelerationZ,
    required this.gForceLateral,
    required this.gForceLongitudinal,
    required this.gForceTotal,
  });

  // Converte aceleração para força G
  static double calculateGForce(double acceleration) {
    return acceleration / 9.81; // 9.81 m/s² = 1G
  }

  // Calcula força G total a partir dos 3 eixos
  static double calculateTotalGForce(double x, double y, double z) {
    return sqrt(x * x + y * y + z * z) / 9.81;
  }

  // Calcula força G lateral (curvas)
  static double calculateLateralGForce(double x, double y) {
    return sqrt(x * x + y * y) / 9.81;
  }

  // Calcula força G longitudinal (aceleração/frenagem)
  static double calculateLongitudinalGForce(double z) {
    return z / 9.81;
  }

  // Converte para Map para salvar no banco
  Map<String, dynamic> toMap() {
    return {
      'timestamp': timestamp.millisecondsSinceEpoch,
      'latitude': latitude,
      'longitude': longitude,
      'speed': speed,
      'accelerationX': accelerationX,
      'accelerationY': accelerationY,
      'accelerationZ': accelerationZ,
      'gForceLateral': gForceLateral,
      'gForceLongitudinal': gForceLongitudinal,
      'gForceTotal': gForceTotal,
    };
  }

  // Cria a partir de Map do banco
  factory TelemetryData.fromMap(Map<String, dynamic> map) {
    return TelemetryData(
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
      latitude: map['latitude'],
      longitude: map['longitude'],
      speed: map['speed'],
      accelerationX: map['accelerationX'],
      accelerationY: map['accelerationY'],
      accelerationZ: map['accelerationZ'],
      gForceLateral: map['gForceLateral'],
      gForceLongitudinal: map['gForceLongitudinal'],
      gForceTotal: map['gForceTotal'],
    );
  }

  // Cria dados de telemetria a partir de GPS e acelerômetro
  factory TelemetryData.fromSensors({
    required DateTime timestamp,
    required double latitude,
    required double longitude,
    required double speed,
    required double accelerationX,
    required double accelerationY,
    required double accelerationZ,
  }) {
    final gForceLateral = calculateLateralGForce(accelerationX, accelerationY);
    final gForceLongitudinal = calculateLongitudinalGForce(accelerationZ);
    final gForceTotal =
        calculateTotalGForce(accelerationX, accelerationY, accelerationZ);

    return TelemetryData(
      timestamp: timestamp,
      latitude: latitude,
      longitude: longitude,
      speed: speed,
      accelerationX: accelerationX,
      accelerationY: accelerationY,
      accelerationZ: accelerationZ,
      gForceLateral: gForceLateral,
      gForceLongitudinal: gForceLongitudinal,
      gForceTotal: gForceTotal,
    );
  }
}
