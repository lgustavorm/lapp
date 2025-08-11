import 'lap.dart';

class Session {
  final String id;
  final String? trackName;
  final DateTime startTime;
  final List<Lap> laps;

  Session({
    required this.id,
    this.trackName,
    required this.startTime,
    required this.laps,
  });
}
