import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Iniciar sesión
  static Future<User?> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print('Error en login (FirebaseAuth): ${e.code}');

      // Puedes manejar errores específicos aquí
      if (e.code == 'user-not-found') {
        print('❌ No existe una cuenta con ese correo.');
      } else if (e.code == 'wrong-password') {
        print('❌ Contraseña incorrecta.');
      } else if (e.code == 'invalid-email') {
        print('❌ Correo inválido.');
      }

      return null;
    } catch (e) {
      print('Error inesperado en login: $e');
      return null;
    }
  }

  // Registrar nuevo usuario
  static Future<User?> register(String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print('Error en registro (FirebaseAuth): ${e.code}');

      // Puedes manejar errores específicos también
      if (e.code == 'email-already-in-use') {
        print('❌ Este correo ya está registrado.');
      } else if (e.code == 'invalid-email') {
        print('❌ Correo inválido.');
      } else if (e.code == 'weak-password') {
        print('❌ Contraseña débil.');
      }

      return null;
    } catch (e) {
      print('Error inesperado en registro: $e');
      return null;
    }
  }

  static Future<void> logout() async {
    await _auth.signOut();
  }

  static User? get currentUser => _auth.currentUser;
}
