import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/tarefa.dart';
import '../services/firebase_service.dart';

/// Serve para cadastrar (tarefa == null) ou editar uma tarefa existente.
class CadastroTarefaScreen extends StatefulWidget {
  final Tarefa? tarefa;

  const CadastroTarefaScreen({super.key, this.tarefa});

  @override
  State<CadastroTarefaScreen> createState() => _CadastroTarefaScreenState();
}

class _CadastroTarefaScreenState extends State<CadastroTarefaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _service = FirebaseService();
  late final TextEditingController _tituloCtrl;
  late final TextEditingController _descCtrl;
  late DateTime _data;
  late Prioridade _prioridade;
  late bool _concluida;
  bool _salvando = false;

  bool get _editando => widget.tarefa != null;

  @override
  void initState() {
    super.initState();
    final t = widget.tarefa;
    _tituloCtrl = TextEditingController(text: t?.titulo ?? '');
    _descCtrl = TextEditingController(text: t?.descricao ?? '');
    _data = t?.dataVencimento ?? DateTime.now();
    _prioridade = t?.prioridade ?? Prioridade.media;
    _concluida = t?.concluida ?? false;
  }

  Future<void> _escolherData() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _data,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (d != null) setState(() => _data = d);
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _salvando = true);
    final tarefa = Tarefa(
      id: widget.tarefa?.id,
      titulo: _tituloCtrl.text.trim(),
      descricao: _descCtrl.text.trim(),
      dataVencimento: _data,
      prioridade: _prioridade,
      concluida: _concluida,
    );
    try {
      if (_editando) {
        await _service.atualizar(tarefa);
      } else {
        await _service.adicionar(tarefa);
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      setState(() => _salvando = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erro ao salvar: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_editando ? 'Editar tarefa' : 'Nova tarefa')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _tituloCtrl,
              decoration: const InputDecoration(
                  labelText: 'Título', border: OutlineInputBorder()),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Informe o título' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                  labelText: 'Descrição', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            ListTile(
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Theme.of(context).dividerColor),
                  borderRadius: BorderRadius.circular(4)),
              leading: const Icon(Icons.calendar_today),
              title: const Text('Data de vencimento'),
              subtitle: Text(DateFormat('dd/MM/yyyy').format(_data)),
              onTap: _escolherData,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<Prioridade>(
              initialValue: _prioridade,
              decoration: const InputDecoration(
                  labelText: 'Prioridade', border: OutlineInputBorder()),
              items: Prioridade.values
                  .map((p) => DropdownMenuItem(value: p, child: Text(p.label)))
                  .toList(),
              onChanged: (p) => setState(() => _prioridade = p!),
            ),
            const SizedBox(height: 16),
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: false, label: Text('Pendente')),
                ButtonSegment(value: true, label: Text('Concluída')),
              ],
              selected: {_concluida},
              onSelectionChanged: (s) => setState(() => _concluida = s.first),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _salvando ? null : _salvar,
              child: Text(_editando ? 'Salvar alterações' : 'Cadastrar'),
            ),
          ],
        ),
      ),
    );
  }
}
