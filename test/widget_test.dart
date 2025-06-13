import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:catolyn/main.dart';

void main() {
  testWidgets('Catolyn home screen renders key elements', (WidgetTester tester) async {
    // Construir la app con la ruta inicial apuntando directamente a '/home'
    await tester.pumpWidget(
      MaterialApp(
        home: CatolynHomePage(),
      ),
    );

    // Esperar a que se dibuje todo
    await tester.pumpAndSettle();

    // Verifica el título
    expect(find.text('CATOLYN 🧺'), findsOneWidget);

    // Verifica botón "VER OFERTAS"
    expect(find.text('VER OFERTAS'), findsOneWidget);

    // Verifica categorías
    expect(find.text('Hombre'), findsOneWidget);
    expect(find.text('Comida'), findsOneWidget);

    // Verifica productos (asegúrate que el texto esté exactamente igual en la app)
    expect(find.text('Casabe con ajo'), findsOneWidget);
    expect(find.text('9\$'), findsOneWidget);

    // Verifica botón "VER MÁS"
    expect(find.text('VER MÁS'), findsOneWidget);
  });
}

