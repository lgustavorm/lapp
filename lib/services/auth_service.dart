import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Stream para acompanhar mudanças no estado de autenticação
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Usuário atual
  User? get currentUser => _auth.currentUser;

  // Login com Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Inicia o processo de login do Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) return null;

      // Obtém os detalhes da autenticação
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Cria as credenciais do Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Faz login no Firebase
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      print('Erro no login com Google: $e');
      return null;
    }
  }

  // Login com email e senha
  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      print('Erro no login com email: $e');
      return null;
    }
  }

  // Registro com email e senha
  Future<UserCredential?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      print('Erro no registro: $e');
      return null;
    }
  }

  // Logout
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      print('Erro no logout: $e');
    }
  }

  // Verifica se o usuário está logado
  bool get isLoggedIn => _auth.currentUser != null;
}
