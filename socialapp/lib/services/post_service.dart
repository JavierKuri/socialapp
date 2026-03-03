import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post.dart';
import '../globals.dart';

class PostService {

  Future<bool> uploadPost(Post post) async {
    final response = await http.post(
      Uri.parse("$backendurl/upload"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(post.toJson()),
    );

    return response.statusCode == 200;
  }
}