import 'dart:typed_data';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../globals.dart';

class ImageService {
  Future<Uint8List?> getImageBytes(String path) async {
    final response = await http.post(
      Uri.parse("$backendurl/get_image"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({'path': path}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return base64Decode(data['image']);
    }
    return null;
  }
}