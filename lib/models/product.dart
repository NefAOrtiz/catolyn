class Product {
  final String id;  // Agrega id para Firestore (opcional)
  final String name;
  final double price;
  final String category;
  final String imagePath; 
  final String contact;
  final String status;

  Product({
    this.id = '',
    required this.name,
    required this.price,
    required this.category,
    required this.imagePath,
    required this.contact,
    required this.status,
  });

  // Convertir a Map para guardar en Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'category': category,
      'imagePath': imagePath,
      'contact': contact,
      'status': status,
    };
  }

  // Crear objeto desde Map Firestore
  factory Product.fromMap(String id, Map<String, dynamic> map) {
    return Product(
      id: id,
      name: map['name'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      category: map['category'] ?? '',
      imagePath: map['imagePath'] ?? '',
      contact: map['contact'] ?? '',
      status: map['status'] ?? '',
    );
  }
}
