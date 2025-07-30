import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String?> uploadImageToCloudinary(File imageFile) async {
  const cloudName = 'dcnmhbl4p';        // ← cambia esto
  const uploadPreset = 'catolyn_upload';  // ← cambia esto

  final url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');

  final request = http.MultipartRequest('POST', url)
    ..fields['upload_preset'] = uploadPreset
    ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

  final response = await request.send();

  if (response.statusCode == 200) {
    final resStr = await response.stream.bytesToString();
    final jsonRes = json.decode(resStr);
    return jsonRes['secure_url']; // URL de la imagen en Cloudinary
  } else {
    return null;
  }
}
