import 'package:material_ui/material_ui.dart';

import '../models/usuario.dart';
import '../services/auth_service.dart';
import '../screens/configuracoes_screen.dart';
import '../screens/tarefas_screen.dart';

class DrawerMenu extends StatelessWidget {
  final Usuario? usuario;

  const DrawerMenu({super.key, required this.usuario});

  void _abrir(BuildContext context, Widget tela) {
    Navigator.pop(context); // fecha o drawer
    Navigator.push(context, MaterialPageRoute(builder: (_) => tela));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(usuario?.nome ?? ''),
            accountEmail: Text(usuario?.email ?? ''),
            currentAccountPicture: CircleAvatar(
              child: Text(
                (usuario?.nome.isNotEmpty ?? false)
                    ? usuario!.nome[0].toUpperCase()
                    : '?',
                style: const TextStyle(fontSize: 28),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Início'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('Minhas tarefas'),
            onTap: () => _abrir(context, const TarefasScreen()),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Configurações'),
            onTap: () => _abrir(context, const ConfiguracoesScreen()),
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Sobre o aplicativo'),
            onTap: () {
              Navigator.pop(context);
              showAboutDialog(
                context: context,
                applicationName: 'Gerenciador de Tarefas',
                applicationVersion: '1.0.0',
                applicationIcon: const Icon(Icons.task_alt),
                children: const [
                  Text('Trabalho P2 de Programação Mobile — Flutter + '
                      'Firebase Authentication e Realtime Database.'),
                ],
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sair'),
            onTap: () async {
              Navigator.pop(context);
              await AuthService().logout();
            },
          ),
        ],
      ),
    );
  }
}
