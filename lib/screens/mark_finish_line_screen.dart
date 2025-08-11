import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkFinishLineScreen extends StatefulWidget {
  // A posição inicial do mapa, recebida da tela anterior.
  final LatLng initialCameraPosition;

  const MarkFinishLineScreen({
    Key? key,
    // Usamos uma localização padrão caso nenhuma seja fornecida.
    this.initialCameraPosition = const LatLng(-23.5505, -46.6333),
  }) : super(key: key);

  @override
  _MarkFinishLineScreenState createState() => _MarkFinishLineScreenState();
}

class _MarkFinishLineScreenState extends State<MarkFinishLineScreen> {
  LatLng? _finishLineStart;
  LatLng? _finishLineEnd;

  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  /// Lida com o toque do usuário no mapa para definir os pontos.
  void _handleMapTap(LatLng tappedPoint) {
    setState(() {
      // Se o ponto inicial não foi definido, ou se ambos já foram definidos (e o usuário quer recomeçar)
      if (_finishLineStart == null ||
          (_finishLineStart != null && _finishLineEnd != null)) {
        _finishLineStart = tappedPoint;
        _finishLineEnd =
            null; // Limpa o ponto final para começar uma nova linha
      }
      // Se o ponto inicial já foi definido, mas o final não
      else {
        _finishLineEnd = tappedPoint;
      }
      _updateMapElements();
    });
  }

  /// Atualiza os marcadores e a linha no mapa com base nos pontos definidos.
  void _updateMapElements() {
    _markers.clear();
    _polylines.clear();

    if (_finishLineStart != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('finish_line_start'),
          position: _finishLineStart!,
          infoWindow: const InfoWindow(title: 'Início da Linha'),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ),
      );
    }

    if (_finishLineEnd != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('finish_line_end'),
          position: _finishLineEnd!,
          infoWindow: const InfoWindow(title: 'Fim da Linha'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );

      // Desenha a linha no mapa
      _polylines.add(
        Polyline(
          polylineId: const PolylineId('finish_line_polyline'),
          points: [_finishLineStart!, _finishLineEnd!],
          color: Colors.blue,
          width: 5,
        ),
      );
    }
  }

  /// Salva os pontos e retorna para a tela anterior.
  void _saveFinishLine() {
    if (_finishLineStart != null && _finishLineEnd != null) {
      // Retorna um mapa com os dois pontos para a tela anterior.
      Navigator.of(context).pop({
        'start': _finishLineStart,
        'end': _finishLineEnd,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Verifica se o botão de salvar deve estar ativo.
    final bool isFinishLineSet =
        _finishLineStart != null && _finishLineEnd != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Marcar Linha de Chegada'),
        actions: [
          // Adiciona um botão para limpar a seleção
          if (_finishLineStart != null)
            IconButton(
              icon: const Icon(Icons.delete),
              tooltip: 'Limpar Seleção',
              onPressed: () {
                setState(() {
                  _finishLineStart = null;
                  _finishLineEnd = null;
                  _updateMapElements();
                });
              },
            ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: widget.initialCameraPosition,
              zoom: 15,
            ),
            onTap: _handleMapTap,
            markers: _markers,
            polylines: _polylines,
          ),
          Positioned(
            top: 10,
            left: 10,
            right: 10,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _finishLineStart == null
                      ? 'Toque no mapa para marcar o INÍCIO da linha de chegada.'
                      : 'Agora toque para marcar o FIM da linha.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed:
            isFinishLineSet ? _saveFinishLine : null, // Ativa/desativa o botão
        label: const Text('Salvar Linha'),
        icon: const Icon(Icons.check),
        backgroundColor:
            isFinishLineSet ? Theme.of(context).primaryColor : Colors.grey,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
