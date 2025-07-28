import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  final Color fondo = const Color.fromARGB(255, 255, 255, 255);

  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondo,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/logo2.jpg',
                height: 300,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 19),
                ),
                child: const Text(
                  "INICIAR SESIÓN",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.black),
                  padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 19),
                ),
                child: const Text(
                  "CREAR CUENTA",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
