// lib/services/auth_service.dart

class AuthService {
  
  static final Map<String, String> _fakeDB = {};

  // Método de inicio de sesión
  static Future<bool> login(String email, String password) async {
    await Future.delayed(Duration(seconds: 1)); 
    return _fakeDB[email] == password;
  }

  // Método de registro
  static Future<bool> register(String email, String password) async {
    await Future.delayed(Duration(seconds: 1)); 

   
    if (_fakeDB.containsKey(email)) return false;

    
    _fakeDB[email] = password;
    return true;
  }
}
