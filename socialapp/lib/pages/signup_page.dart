import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/signup_request.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../globals.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _birthdayController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  final AuthService _authService = AuthService();

  XFile? _profileImage;
  XFile? _bannerImage;

  bool _isLoading = false;

  Future<void> _pickProfileImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _profileImage = picked);
    }
  }

  Future<void> _pickBannerImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _bannerImage = picked);
    }
  }

  Future<void> _signup() async {
    setState(() => _isLoading = true);

    String? profileBase64;
    String? bannerBase64;

    if (_profileImage != null) {
      profileBase64 =
          base64Encode(await _profileImage!.readAsBytes());
    }

    if (_bannerImage != null) {
      bannerBase64 =
          base64Encode(await _bannerImage!.readAsBytes());
    }

    final request = SignupRequest(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      birthday: _birthdayController.text.trim(),
      profilePicture: profileBase64,
      bannerPicture: bannerBase64,
    );

    final User? user = await _authService.signup(request);

    setState(() => _isLoading = false);

    if (user != null) {
      // Temporary session storage
      global_user = user;

      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Signup failed")),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _birthdayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [

            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: _birthdayController,
              decoration: const InputDecoration(labelText: "Birthday"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _pickProfileImage,
              child: const Text("Pick Profile Picture"),
            ),

            if (_profileImage != null)
              const Icon(Icons.check, color: Colors.green),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: _pickBannerImage,
              child: const Text("Pick Banner Picture"),
            ),

            if (_bannerImage != null)
              const Icon(Icons.check, color: Colors.green),

            const SizedBox(height: 30),

            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _signup,
                    child: const Text("Sign Up"),
                  ),
          ],
        ),
      ),
    );
  }
}