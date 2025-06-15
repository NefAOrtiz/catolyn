import 'dart:io'; // Para File
import 'package:image_picker/image_picker.dart'; // Para image_picker
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _price = '';
  String? _category;

  File? _imageFile; // Aquí guardaremos la imagen seleccionada

  final List<String> categorias = [
    'Hombre',
    'Mujer',
    'Infantil',
    'Sandalias',
    'Comida',
  ];
  final Color formularioColor = Color.fromARGB(255, 60, 90, 120);
  final Color colorTexto = Color.fromARGB(255, 30, 42, 56);

  final ImagePicker _picker = ImagePicker();

  // Función para seleccionar imagen desde galería
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Agregar Producto"),
        backgroundColor: colorTexto,
        foregroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.white),
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
                  Text(
                    "Nuevo producto",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  // Mostrar la imagen seleccionada 
                  GestureDetector(
                    onTap: _pickImage,
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
                              : Icon(
                                Icons.add_a_photo,
                                color: Colors.white70,
                                size: 50,
                              ),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Nombre',
                      labelStyle: TextStyle(color: Colors.white70),
                      prefixIcon: Icon(
                        Icons.shopping_bag,
                        color: Colors.white70,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.white30),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    validator:
                        (value) => value!.isEmpty ? 'Campo requerido' : null,
                    onSaved: (value) => _name = value!,
                    cursorColor: Colors.white,
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    style: TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Precio',
                      labelStyle: TextStyle(color: Colors.white70),
                      prefixIcon: Icon(
                        Icons.attach_money,
                        color: Colors.white70,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.white30),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    validator:
                        (value) =>
                            value!.isEmpty || double.tryParse(value) == null
                                ? 'Precio inválido'
                                : null,
                    onSaved: (value) => _price = value!,
                    cursorColor: Colors.white,
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _category,
                    dropdownColor: formularioColor,
                    style: TextStyle(color: Colors.white),
                    icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Categoría',
                      labelStyle: TextStyle(color: Colors.white70),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.white30),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    items:
                        categorias.map((cat) {
                          return DropdownMenuItem(
                            value: cat,
                            child: Text(
                              cat,
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _category = value;
                      });
                    },
                    validator:
                        (value) =>
                            value == null ? 'Selecciona una categoría' : null,
                    onSaved: (value) => _category = value,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (_imageFile == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Por favor, selecciona una imagen'),
                            ),
                          );
                          return;
                        }

                        _formKey.currentState!.save();

                        Provider.of<ProductProvider>(
                          context,
                          listen: false,
                        ).addProduct(
                          Product(
                            name: _name,
                            price: _price,
                            category: _category!,
    
                            imagePath: _imageFile!.path,
                          ),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Producto agregado correctamente'),
                          ),
                        );

                        _formKey.currentState!.reset();
                        setState(() {
                          _category = null;
                          _name = '';
                          _price = '';
                          _imageFile = null;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Guardar Producto",
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
