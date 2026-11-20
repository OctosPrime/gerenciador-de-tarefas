import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../models/usuario.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get usuarioAtual => _auth.currentUser;

  Future<void> cadastrar(String nome, String email, String senha) async {
    final cred = await _auth.createUserWithEmailAndPassword(
        email: email, password: senha);
    await cred.user!.updateDisplayName(nome);
    final usuario = Usuario(uid: cred.user!.uid, nome: nome, email: email);
    await _db.child('usuarios/${usuario.uid}').set(usuario.toMap());
  }

  Future<void> login(String email, String senha) async {
    await _auth.signInWithEmailAndPassword(email: email, password: senha);
  }

  Future<void> logout() => _auth.signOut();

  Future<Usuario?> buscarUsuario() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    final snap = await _db.child('usuarios/${user.uid}').get();
    if (snap.exists && snap.value is Map) {
      return Usuario.fromMap(user.uid, snap.value as Map);
    }
    return Usuario(
        uid: user.uid, nome: user.displayName ?? '', email: user.email ?? '');
  }

  static String mensagemErro(Object e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'invalid-email':
          return 'E-mail inválido.';
        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-credential':
          return 'E-mail ou senha incorretos.';
        case 'email-already-in-use':
          return 'Este e-mail já está cadastrado.';
        case 'weak-password':
          return 'A senha deve ter pelo menos 6 caracteres.';
        case 'network-request-failed':
          return 'Sem conexão com a internet.';
        default:
          return 'Erro: ${e.message}';
      }
    }
    return 'Erro inesperado: $e';
  }
}
