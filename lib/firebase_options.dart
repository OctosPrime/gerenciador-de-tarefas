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
    apiKey: 'SUA_API_KEY',
    appId: 'SEU_APP_ID',
    messagingSenderId: 'SEU_SENDER_ID',
    projectId: 'SEU_PROJECT_ID',
    databaseURL: 'https://SEU_PROJECT_ID-default-rtdb.firebaseio.com',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'SUA_API_KEY',
    appId: 'SEU_APP_ID',
    messagingSenderId: 'SEU_SENDER_ID',
    projectId: 'SEU_PROJECT_ID',
    authDomain: 'SEU_PROJECT_ID.firebaseapp.com',
    databaseURL: 'https://SEU_PROJECT_ID-default-rtdb.firebaseio.com',
  );
}
