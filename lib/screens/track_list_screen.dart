import 'package:flutter/material.dart';
import '../helpers/database_helper.dart'; // Importe o helper
import '../models/track.dart'; // Importe o modelo
import 'mark_finish_line_screen.dart'; // Importe a tela de marcação
import 'session_screen.dart'; // Importe a tela de sessão
import 'dashboard_screen.dart'; // Importe a tela do dashboard
import 'package:uuid/uuid.dart'; // Pacote para gerar IDs únicos
import '../helpers/crashlytics_helper.dart'; // Importe o helper do Crashlytics
import '../services/auth_service.dart'; // Importe o serviço de autenticação

class TrackListScreen extends StatefulWidget {
  const TrackListScreen({Key? key}) : super(key: key);

  @override
  _TrackListScreenState createState() => _TrackListScreenState();
}

class _TrackListScreenState extends State<TrackListScreen> {
  // Usamos um FutureBuilder para lidar com o carregamento assíncrono dos dados
  late Future<List<Track>> _tracksFuture;

  @override
  void initState() {
    super.initState();
    CrashlyticsHelper.log('TrackListScreen: initState iniciado');
    _loadTracks();
  }

  void _loadTracks() {
    CrashlyticsHelper.log(
        'TrackListScreen: Carregando pistas do banco de dados');
    // Pega a instância do banco de dados e busca as pistas
    setState(() {
      _tracksFuture = DatabaseHelper.instance.getAllTracks();
    });
  }

  void _navigateAndCreateTrack() async {
    CrashlyticsHelper.log(
        'TrackListScreen: Navegando para MarkFinishLineScreen');
    try {
      // Navega para a tela de marcação de linha
      final result = await Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const MarkFinishLineScreen()),
      );

      if (result != null && result is Map<String, dynamic>) {
        CrashlyticsHelper.log(
            'TrackListScreen: Linha de chegada marcada, mostrando dialog');
        // Se o usuário salvou uma linha, pedimos um nome para a pista
        _showCreateTrackDialog(result);
      } else {
        CrashlyticsHelper.log(
            'TrackListScreen: Usuário cancelou marcação da linha');
      }
    } catch (e, stackTrace) {
      CrashlyticsHelper.recordError(e, stackTrace,
          reason: 'Erro ao navegar para MarkFinishLineScreen');
    }
  }

  void _showCreateTrackDialog(Map<String, dynamic> linePoints) {
    CrashlyticsHelper.log(
        'TrackListScreen: Mostrando dialog para nome da pista');
    final TextEditingController nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nome da Pista'),
          content: TextField(
            controller: nameController,
            autofocus: true,
            decoration:
                const InputDecoration(hintText: "Ex: Kartódromo de Interlagos"),
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                CrashlyticsHelper.log(
                    'TrackListScreen: Usuário cancelou criação da pista');
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Salvar'),
              onPressed: () {
                final trackName = nameController.text;
                if (trackName.isNotEmpty) {
                  try {
                    CrashlyticsHelper.log(
                        'TrackListScreen: Salvando nova pista: $trackName');
                    final newTrack = Track(
                      id: const Uuid().v4(), // Gera um ID único
                      name: trackName,
                      finishLineStart: linePoints['start'],
                      finishLineEnd: linePoints['end'],
                    );
                    // Salva no banco de dados
                    DatabaseHelper.instance.insertTrack(newTrack);
                    CrashlyticsHelper.log(
                        'TrackListScreen: Pista salva com sucesso');
                    Navigator.of(context).pop();
                    _loadTracks(); // Recarrega a lista de pistas
                  } catch (e, stackTrace) {
                    CrashlyticsHelper.recordError(e, stackTrace,
                        reason: 'Erro ao salvar pista no banco de dados');
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Pistas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const DashboardScreen(),
                ),
              );
            },
            tooltip: 'Dashboard',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              try {
                await AuthService().signOut();
                // O AuthWrapper vai automaticamente redirecionar para a tela de login
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Erro ao fazer logout: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            tooltip: 'Sair',
          ),
        ],
      ),
      body: FutureBuilder<List<Track>>(
        future: _tracksFuture,
        builder: (context, snapshot) {
          // Enquanto os dados estão carregando
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // Se ocorreu um erro
          if (snapshot.hasError) {
            return Center(
                child: Text('Erro ao carregar as pistas: ${snapshot.error}'));
          }
          // Se os dados foram carregados com sucesso
          if (snapshot.hasData) {
            final tracks = snapshot.data!;
            // Se não há pistas salvas
            if (tracks.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Nenhuma pista salva ainda.',
                        style: TextStyle(fontSize: 18)),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _navigateAndCreateTrack,
                      child: const Text('Criar Primeira Pista'),
                    ),
                  ],
                ),
              );
            }
            // Se há pistas, exibe a lista
            return ListView.builder(
              itemCount: tracks.length,
              itemBuilder: (context, index) {
                final track = tracks[index];
                return ListTile(
                  title: Text(track.name),
                  leading: const Icon(Icons.flag),
                  onTap: () {
                    // Navega para a tela de sessão com a pista selecionada
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SessionScreen(track: track),
                      ),
                    );
                  },
                );
              },
            );
          }
          // Estado padrão
          return const Center(child: Text('Algo deu errado.'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateAndCreateTrack,
        child: const Icon(Icons.add),
        tooltip: 'Adicionar Nova Pista',
      ),
    );
  }
}
