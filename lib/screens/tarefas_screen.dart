import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/tarefa.dart';
import '../services/firebase_service.dart';
import 'cadastro_tarefa_screen.dart';

Color corPrioridade(Prioridade p) {
  switch (p) {
    case Prioridade.baixa:
      return Colors.green;
    case Prioridade.media:
      return Colors.orange;
    case Prioridade.alta:
      return Colors.red;
  }
}

final _fmt = DateFormat('dd/MM/yyyy');

class TarefasScreen extends StatelessWidget {
  const TarefasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = FirebaseService();
    return Scaffold(
      appBar: AppBar(title: const Text('Minhas tarefas')),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const CadastroTarefaScreen())),
      ),
      body: StreamBuilder<List<Tarefa>>(
        stream: service.tarefasStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final tarefas = snapshot.data!;
          if (tarefas.isEmpty) {
            return const Center(child: Text('Nenhuma tarefa cadastrada.'));
          }
          return ListView.builder(
            itemCount: tarefas.length,
            itemBuilder: (context, i) {
              final t = tarefas[i];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: ListTile(
                  leading: Icon(Icons.flag, color: corPrioridade(t.prioridade)),
                  title: Text(
                    t.titulo,
                    style: TextStyle(
                      decoration:
                          t.concluida ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  subtitle: Text(
                      'Vence: ${_fmt.format(t.dataVencimento)} • '
                      'Prioridade: ${t.prioridade.label}\n${t.situacao}'),
                  isThreeLine: true,
                  trailing: Checkbox(
                    value: t.concluida,
                    onChanged: (_) => service.alternarSituacao(t),
                  ),
                  onTap: () => _detalhes(context, service, t),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _detalhes(BuildContext context, FirebaseService service, Tarefa t) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.titulo),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t.descricao.isEmpty ? '(sem descrição)' : t.descricao),
            const SizedBox(height: 12),
            Text('Vencimento: ${_fmt.format(t.dataVencimento)}'),
            Row(children: [
              const Text('Prioridade: '),
              Icon(Icons.flag, size: 16, color: corPrioridade(t.prioridade)),
              Text(' ${t.prioridade.label}'),
            ]),
            Text('Situação: ${t.situacao}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final confirmar = await showDialog<bool>(
                context: context,
                builder: (c) => AlertDialog(
                  title: const Text('Excluir tarefa?'),
                  content: Text('"${t.titulo}" será removida.'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(c, false),
                        child: const Text('Cancelar')),
                    TextButton(
                        onPressed: () => Navigator.pop(c, true),
                        child: const Text('Excluir')),
                  ],
                ),
              );
              if (confirmar == true) await service.excluir(t.id!);
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => CadastroTarefaScreen(tarefa: t)));
            },
            child: const Text('Editar'),
          ),
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Fechar')),
        ],
      ),
    );
  }
}
