import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'splash_screen.dart';
import 'welcome_page.dart';
import 'pages/login_pages.dart';
import 'pages/register_page.dart';
import 'providers/product_provider.dart';

void main() => runApp(
  ChangeNotifierProvider(
    create: (_) => ProductProvider(),
    child: const CatolynApp(),
  ),
);

class CatolynApp extends StatelessWidget {
  const CatolynApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catolyn 🮺',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/welcome': (context) => const WelcomePage(),
        '/home': (context) => CatolynHomePage(),
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
      },
    );
  }
}

class CatolynHomePage extends StatelessWidget {
  final Color fondo = const Color.fromARGB(255, 30, 42, 56);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondo,
      appBar: AppBar(
        backgroundColor: fondo,
        elevation: 0,
        title: const Text(
          'CATOLYN 🮺',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: const [
          Icon(Icons.search, color: Colors.white),
          SizedBox(width: 8),
          Icon(Icons.favorite_border, color: Color.fromARGB(255, 255, 194, 194)),
          SizedBox(width: 8),
          Icon(Icons.shopping_bag_outlined, color: Color.fromARGB(255, 88, 192, 244)),
          SizedBox(width: 8),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Color.fromARGB(255, 30, 42, 56)),
              child: Text(
                'Menú de navegación',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Inicio'),
              onTap: () => Navigator.pushNamed(context, '/home'),
            ),
            ListTile(
              leading: Icon(Icons.login),
              title: Text('Cerrar sesión'),
              onTap: () => Navigator.pushNamed(context, '/welcome'),
            ),
            ListTile(
              leading: Icon(Icons.person_add),
              title: Text('Registrarse'),
              onTap: () => Navigator.pushNamed(context, '/register'),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Configuración'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('Acerca de'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: ['Hombre', 'Mujer', 'Infantil', 'Sandalias', 'Comida']
                  .map((e) => Text(
                        e,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),
            Container(
              height: 200,
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage('assets/shoe.jpeg'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.bottomLeft,
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Mostrá lo que vendés sin necesidad de tener una web.",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/home');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 255, 167, 38),
                    ),
                    child: const Text("VER OFERTAS"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Amantes de lo hecho en casa, este es su momento",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const Text(
              "Hasta 60% de descuento en productos locales seleccionados.",
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildProducto("Casabe con ajo", "12\$ 9\$", 'assets/casabe.jpg'),
                _buildProducto("Muñeca de hilo", "9\$ 7\$", 'assets/muñeca.jpg'),
                _buildProducto("Marioneta tradicional", "14\$ 12\$", 'assets/marioneta.jpg'),
                _buildProducto("Greca artesanal", "100€ 60€", 'assets/greca.jpg'),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                child: const Text("VER MÁS"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProducto(String nombre, String precio, String imagePath) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 46, 60, 77),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Expanded(
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Placeholder(),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            nombre,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(precio, style: const TextStyle(color: Colors.green)),
        ],
      ),
    );
  }
}
