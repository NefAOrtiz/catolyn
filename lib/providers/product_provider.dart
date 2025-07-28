import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductProvider extends ChangeNotifier {
  final List<Product> _products = [];

  final List<String> _categorias = [
    'Hombre',
    'Mujer',
    'Infantil',
    'Sandalias',
    'Comida',
  ];

  List<Product> get products => _products;
  List<String> get categorias => _categorias;

  void addProduct(Product p) {
    _products.add(p);
    if (!_categorias.contains(p.category)) {
      _categorias.add(p.category);
    }
    notifyListeners();
  }

  void deleteProduct(Product p) {
    _products.remove(p);
    notifyListeners();
  }

  void updateProduct(Product original, Product updated) {
    final index = _products.indexOf(original);
    if (index != -1) {
      _products[index] = updated;
      if (!_categorias.contains(updated.category)) {
        _categorias.add(updated.category);
      }
      notifyListeners();
    }
  }

  void addCategoria(String nueva) {
    if (!_categorias.contains(nueva)) {
      _categorias.add(nueva);
      notifyListeners();
    }
  }
}
