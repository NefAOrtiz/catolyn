import 'package:flutter/material.dart';
import '../services/auth_service.dart';


class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String? message;

  void register() async {
    final success = await AuthService.register(
      emailController.text,
      passwordController.text,
    );
    Navigator.pushReplacementNamed(context, '/home');
    setState(() {
      message = success ? 'Registro exitoso' : 'El usuario ya existe';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Crear Cuenta')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: emailController, decoration: InputDecoration(labelText: 'Correo')),
            TextField(controller: passwordController, obscureText: true, decoration: InputDecoration(labelText: 'Contraseña')),
            if (message != null) Text(message!, style: TextStyle(color: Colors.green)),
            SizedBox(height: 20),
            ElevatedButton(onPressed: register, child: Text('Registrar')),
          ],
        ),
      ),
    );
  }
}
