class AuthService {
  static final Map<String, String> _fakeDB = {};

  static Future<bool> login(String email, String password) async {
    await Future.delayed(Duration(seconds: 1)); // Simula delay de red
    return _fakeDB[email] == password;
  }

  static Future<bool> register(String email, String password) async {
    await Future.delayed(Duration(seconds: 1));
    if (_fakeDB.containsKey(email)) return false;
    _fakeDB[email] = password;
    return true;
  }
}
