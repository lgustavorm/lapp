import 'package:google_maps_flutter/google_maps_flutter.dart';

class Track {
  final String id;
  final String name;
  final LatLng finishLineStart;
  final LatLng finishLineEnd;

  Track({
    required this.id,
    required this.name,
    required this.finishLineStart,
    required this.finishLineEnd,
  });

  bool get isFinishLineSet =>
      true; // Agora sempre será verdade se o objeto existe

  // Converte um objeto Track em um Map.
  // As chaves devem corresponder aos nomes das colunas no banco de dados.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'finishLineStartLat': finishLineStart.latitude,
      'finishLineStartLng': finishLineStart.longitude,
      'finishLineEndLat': finishLineEnd.latitude,
      'finishLineEndLng': finishLineEnd.longitude,
    };
  }

  // Construtor nomeado para criar um Track a partir de um Map.
  factory Track.fromMap(Map<String, dynamic> map) {
    return Track(
      id: map['id'],
      name: map['name'],
      finishLineStart:
          LatLng(map['finishLineStartLat'], map['finishLineStartLng']),
      finishLineEnd: LatLng(map['finishLineEndLat'], map['finishLineEndLng']),
    );
  }
}
