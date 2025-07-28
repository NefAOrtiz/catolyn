import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final Color formularioColor = Color.fromARGB(255, 60, 90, 120);
  final Color colorTexto = Color.fromARGB(255, 30, 42, 56);

  String filtro = '';

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    final products =
        productProvider.products.where((p) {
          return p.name.toLowerCase().contains(filtro.toLowerCase());
        }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Mis Productos"),
        backgroundColor: colorTexto,
        foregroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      backgroundColor: formularioColor,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar producto...',
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  filtro = value;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (_, index) {
                final p = products[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading:
                        p.imagePath.isNotEmpty
                            ? Image.file(
                              File(p.imagePath),
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            )
                            : Icon(Icons.image_not_supported, size: 50),
                    title: Text(
                      p.name,
                      style: TextStyle(
                        color: colorTexto,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '${p.category} - \$${p.price}',
                      style: TextStyle(
                        color: colorTexto.withAlpha((0.7 * 255).round()),
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/edit-product',
                              arguments: p,
                            );
                          },
                        ),

                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder:
                                  (_) => AlertDialog(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    title: Text(
                                      'Confirmar eliminación',
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 60, 90, 120),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    content: Text(
                                      '¿Deseas eliminar el producto "${p.name}"?',
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 60, 90, 120),
                                        fontSize: 18,
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        style: TextButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                        ),
                                        child: Text(
                                          'Cancelar',
                                          style: TextStyle(
                                            color: Color.fromARGB(
                                              255,
                                              60,
                                              90,
                                              120,
                                            ),
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          productProvider.deleteProduct(p);
                                          Navigator.pop(context);
                                        },
                                        style: TextButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                        ),
                                        child: Text(
                                          'Eliminar',
                                          style: TextStyle(
                                            color: Colors.red[700],
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: Icon(Icons.add, color: colorTexto),
        onPressed: () async {
          final result = await Navigator.pushNamed(context, '/add-product');
          if (result == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: const [
                    Icon(Icons.check_circle, color: Colors.white),
                    SizedBox(width: 10),
                    Text('Producto agregado exitosamente'),
                  ],
                ),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                duration: Duration(seconds: 3),
              ),
            );
          }
        },
      ),
    );
  }
}
