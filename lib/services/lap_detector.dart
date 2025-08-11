import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math';

/// Classe responsável por detectar a conclusão de uma volta.
///
/// Utiliza um algoritmo geométrico para verificar se o segmento de movimento
/// do usuário cruza o segmento da linha de chegada.
class LapDetector {
  final LatLng finishLineStart;
  final LatLng finishLineEnd;

  LapDetector({
    required this.finishLineStart,
    required this.finishLineEnd,
  });

  /// Verifica se uma volta foi completada, dado o movimento do usuário.
  ///
  /// [lastPosition] é a última posição GPS registrada.
  /// [currentPosition] é a posição GPS atual.
  /// Retorna `true` se o movimento cruzar a linha de chegada.
  bool hasCompletedLap(LatLng lastPosition, LatLng currentPosition) {
    // O movimento do usuário é um segmento de lastPosition para currentPosition.
    // A linha de chegada é um segmento de finishLineStart para finishLineEnd.
    // A volta é completada se esses dois segmentos se cruzarem.
    return _doIntersect(
        lastPosition, currentPosition, finishLineStart, finishLineEnd);
  }

  // --- Lógica Geométrica de Intersecção ---

  /// Função auxiliar para verificar se um ponto `q` está no segmento `pr`.
  /// Isso é usado apenas quando os pontos são colineares.
  bool _onSegment(LatLng p, LatLng q, LatLng r) {
    return (q.latitude <= max(p.latitude, r.latitude) &&
        q.latitude >= min(p.latitude, r.latitude) &&
        q.longitude <= max(p.longitude, r.longitude) &&
        q.longitude >= min(p.longitude, r.longitude));
  }

  /// Calcula a orientação de um trio ordenado de pontos (p, q, r).
  /// A função retorna um dos seguintes valores:
  /// 0 --> p, q e r são colineares
  /// 1 --> Sentido horário
  /// 2 --> Sentido anti-horário
  int _orientation(LatLng p, LatLng q, LatLng r) {
    // Esta é uma implementação do produto vetorial para determinar a orientação.
    double val = (q.longitude - p.longitude) * (r.latitude - q.latitude) -
        (q.latitude - p.latitude) * (r.longitude - q.longitude);

    if (val.abs() < 1e-10)
      return 0; // Colinear (usamos uma tolerância para pontos flutuantes)

    return (val > 0) ? 1 : 2; // Horário ou Anti-horário
  }

  /// A função principal que retorna `true` se os segmentos de linha
  /// 'p1q1' e 'p2q2' se interceptam.
  bool _doIntersect(LatLng p1, LatLng q1, LatLng p2, LatLng q2) {
    // Encontra as quatro orientações necessárias para os casos gerais e especiais.
    int o1 = _orientation(p1, q1, p2);
    int o2 = _orientation(p1, q1, q2);
    int o3 = _orientation(p2, q2, p1);
    int o4 = _orientation(p2, q2, q1);

    // Caso Geral:
    // Se as orientações (p1,q1,p2) e (p1,q1,q2) são diferentes, E
    // as orientações (p2,q2,p1) e (p2,q2,q1) também são diferentes.
    if (o1 != o2 && o3 != o4) {
      return true;
    }

    // Casos Especiais (quando os pontos são colineares):
    // o1, o2, o3, ou o4 podem ser 0 se os pontos forem colineares.
    // Precisamos verificar se um segmento "toca" o outro.

    // p1, q1 e p2 são colineares e p2 está no segmento p1q1
    if (o1 == 0 && _onSegment(p1, p2, q1)) return true;

    // p1, q1 e q2 são colineares e q2 está no segmento p1q1
    if (o2 == 0 && _onSegment(p1, q2, q1)) return true;

    // p2, q2 e p1 são colineares e p1 está no segmento p2q2
    if (o3 == 0 && _onSegment(p2, p1, q2)) return true;

    // p2, q2 e q1 são colineares e q1 está no segmento p2q2
    if (o4 == 0 && _onSegment(p2, q1, q2)) return true;

    // Se nenhum dos casos acima for verdadeiro, eles não se interceptam.
    return false;
  }
}
