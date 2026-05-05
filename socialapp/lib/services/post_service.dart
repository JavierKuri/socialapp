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

  Future<List<Post>> getPosts(String email) async {
    final response = await http.post(
      Uri.parse("$backendurl/get_post"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List postsJson = data['posts'] ?? [];

      return postsJson
          .map((json) => Post.fromJson(json))
          .toList();
    }

    return [];
  }
}