import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import '../models/post.dart';
import '../services/post_service.dart';
import '../widgets/app_bottom_bar.dart';
import '../globals.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key, required this.title});
  final String title;

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final PostService _postService = PostService();

  XFile? postPictureFile;
  bool _isLoading = false;

  Future<void> upload() async {
    setState(() => _isLoading = true);

    String? pictureBase64;

    if (postPictureFile != null) {
      final bytes = await postPictureFile!.readAsBytes();
      pictureBase64 = base64Encode(bytes);
    }

    final post = Post(
      id: global_user!.email,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      postPicture: pictureBase64!,
    );

    final success = await _postService.uploadPost(post);

    setState(() => _isLoading = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Upload successful')),
      );

      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Upload failed')),
      );
    }
  }

  Future<void> _pickPostPicture() async {
    final pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        postPictureFile = pickedFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: "Description"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickPostPicture,
              child: const Text('Pick picture from Gallery'),
            ),
            if (postPictureFile != null)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Icon(Icons.check, color: Colors.green),
              ),
            const SizedBox(height: 30),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: upload,
                    child: const Text("Upload"),
                  ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(selectedIndex: 2),
    );
  }
}