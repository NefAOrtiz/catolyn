// lib/services/auth_service.dart

class AuthService {
  // Simulación de base de datos en memoria
  static final Map<String, String> _fakeDB = {};

  // Método de inicio de sesión
  static Future<bool> login(String email, String password) async {
    await Future.delayed(Duration(seconds: 1)); // Simula delay de red
    return _fakeDB[email] == password;
  }

  // Método de registro
  static Future<bool> register(String email, String password) async {
    await Future.delayed(Duration(seconds: 1)); // Simula delay de red

    // Si ya existe el email, no permite registrarse
    if (_fakeDB.containsKey(email)) return false;

    // Guarda el usuario
    _fakeDB[email] = password;
    return true;
  }
}
