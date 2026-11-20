import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../models/tarefa.dart';

/// CRUD das tarefas no Realtime Database.
/// As tarefas ficam em /tarefas/{uid}/{idTarefa}, então cada usuário
/// só acessa o próprio nó (reforçado pelas regras em database.rules.json).
class FirebaseService {
  DatabaseReference get _ref {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseDatabase.instance.ref('tarefas/$uid');
  }

  /// Listener em tempo real da lista de tarefas.
  Stream<List<Tarefa>> tarefasStream() {
    return _ref.onValue.map((event) {
      final data = event.snapshot.value;
      if (data is! Map) return <Tarefa>[];
      final lista = data.entries
          .map((e) => Tarefa.fromMap(e.key as String, e.value as Map))
          .toList();
      lista.sort((a, b) => a.dataVencimento.compareTo(b.dataVencimento));
      return lista;
    });
  }

  Future<void> adicionar(Tarefa t) async {
    final novo = _ref.push();
    t.id = novo.key;
    await novo.set(t.toMap());
  }

  Future<void> atualizar(Tarefa t) => _ref.child(t.id!).update(t.toMap());

  Future<void> excluir(String id) => _ref.child(id).remove();

  Future<void> alternarSituacao(Tarefa t) =>
      _ref.child(t.id!).update({'concluida': !t.concluida});
}
