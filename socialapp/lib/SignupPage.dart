import 'package:socialapp/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key, required this.title});
  final String title;

  @override
  State<SignupPage> createState() => _signupPageState();
}

class _signupPageState extends State<SignupPage> {

final TextEditingController _nameController = TextEditingController();
final TextEditingController _emailController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();
final TextEditingController _birthdayController = TextEditingController();
final ImagePicker _profilePicturePicker = ImagePicker();
XFile? profilePictureFile;
final ImagePicker _bannerPicturePicker = ImagePicker();
XFile? bannerPictureFile;


Future<void> signup() async {
    final response = await http.post(
      Uri.parse('createuseruri'),
      body: {
        'Name': _nameController.text,
        'Email': _emailController.text,
        'Password': _passwordController.text,
        'Birthday': _birthdayController.text,

      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        // Navigate to HomeScreen on success
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Signup succesful. Returning to login page...')),
        );
        Future.delayed(const Duration(seconds: 3), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MyHomePage(title: "Login")),
          );
        });
      } else {
        // Show login failed message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'])),
        );
      }
    } else {
      // Server or network error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Server error. Please try again later.')),
      );
    }
  }

  Future<void> _pickProfilePicture() async {
    final XFile? pickedFile =
        await _profilePicturePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        profilePictureFile = pickedFile;
      });
    }
  }

  Future<void> _pickBannerPicture() async {
    final XFile? pickedFile =
        await _bannerPicturePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        bannerPictureFile = pickedFile;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),

      // Fields for user input
      body: ListView(
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: "Name"
            ),
          ),
          const SizedBox(height: 30),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: "Email"
            ),
          ),
          const SizedBox(height: 30),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: "Password"
            ),
          ),
          const SizedBox(height:30),
          TextField(
            controller: _birthdayController,
            decoration: InputDecoration(
              labelText: "Birthday"
            ),
          ),
          const SizedBox(height:30),
          ElevatedButton(
            onPressed: _pickProfilePicture,
            child: const Text('Pick profile picture from Gallery'),
          ),
          if (profilePictureFile != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Image.file(
                File(profilePictureFile!.path),
                height: 100,
              ),
            ),
          const SizedBox(height:30),
          ElevatedButton(
            onPressed: _pickBannerPicture,
            child: const Text('Pick banner picture from Gallery'),
          ),
          if (bannerPictureFile != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Image.file(
                File(bannerPictureFile!.path),
                height: 100,
              ),
            ),
          const SizedBox(height: 30),
          ElevatedButton(onPressed: signup, child: const Text("Submit"))
        ],
      )
    );
  }
}