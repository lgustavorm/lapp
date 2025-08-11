import 'package:firebase_crashlytics/firebase_crashlytics.dart';

/// Helper para facilitar o uso do Firebase Crashlytics
class CrashlyticsHelper {
  static final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

  /// Registra um erro não fatal
  static void recordError(dynamic error, StackTrace? stackTrace,
      {String? reason}) {
    _crashlytics.recordError(error, stackTrace, reason: reason);
  }

  /// Registra uma mensagem de log
  static void log(String message) {
    _crashlytics.log(message);
  }

  /// Define um atributo customizado para o usuário
  static void setCustomKey(String key, dynamic value) {
    _crashlytics.setCustomKey(key, value);
  }

  /// Define o ID do usuário (útil para rastrear crashes por usuário)
  static void setUserIdentifier(String userId) {
    _crashlytics.setUserIdentifier(userId);
  }

  /// Registra uma exceção customizada
  static void recordException(dynamic exception, StackTrace? stackTrace) {
    _crashlytics.recordError(exception, stackTrace);
  }

  /// Força um crash para teste (use apenas em desenvolvimento)
  static void testCrash() {
    _crashlytics.crash();
  }
}
