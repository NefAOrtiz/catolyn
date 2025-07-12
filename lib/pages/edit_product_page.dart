import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';

class EditProductPage extends StatefulWidget {
  const EditProductPage({super.key});

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final _formKey = GlobalKey<FormState>();
  late Product _originalProduct;
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  String? _category;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  final Color formularioColor = const Color.fromARGB(255, 60, 90, 120);
  final Color colorTexto = const Color.fromARGB(255, 30, 42, 56);

  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args == null || args is! Product) {
        Navigator.pop(context);
        return;
      }
      _originalProduct = args;

      _nameController = TextEditingController(text: _originalProduct.name);
      _priceController = TextEditingController(text: _originalProduct.price);
      _category = _originalProduct.category;

      if (File(_originalProduct.imagePath).existsSync()) {
        _imageFile = File(_originalProduct.imagePath);
      } else {
        _imageFile = null;
      }

      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _pickNewImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final categorias = productProvider.categorias;

    // Evita que _category tenga un valor no válido para el Dropdown
    if (_category != null && !categorias.contains(_category)) {
      _category = null;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Producto"),
        backgroundColor: colorTexto,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      backgroundColor: formularioColor,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Modificar producto",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: _pickNewImage,
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white70),
                      ),
                      child:
                          _imageFile != null
                              ? Image.file(_imageFile!, fit: BoxFit.cover)
                              : const Icon(
                                Icons.add_a_photo,
                                color: Colors.white70,
                                size: 50,
                              ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Nombre',
                      labelStyle: const TextStyle(color: Colors.white70),
                      prefixIcon: const Icon(
                        Icons.shopping_bag,
                        color: Colors.white70,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.white30),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                    ),
                    validator:
                        (value) => value!.isEmpty ? 'Campo requerido' : null,
                    cursorColor: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _priceController,
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Precio',
                      labelStyle: const TextStyle(color: Colors.white70),
                      prefixIcon: const Icon(
                        Icons.attach_money,
                        color: Colors.white70,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.white30),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                    ),
                    validator:
                        (value) =>
                            value!.isEmpty || double.tryParse(value) == null
                                ? 'Precio inválido'
                                : null,
                    cursorColor: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _category,
                    dropdownColor: formularioColor,
                    style: const TextStyle(color: Colors.white),
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Categoría',
                      labelStyle: const TextStyle(color: Colors.white70),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.white30),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                    ),
                    items:
                        categorias
                            .map(
                              (cat) => DropdownMenuItem(
                                value: cat,
                                child: Text(
                                  cat,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      setState(() {
                        _category = value;
                      });
                    },
                    validator:
                        (value) =>
                            value == null ? 'Selecciona una categoría' : null,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (_imageFile == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Por favor, selecciona una imagen'),
                            ),
                          );
                          return;
                        }

                        final updatedProduct = Product(
                          name: _nameController.text,
                          price: _priceController.text,
                          category: _category!,
                          imagePath: _imageFile!.path,
                        );

                        Provider.of<ProductProvider>(
                          context,
                          listen: false,
                        ).updateProduct(_originalProduct, updatedProduct);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Producto actualizado')),
                        );

                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Guardar Cambios",
                      style: TextStyle(
                        color: formularioColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
