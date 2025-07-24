import 'dart:io';
import 'package:image_picker/image_picker.dart';
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
  double? _price;
  String _contact = '';
  String? _category;
  File? _imageFile;
  String? _status;
  final List<String> _estados = ['Disponible', 'Pendiente', 'Vendido'];

  


  final Color formularioColor = Color.fromARGB(255, 60, 90, 120);
  final Color colorTexto = Color.fromARGB(255, 30, 42, 56);

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<String?> _mostrarDialogoNuevaCategoria(BuildContext context) async {
    String nueva = '';

    return showDialog<String>(
      context: context,
      builder:
          (_) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              'Nueva categoría',
              style: TextStyle(
                color: Color.fromARGB(255, 60, 90, 120),
                fontWeight: FontWeight.bold,
              ),
            ),
            content: TextField(
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Escribe la categoría',
                hintStyle: TextStyle(color: Colors.grey[400]),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 60, 90, 120),
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 60, 90, 120),
                  ),
                ),
              ),
              style: TextStyle(color: Color.fromARGB(255, 60, 90, 120)),
              onChanged: (value) => nueva = value,
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
                    color: Color.fromARGB(255, 60, 90, 120),
                    fontSize: 18,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, nueva),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.transparent,
                ),
                child: Text(
                  'Agregar',
                  style: TextStyle(
                    color: Color.fromARGB(255, 60, 90, 120),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final categorias = productProvider.categorias;

    if (_category != null && !categorias.contains(_category)) {
      _category = null;
    }

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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo requerido';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Precio inválido';
                      }
                      return null;
                    },
                    onSaved: (value) => _price = double.tryParse(value!),
                    cursorColor: Colors.white,
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    style: TextStyle(color: Colors.white),
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Contacto',
                      labelStyle: TextStyle(color: Colors.white70),
                      prefixIcon: Icon(
                        Icons.phone,
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
                    validator: (value) =>
                        value!.isEmpty ? 'Campo requerido' : null,
                    onSaved: (value) => _contact = value!,
                    cursorColor: Colors.white,
                  ),
                  DropdownButtonFormField<String>(
                  value: _status,
                  dropdownColor: Colors.grey[900],
                  style: const TextStyle(color: Colors.white),
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Estado',
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
                  items: _estados.map((estado) {
                    return DropdownMenuItem(
                      value: estado,
                      child: Text(estado, style: const TextStyle(color: Colors.white)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _status = value;
                    });
                  },
                  validator: (value) => value == null ? 'Selecciona un estado' : null,
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
                    items: [
                      ...categorias.map(
                        (cat) => DropdownMenuItem(
                          value: cat,
                          child: Text(
                            cat,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'add_new',
                        child: Text(
                          'Agregar categoría...',
                          style: TextStyle(
                            color: Colors.white70,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                    onChanged: (value) async {
                      if (value == 'add_new') {
                        final nuevaCategoria =
                            await _mostrarDialogoNuevaCategoria(context);
                        if (nuevaCategoria != null &&
                            nuevaCategoria.trim().isNotEmpty) {
                          productProvider.addCategoria(nuevaCategoria.trim());
                          setState(() {
                            _category = nuevaCategoria.trim();
                          });
                        }
                      } else {
                        setState(() {
                          _category = value;
                        });
                      }
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
                            price: _price!,
                            category: _category!,
                            imagePath: _imageFile!.path,
                            contact: _contact,
                            status: _status!,
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
                          _price = null;
                          _imageFile = null;
                        });
                        Navigator.pushReplacementNamed(context, '/my-products');
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
