enum Prioridade { baixa, media, alta }

extension PrioridadeExt on Prioridade {
  String get label {
    switch (this) {
      case Prioridade.baixa:
        return 'Baixa';
      case Prioridade.media:
        return 'Média';
      case Prioridade.alta:
        return 'Alta';
    }
  }
}

class Tarefa {
  String? id;
  String titulo;
  String descricao;
  DateTime dataVencimento;
  Prioridade prioridade;
  bool concluida;

  Tarefa({
    this.id,
    required this.titulo,
    required this.descricao,
    required this.dataVencimento,
    this.prioridade = Prioridade.media,
    this.concluida = false,
  });

  String get situacao => concluida ? 'Concluída' : 'Pendente';

  Map<String, dynamic> toMap() => {
        'titulo': titulo,
        'descricao': descricao,
        'dataVencimento': dataVencimento.toIso8601String(),
        'prioridade': prioridade.name,
        'concluida': concluida,
      };

  factory Tarefa.fromMap(String id, Map<dynamic, dynamic> map) {
    return Tarefa(
      id: id,
      titulo: map['titulo'] ?? '',
      descricao: map['descricao'] ?? '',
      dataVencimento:
          DateTime.tryParse(map['dataVencimento'] ?? '') ?? DateTime.now(),
      prioridade: Prioridade.values.firstWhere(
        (p) => p.name == map['prioridade'],
        orElse: () => Prioridade.media,
      ),
      concluida: map['concluida'] == true,
    );
  }
}
