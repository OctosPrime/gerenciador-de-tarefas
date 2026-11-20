import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const _chaveTemaEscuro = 'tema_escuro';

  Future<bool> carregarTemaEscuro() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_chaveTemaEscuro) ?? false;
  }

  Future<void> salvarTemaEscuro(bool escuro) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_chaveTemaEscuro, escuro);
  }
}
