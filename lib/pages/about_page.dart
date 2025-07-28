import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  final Color formularioColor = const Color.fromARGB(255, 60, 90, 120);
  final Color colorTexto = const Color.fromARGB(255, 30, 42, 56);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acerca de'),
        backgroundColor: colorTexto,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      backgroundColor: formularioColor,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Catolyn',
                style: TextStyle(
                  color: colorTexto,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Versión: 1.0.0',
                style: TextStyle(
                  color: colorTexto.withAlpha((0.8 * 255).round()),
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Catolyn es una aplicación para vender y comprar productos locales de forma sencilla.\n\n'
                '• Usa el menú para navegar entre secciones.\n'
                '• Busca productos con el filtro o categorías.\n'
                '• Agrega, edita o elimina productos desde tu cuenta.\n'
                '• Contacta al vendedor directamente desde cada producto.\n\n'
                '¡Disfruta de la experiencia!',
                style: TextStyle(
                  color: colorTexto.withAlpha((0.85 * 255).round()),
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
              const Spacer(),
              Text(
                'Desarrollado por Nef Ortiz y Maria Victoriano. © 2025',
                style: TextStyle(
                  color: colorTexto.withAlpha((0.9 * 255).round()),
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
