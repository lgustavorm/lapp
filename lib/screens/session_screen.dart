import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart'; // Para formatar o tempo
import '../models/track.dart'; // Importe seu modelo Track
import '../services/lap_detector.dart'; // Importe o novo LapDetector
import '../services/telemetry_service.dart'; // Importe o TelemetryService
import '../models/lap.dart'; // Importe seu modelo Lap
// Importe a tela de resultados se for usá-la
// import 'results_screen.dart';

class SessionScreen extends StatefulWidget {
  final Track track;

  const SessionScreen({Key? key, required this.track}) : super(key: key);

  @override
  _SessionScreenState createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  late final LapDetector _lapDetector;
  final TelemetryService _telemetryService = TelemetryService();
  StreamSubscription<Position>? _positionStreamSubscription;

  final Stopwatch _totalStopwatch = Stopwatch();
  final Stopwatch _lapStopwatch = Stopwatch();

  Timer? _uiTimer;

  List<Lap> _laps = [];
  LatLng? _lastPosition;

  bool _isSessionRunning = false;

  // Formatter para exibir o tempo de forma bonita
  final DateFormat _timeFormatter = DateFormat('mm:ss.SS');

  @override
  void initState() {
    super.initState();
    // Garante que a linha de chegada foi definida antes de iniciar
    if (widget.track.isFinishLineSet) {
      _lapDetector = LapDetector(
        finishLineStart: widget.track.finishLineStart!,
        finishLineEnd: widget.track.finishLineEnd!,
      );
    }
    // Inicia a sessão assim que a tela é construída
    _startSession();
  }

  @override
  void dispose() {
    // É CRUCIAL parar tudo para evitar memory leaks
    _positionStreamSubscription?.cancel();
    _uiTimer?.cancel();
    _totalStopwatch.stop();
    _lapStopwatch.stop();
    _telemetryService.stopTelemetry();
    super.dispose();
  }

  void _startSession() {
    // Verifica permissões de localização
    _handleLocationPermission().then((hasPermission) {
      if (!hasPermission) {
        // Mostra um erro se não houver permissão
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Permissão de localização é necessária para iniciar a sessão.'),
        ));
        Navigator.of(context).pop(); // Volta para a tela anterior
        return;
      }

      setState(() {
        _isSessionRunning = true;
        _totalStopwatch.start();
        _lapStopwatch.start();

        // Inicia a captura de telemetria
        _telemetryService.startTelemetry().catchError((error) {
          print('Erro ao iniciar telemetria: $error');
        });

        // Timer para atualizar a UI a cada 100ms
        _uiTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
          if (mounted) {
            setState(() {});
          }
        });

        // Ouve as atualizações de GPS
        final LocationSettings locationSettings = LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 1, // Atualiza a cada 1 metro
        );
        _positionStreamSubscription =
            Geolocator.getPositionStream(locationSettings: locationSettings)
                .listen((Position position) {
          _onNewPosition(position);
        });
      });
    });
  }

  void _onNewPosition(Position position) {
    if (!mounted) return;

    final currentPosition = LatLng(position.latitude, position.longitude);

    if (_lastPosition != null) {
      // A MÁGICA ACONTECE AQUI!
      final bool completedLap =
          _lapDetector.hasCompletedLap(_lastPosition!, currentPosition);

      if (completedLap) {
        setState(() {
          final lapTime = _lapStopwatch.elapsed;
          _laps.add(Lap(
            number: _laps.length + 1,
            time: lapTime,
            timestamp: DateTime.now(),
          ));
          _lapStopwatch.reset(); // Reinicia o cronómetro da volta
        });
      }
    }
    // Atualiza a última posição para a próxima verificação
    _lastPosition = currentPosition;
  }

  void _stopSession() {
    setState(() {
      _isSessionRunning = false;
      _positionStreamSubscription?.cancel();
      _uiTimer?.cancel();
      _totalStopwatch.stop();
      _lapStopwatch.stop();

      // Opcional: navegar para a tela de resultados
      // Navigator.of(context).push(MaterialPageRoute(
      //   builder: (context) => ResultsScreen(laps: _laps),
      // ));
    });
  }

  /// Formata a duração para o formato mm:ss.SS
  String _formatDuration(Duration d) {
    return _timeFormatter.format(DateTime(0).add(d));
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.track.isFinishLineSet) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(
          child: Text(
              'Erro: A linha de chegada não foi definida para esta pista.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Sessão em: ${widget.track.name}'),
        backgroundColor: Colors.red[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Painel de tempos
            Card(
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Text('TEMPO TOTAL',
                        style: TextStyle(fontSize: 18, color: Colors.grey)),
                    Text(
                      _formatDuration(_totalStopwatch.elapsed),
                      style: const TextStyle(
                          fontSize: 56,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'monospace'),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            const Text('VOLTA ATUAL',
                                style: TextStyle(color: Colors.grey)),
                            Text(
                              _formatDuration(_lapStopwatch.elapsed),
                              style: const TextStyle(
                                  fontSize: 28, fontFamily: 'monospace'),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const Text('VOLTAS',
                                style: TextStyle(color: Colors.grey)),
                            Text(
                              _laps.length.toString(),
                              style: const TextStyle(
                                  fontSize: 28, fontFamily: 'monospace'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Lista de voltas completadas
            Expanded(
              child: ListView.builder(
                itemCount: _laps.length,
                itemBuilder: (context, index) {
                  final lap = _laps[index];
                  return ListTile(
                    leading: CircleAvatar(child: Text(lap.number.toString())),
                    title: const Text('Tempo da Volta'),
                    trailing: Text(
                      _formatDuration(lap.time),
                      style: const TextStyle(
                          fontSize: 18, fontFamily: 'monospace'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _stopSession,
        label: const Text('PARAR SESSÃO'),
        icon: const Icon(Icons.stop),
        backgroundColor: Colors.red[700],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  /// Função para verificar e pedir permissões de localização.
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Serviços de localização estão desativados. Por favor, ative-os.')));
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Permissão de localização negada.')));
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Permissão de localização negada permanentemente, não é possível pedir novamente.')));
      return false;
    }

    return true;
  }
}
