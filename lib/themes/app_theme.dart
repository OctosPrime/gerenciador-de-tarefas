import 'package:material_ui/material_ui.dart';

import '../services/preferences_service.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
    appBarTheme: const AppBarTheme(centerTitle: true),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.indigo,
      brightness: Brightness.dark,
    ),
    appBarTheme: const AppBarTheme(centerTitle: true),
  );
}

/// Controla o ThemeMode do app e persiste a escolha no SharedPreferences.
class ThemeController extends ValueNotifier<ThemeMode> {
  ThemeController() : super(ThemeMode.light);

  final _prefs = PreferencesService();

  bool get escuro => value == ThemeMode.dark;

  Future<void> carregar() async {
    value = await _prefs.carregarTemaEscuro() ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> definirEscuro(bool escuro) async {
    value = escuro ? ThemeMode.dark : ThemeMode.light;
    await _prefs.salvarTemaEscuro(escuro);
  }
}

final themeController = ThemeController();
