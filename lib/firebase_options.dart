// ARQUIVO PROVISÓRIO.
// Substitua rodando `flutterfire configure` na raiz do projeto
// (veja o README). O comando gera este arquivo com as chaves do seu projeto.
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    return android;
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyABXMWBF8iIrgSP7klk0COppNqvV8jqTRk',
    appId: '1:1091931343398:android:2df20c99114188ecc534e7',
    messagingSenderId: '1091931343398',
    projectId: 'gerenciador-de-tarefas-a1b50',
    databaseURL: 'https://gerenciador-de-tarefas-a1b50-default-rtdb.firebaseio.com',
    storageBucket: 'gerenciador-de-tarefas-a1b50.firebasestorage.app',
  );
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAQVXox__3V-Z-F2Hx2N3x_QDSzNe0nBcc',
    appId: '1:1091931343398:web:8ed7747051ae4d30c534e7',
    messagingSenderId: '1091931343398',
    projectId: 'gerenciador-de-tarefas-a1b50',
    authDomain: 'gerenciador-de-tarefas-a1b50.firebaseapp.com',
    databaseURL: 'https://gerenciador-de-tarefas-a1b50-default-rtdb.firebaseio.com',
    storageBucket: 'gerenciador-de-tarefas-a1b50.firebasestorage.app',
    measurementId: 'G-8F2TQ640Q2',
  );
}
