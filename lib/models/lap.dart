class Lap {
  final int number;
  final Duration time;
  final double? averageSpeed;
  final DateTime timestamp;

  Lap({
    required this.number,
    required this.time,
    this.averageSpeed,
    required this.timestamp,
  });
}
