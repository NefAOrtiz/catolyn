import 'dart:io'; 
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';

class ProductListPage extends StatelessWidget {
  ProductListPage({super.key});

  final Color formularioColor = Color.fromARGB(255, 60, 90, 120);
  final Color colorTexto = Color.fromARGB(255, 30, 42, 56);

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductProvider>(context).products;

    return Scaffold(
      appBar: AppBar(
        title: Text("Mis Productos"),
        backgroundColor: colorTexto,
        foregroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      backgroundColor: formularioColor,
      body: ListView.builder(
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
            ),
          );
        },
      ),
    );
  }
}
