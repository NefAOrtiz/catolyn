import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductProvider extends ChangeNotifier {
  final List<Product> _products = [];
  final List<Product> _favorites = [];

  final List<String> _categorias = [
    'Hombre',
    'Mujer',
    'Infantil',
    'Sandalias',
    'Comida',
  ];

  List<Product> get products => _products;
  List<Product> get favorites => _favorites;
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
    _favorites.remove(p); // También lo quita de favoritos
    notifyListeners();
  }

  void updateProduct(Product original, Product updated) {
    final index = _products.indexOf(original);
    if (index != -1) {
      _products[index] = updated;

      final favIndex = _favorites.indexOf(original);
      if (favIndex != -1) {
        _favorites[favIndex] = updated;
      }

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

  /// ✅ Método para alternar el estado de favorito
  void toggleFavorite(Product product) {
    if (_favorites.contains(product)) {
      _favorites.remove(product);
    } else {
      _favorites.add(product);
    }
    notifyListeners();
  }

  /// ✅ Método para verificar si un producto es favorito
  bool isFavorite(Product product) => _favorites.contains(product);

}
