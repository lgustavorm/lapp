import 'package:flutter/material.dart';
import '../models/lap.dart';
import 'package:csv/csv.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ResultsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as ResultsScreenArgs?;
    final laps = args?.laps ?? [];
    final totalTime = laps.fold<Duration>(
      Duration.zero,
      (sum, lap) => sum + lap.time,
    );
    final bestLap =
        laps.isNotEmpty ? laps.reduce((a, b) => a.time < b.time ? a : b) : null;

    return Scaffold(
      appBar: AppBar(title: Text('Resultados da Sessão')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tempo Total: ${_formatDuration(totalTime)}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 8),
            if (bestLap != null)
              Text(
                'Melhor Volta: ${_formatDuration(bestLap.time)} (Volta ${bestLap.number})',
                style: TextStyle(fontSize: 18, color: Colors.green),
              ),
            SizedBox(height: 16),
            Text(
              'Voltas:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Expanded(
              child: laps.isEmpty
                  ? Center(child: Text('Nenhuma volta registrada.'))
                  : ListView.builder(
                      itemCount: laps.length,
                      itemBuilder: (context, index) {
                        final lap = laps[index];
                        return ListTile(
                          title: Text('Volta ${lap.number}'),
                          subtitle: Text(
                            'Tempo: ${_formatDuration(lap.time)}',
                          ),
                          trailing:
                              bestLap != null && lap.number == bestLap.number
                                  ? Icon(Icons.star, color: Colors.green)
                                  : null,
                        );
                      },
                    ),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              icon: Icon(Icons.file_download),
              label: Text('Exportar CSV'),
              onPressed: () async {
                await _exportCsv(context, laps);
              },
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, ModalRoute.withName('/'));
              },
              child: Text('Voltar ao Início'),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String threeDigits(int n) => n.toString().padLeft(3, '0');
    return "${twoDigits(d.inMinutes)}:${twoDigits(d.inSeconds % 60)}.${threeDigits(d.inMilliseconds % 1000)}";
  }

  Future<void> _exportCsv(BuildContext context, List<Lap> laps) async {
    List<List<dynamic>> rows = [
      ['Volta', 'Tempo (mm:ss.SSS)', 'Timestamp'],
      ...laps.map(
        (lap) => [
          lap.number,
          _formatDuration(lap.time),
          lap.timestamp.toIso8601String(),
        ],
      ),
    ];
    String csvData = const ListToCsvConverter().convert(rows);
    final dir = await getTemporaryDirectory();
    final path = '${dir.path}/lapp_resultados.csv';
    final file = File(path);
    await file.writeAsString(csvData);
    await Share.shareXFiles([XFile(path)], text: 'Resultados da sessão - Lapp');
  }
}

class ResultsScreenArgs {
  final List<Lap> laps;
  ResultsScreenArgs({required this.laps});
}
