import 'package:material_ui/material_ui.dart';

import '../models/tarefa.dart';
import '../models/usuario.dart';
import '../services/auth_service.dart';
import '../services/firebase_service.dart';
import '../widgets/drawer_menu.dart';
import 'cadastro_tarefa_screen.dart';
import 'tarefas_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _stream = FirebaseService().tarefasStream();
  Usuario? _usuario;

  @override
  void initState() {
    super.initState();
    AuthService().buscarUsuario().then((u) {
      if (mounted) setState(() => _usuario = u);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Início')),
      drawer: DrawerMenu(usuario: _usuario),
      body: StreamBuilder<List<Tarefa>>(
        stream: _stream,
        builder: (context, snapshot) {
          final tarefas = snapshot.data ?? [];
          final concluidas = tarefas.where((t) => t.concluida).length;
          final pendentes = tarefas.length - concluidas;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Olá, ${_usuario?.nome ?? ''}!',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              _card(context, 'Cadastradas', tarefas.length, Icons.list_alt,
                  Colors.blue),
              _card(context, 'Pendentes', pendentes, Icons.pending_actions,
                  Colors.orange),
              _card(context, 'Concluídas', concluidas, Icons.check_circle,
                  Colors.green),
              const SizedBox(height: 16),
              FilledButton.icon(
                icon: const Icon(Icons.list),
                label: const Text('Minhas tarefas'),
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const TarefasScreen())),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Nova tarefa'),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const CadastroTarefaScreen())),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _card(BuildContext context, String titulo, int valor, IconData icone,
      Color cor) {
    return Card(
      child: ListTile(
        leading: Icon(icone, color: cor, size: 32),
        title: Text(titulo),
        trailing: Text('$valor',
            style: Theme.of(context).textTheme.headlineSmall),
      ),
    );
  }
}
