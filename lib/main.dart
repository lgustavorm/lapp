import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'firebase_options.dart';
// Remova as importações antigas que não são mais usadas aqui
// import 'screens/home_screen.dart';
// import 'screens/session_screen.dart';
// import 'screens/results_screen.dart';

// Adicione a importação para a nova tela inicial
import 'screens/auth_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o Firebase com as configurações geradas
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Configura o Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  // Captura erros não tratados
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  // Solicita permissões necessárias
  await _requestPermissions();

  runApp(const LappApp());
}

Future<void> _requestPermissions() async {
  // Solicita permissão de localização
  await Permission.location.request();

  // Solicita permissão de localização em segundo plano (Android)
  await Permission.locationAlways.request();

  // Solicita permissão de armazenamento (para salvar arquivos)
  await Permission.storage.request();
}

class LappApp extends StatelessWidget {
  // O construtor foi adicionado para seguir as boas práticas do Flutter.
  const LappApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lapp',
      // Seu tema personalizado foi mantido exatamente como estava.
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.red[800],
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.red).copyWith(
          secondary: Colors.redAccent,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.red[800],
          foregroundColor: Colors.white,
          elevation: 4,
          titleTextStyle: const TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red[700],
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        fontFamily: 'Roboto',
      ),
      // AQUI ESTÁ A MUDANÇA PRINCIPAL:
      // Definimos a TrackListScreen como a tela inicial.
      // Removemos 'initialRoute' e 'routes' para simplificar,
      // já que a navegação agora é gerenciada dentro das próprias telas.
      home: const AuthWrapper(),
    );
  }
}
