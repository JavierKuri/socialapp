import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:socialapp/globals.dart';
import '../widgets/app_bottom_bar.dart';
import '../services/auth_service.dart';
import '../services/image_service.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key, required this.title});
  final String title;
  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final AuthService _authService = AuthService();
  final ImageService _imageService = ImageService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Expanded(
          child: ListView(
            children: [
          
              //Banner picture
              FutureBuilder<Uint8List?>(
                future: _imageService.getImageBytes(global_user!.bannerPicture!),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
          
                  return Image.memory(snapshot.data!);
                },
              ),
          
              const SizedBox(height: 10),
          
              //Profile picture
              FutureBuilder<Uint8List?>(
                future: _imageService.getImageBytes(global_user!.profilePicture!),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  return Image.memory(snapshot.data!);
                },
              ),
          
              const SizedBox(height: 10),
              Text(global_user!.name + " Birthday: " + global_user!.birthday, textAlign: TextAlign.center,),
              const SizedBox(height: 10),
              const Text("Your Uploads"),
              const Row(children: [Icon(Icons.one_k)],), //scrollable row with user uploads
              const SizedBox(height: 10),
              ElevatedButton(onPressed: () =>_authService.logout(context), child: const Text("LOGOUT"))
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(selectedIndex: 4),
    );
  }
}