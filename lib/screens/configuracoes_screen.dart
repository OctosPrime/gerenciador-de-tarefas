import 'package:flutter/material.dart';

import '../themes/app_theme.dart';

class ConfiguracoesScreen extends StatelessWidget {
  const ConfiguracoesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: ValueListenableBuilder<ThemeMode>(
        valueListenable: themeController,
        builder: (context, mode, _) => ListView(
          children: [
            SwitchListTile(
              secondary: const Icon(Icons.dark_mode),
              title: const Text('Tema escuro'),
              subtitle: const Text('A preferência fica salva no aparelho'),
              value: mode == ThemeMode.dark,
              onChanged: themeController.definirEscuro,
            ),
          ],
        ),
      ),
    );
  }
}
