import 'dart:io';
import 'package:catolyn/pages/about_page.dart';
import 'package:catolyn/pages/add_product_page.dart';
import 'package:catolyn/pages/edit_product_page.dart';
import 'package:catolyn/pages/product_list_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'splash_screen.dart';
import 'welcome_page.dart';
import 'package:catolyn/pages/login_page.dart';
import 'package:catolyn/pages/register_page.dart';
import 'providers/product_provider.dart';
import 'package:url_launcher/url_launcher.dart';

Color getEstadoColor(String status) {
  switch (status) {
    case 'Disponible':
      return Colors.green;
    case 'Pendiente':
      return Colors.orange;
    case 'Vendido':
      return Colors.red;
    default:
      return Colors.grey;
  }
}

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
      title: 'Catolyn ',
      debugShowCheckedModeBanner: true,

      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/welcome': (context) => const WelcomePage(),
        '/home': (context) => CatolynHomePage(),
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/add-product': (context) => AddProductPage(),
        '/my-products': (context) => ProductListPage(),
        '/edit-product': (context) => EditProductPage(),
        '/about': (context) => const AboutPage(),
      },
    );
  }
}

String limpiarNumero(String numero) {
  // Elimina todo excepto dígitos y el signo + solo si está al inicio
  String limpio = numero.replaceAll(RegExp(r'[^\d+]'), '');
  if (limpio.indexOf('+') > 0) {
    limpio = limpio.replaceAll('+', '');
  }
  return limpio;
}

class CatolynHomePage extends StatefulWidget {
  const CatolynHomePage({super.key});

  @override
  State<CatolynHomePage> createState() => _CatolynHomePageState();
}

class _CatolynHomePageState extends State<CatolynHomePage> {
  final Color fondo = const Color.fromARGB(255, 30, 42, 56);
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String? _categoriaSeleccionada;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondo,
      appBar: AppBar(
        backgroundColor: fondo,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title:
            _isSearching
                ? TextField(
                  controller: _searchController,
                  autofocus: true,
                  style: const TextStyle(color: Colors.white),
                  cursorColor: Colors.white,
                  decoration: const InputDecoration(
                    hintText: 'Buscar productos...',
                    hintStyle: TextStyle(color: Colors.white70),
                    border: InputBorder.none,
                  ),
                  onChanged: (_) {
                    setState(() {});
                  },
                )
                : const Text(
                  'CATOLYN 🧺',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            color: Colors.white,
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) _searchController.clear();
              });
            },
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.favorite_border,
            color: Color.fromARGB(255, 255, 194, 194),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.shopping_bag_outlined,
            color: Color.fromARGB(255, 88, 192, 244),
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: _buildDrawer(context),

      body: _buildBody(context),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    const TextStyle estiloTitulo = TextStyle(fontSize: 19);
    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Color.fromARGB(255, 30, 42, 56)),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Menú de navegación',
                style: TextStyle(color: Colors.white, fontSize: 23),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: Icon(Icons.home),
                  title: Text('Inicio', style: estiloTitulo),
                  onTap: () => Navigator.pushNamed(context, '/home'),
                ),
                ListTile(
                  leading: Icon(Icons.add),
                  title: Text('Agregar producto', style: estiloTitulo),
                  onTap: () => Navigator.pushNamed(context, '/add-product'),
                ),
                ListTile(
                  leading: Icon(Icons.list),
                  title: Text('Mis productos', style: estiloTitulo),
                  onTap: () => Navigator.pushNamed(context, '/my-products'),
                ),
                ListTile(
                  leading: Icon(Icons.person_add),
                  title: Text('Registrarse', style: estiloTitulo),
                  onTap: () => Navigator.pushNamed(context, '/register'),
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Configuración', style: estiloTitulo),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.info),
                  title: Text('Acerca de', style: estiloTitulo),
                  onTap: () {
                    Navigator.pushNamed(context, '/about');
                  },
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Cerrar sesión', style: estiloTitulo),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/welcome');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context, listen: false);
    final categoriasFijas = [
      'Hombre',
      'Mujer',
      'Infantil',
      'Sandalias',
      'Comida',
    ];
    final categoriasDinamicas =
        provider.products
            .map((p) => p.category)
            .toSet()
            .difference(categoriasFijas.toSet())
            .toList();
    final todasLasCategorias = [
      'Todos',
      ...categoriasFijas,
      ...categoriasDinamicas,
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children:
                  todasLasCategorias.map((categoria) {
                    final seleccionada =
                        (_categoriaSeleccionada == null &&
                            categoria == 'Todos') ||
                        (_categoriaSeleccionada?.toLowerCase() ==
                            categoria.toLowerCase());

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _categoriaSeleccionada =
                              categoria == 'Todos' ? null : categoria;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color:
                              seleccionada ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          categoria,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: seleccionada ? Colors.black : Colors.white,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
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
          Consumer<ProductProvider>(
            builder: (context, provider, child) {
              final query = _searchController.text.toLowerCase();
              final productos =
                  provider.products.where((p) {
                    final name = p.name.toLowerCase();
                    final category = p.category.toLowerCase();
                    final input = query;

                    final coincideBusqueda =
                        name.contains(input) || category.contains(input);
                    final coincideCategoria =
                        _categoriaSeleccionada == null ||
                        category == _categoriaSeleccionada!.toLowerCase();

                    return coincideBusqueda && coincideCategoria;
                  }).toList();

              if (productos.isEmpty) {
                return const Text(
                  "No se encontraron productos.",
                  style: TextStyle(color: Colors.white),
                );
              }

              return GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                physics: const NeverScrollableScrollPhysics(),
                children:
                    productos
                        .map(
                          (p) => _buildProducto(
                            p.name,
                            "\$${p.price}",
                            p.imagePath,
                            p.contact,
                            p.status,
                            context,
                          ),
                        )
                        .toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProducto(
    String nombre,
    String precio,
    String imagePath,
    String contacto,
    String status,
    BuildContext context,
  ) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 46, 60, 77),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder:
                    (_) => AlertDialog(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      title: const Text(
                        'Contacto del vendedor',
                        style: TextStyle(
                          color: Color.fromARGB(255, 60, 90, 120),
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Estado del producto:',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                              fontSize: 19,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            status,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: getEstadoColor(status),
                              fontSize: 19,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Número o contacto:',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 19,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            contacto,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 19,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.phone, color: Colors.white),
                            label: const Text(
                              'Llamar',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(
                                255,
                                60,
                                90,
                                120,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () async {
                              final telefonoLimpio = limpiarNumero(contacto);
                              final Uri phoneUri = Uri.parse(
                                'tel:$telefonoLimpio',
                              );
                              if (await canLaunchUrl(phoneUri)) {
                                await launchUrl(
                                  phoneUri,
                                  mode: LaunchMode.externalApplication,
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Row(
                                      children: const [
                                        Icon(
                                          Icons.error_outline,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          'No se pudo abrir la app de llamadas',
                                        ),
                                      ],
                                    ),
                                    backgroundColor: Colors.redAccent,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    duration: Duration(seconds: 3),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.transparent,
                          ),
                          child: const Text(
                            'Cerrar',
                            style: TextStyle(
                              color: Color.fromARGB(255, 60, 90, 120),
                              fontSize: 19,
                            ),
                          ),
                        ),
                      ],
                    ),
              );
            },
            child: Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image:
                      imagePath.startsWith('assets/')
                          ? AssetImage(imagePath) as ImageProvider
                          : FileImage(File(imagePath)),
                  fit: BoxFit.cover,
                ),
              ),
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
