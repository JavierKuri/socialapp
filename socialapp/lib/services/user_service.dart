import 'dart:convert';
import 'package:http/http.dart' as http;
import '../globals.dart';
import '../models/user.dart';

class UserService {
  Future<User?> getUserByEmail(String email) async {
    try {
      final response = await http.post(
        Uri.parse("$backendurl/get_user"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return User.fromJson(data['user']);
      }
    } catch (e) {
      print("Error fetching user: $e");
    }
    return null;
  }
}