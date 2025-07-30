import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';

class FavoriteProductsPage extends StatelessWidget {
  const FavoriteProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = Provider.of<ProductProvider>(context).favorites;
    final provider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
        'Favoritos',
        style: TextStyle(color: Colors.white),
      ),

        backgroundColor: const Color.fromARGB(255, 60, 90, 120),
        iconTheme: const IconThemeData(color: Colors.white),

      ),
      body: favorites.isEmpty
          ? const Center(
              child: Text(
                'No hay productos favoritos',
                style: TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(255, 1, 1, 1),
                ),
              ),
            )
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (_, index) {
                final p = favorites[index];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 60, 90, 120),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(10),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: p.imagePath.startsWith('http')
                          ? Image.network(p.imagePath, width: 60, height: 60, fit: BoxFit.cover)
                          : Image.asset(p.imagePath, width: 60, height: 60, fit: BoxFit.cover),
                    ),
                    title: Text(
                      p.name,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${p.category} - \$${p.price}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        provider.isFavorite(p) ? Icons.favorite : Icons.favorite_border,
                        color: Colors.redAccent,
                      ),
                      onPressed: () {
                        provider.toggleFavorite(p);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
