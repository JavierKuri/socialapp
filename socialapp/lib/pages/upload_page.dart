import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:socialapp/globals.dart';
import '../pages/posts_home_page.dart';
import '../widgets/app_bottom_bar.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key, required this.title});
  final String title;

  @override
  State<UploadPage> createState() => _uploadPageState();
}

class _uploadPageState extends State<UploadPage> {

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final ImagePicker _postPicturePicker = ImagePicker();
  XFile? postPictureFile;

  Future<void> upload() async {

    String? pictureBase64;

    if (postPictureFile != null) {
      final bytes = await postPictureFile!.readAsBytes();
      pictureBase64 = base64Encode(bytes);
    }

    final response = await http.post(
      Uri.parse("$backendurl/upload"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        'email': user_email,
        'title': _titleController.text,
        'description': _descriptionController.text,
        'postPicture': pictureBase64,
      }),
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Upload successful. Returning to Home page...')),
      );

      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PostsHomePage(title: "Home")),
        );
      });

    } else if (response.statusCode == 400) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid data')),
      );

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Server error. Please try again later.')),
      );
    }
  }

  Future<void> _pickPostPicture() async {
    final XFile? pickedFile =
        await _postPicturePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        postPictureFile = pickedFile;
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
            controller: _titleController,
            decoration: InputDecoration(
              labelText: "Title"
            ),
          ),
          const SizedBox(height: 30),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: "Descriprion"
            ),
          ),
          const SizedBox(height:30),
          ElevatedButton(
            onPressed: _pickPostPicture,
            child: const Text('Pick picture from Gallery'),
          ),
          if (postPictureFile != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: const Icon(
                Icons.check,
                color: Colors.green,
              )
            ),
          const SizedBox(height: 30),
          ElevatedButton(onPressed: upload, child: const Text("Upload"))
        ],
      ),
      bottomNavigationBar: AppBottomNavBar(selectedIndex: 2),
    );
  }
}