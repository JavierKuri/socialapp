import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:socialapp/globals.dart';
import '../widgets/app_bottom_bar.dart';
import '../widgets/small_post_widget.dart';
import '../services/auth_service.dart';
import '../services/image_service.dart';
import '../services/post_service.dart';
import '../models/post.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key, required this.title});
  final String title;
  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final AuthService _authService = AuthService();
  final ImageService _imageService = ImageService();
  final PostService _postService = PostService();
  late Future<List<Post>> _postsFuture;

  @override
  void initState() {
    super.initState();
    _postsFuture = _postService.getPosts(global_user!.email);
  }

  @override
  Widget build(BuildContext context) {
    if (global_user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [

            // Banner
            FutureBuilder<Uint8List?>(
              future: _imageService.getImageBytes(global_user!.bannerPicture!),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                return Image.memory(snapshot.data!);
              },
            ),

            const SizedBox(height: 10),

            // Profile
            FutureBuilder<Uint8List?>(
              future: _imageService.getImageBytes(global_user!.profilePicture!),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                return Image.memory(snapshot.data!);
              },
            ),
            const SizedBox(height: 10),
            Text(
              "${global_user!.name} Birthday: ${global_user!.birthday}",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),

            //User uploads
            const Text("Your Uploads"),
            FutureBuilder<List<Post>>(
              future: _postsFuture,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final posts = snapshot.data!;
                return SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: SizedBox(
                          width: 120,
                          child: SmallPostWidget(post: posts[index]),
                        ),
                      );
                    },
                  ),
                );
              },
            ),

            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _authService.logout(context),
              child: const Text("LOGOUT"),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(selectedIndex: 4),
    );
  }
}