import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../globals.dart';

class AuthService {

  Future<User?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("$backendurl/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    }

    return null;
  }

  Future<User?> signup(String email, String password) async {
    final response = await http.post(
      Uri.parse("$backendurl/signup"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    }

    return null;
  }

  Future<void> logout() async {
    // TODO
  }
}