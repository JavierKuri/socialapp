import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../widgets/app_bottom_bar.dart';
import '../widgets/small_post_widget.dart';
import '../services/image_service.dart';
import '../services/post_service.dart';
import '../services/user_service.dart';
import '../models/post.dart';
import '../models/user.dart';

class OtherUserPage extends StatefulWidget {
  const OtherUserPage({super.key, required this.title, required this.email});
  final String title;
  final String email;

  @override
  State<OtherUserPage> createState() => _OtherUserPageState();
}

class _OtherUserPageState extends State<OtherUserPage> {
  final ImageService _imageService = ImageService();
  final PostService _postService = PostService();
  final UserService _userService = UserService();

  Future<User?>? _userFuture;
  Future<List<Post>>? _postsFuture;

  @override
  void initState() {
    super.initState();
    // Fetch target user details and posts using widget.email
    _userFuture = _userService.getUserByEmail(widget.email);
    _postsFuture = _postService.getPostsByUser(widget.email);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.email.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.title.isNotEmpty ? widget.title : widget.email),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<User?>(
        future: _userFuture,
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (userSnapshot.hasError || !userSnapshot.hasData) {
            return const Center(child: Text("Failed to load user profile."));
          }

          final targetUser = userSnapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(20),
            child: ListView(
              children: [
                // 1. Target User's Banner Picture
                if (targetUser.bannerPicture != null &&
                    targetUser.bannerPicture!.isNotEmpty)
                  FutureBuilder<Uint8List?>(
                    future: _imageService.getImageBytes(targetUser.bannerPicture!),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox(
                          height: 120,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      if (!snapshot.hasData || snapshot.data == null) {
                        return Container(height: 120, color: Colors.grey[300]);
                      }
                      return Image.memory(
                        snapshot.data!,
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      );
                    },
                  )
                else
                  Container(height: 120, color: Colors.grey[300]),

                const SizedBox(height: 10),

                // 2. Target User's Profile Picture
                if (targetUser.profilePicture != null &&
                    targetUser.profilePicture!.isNotEmpty)
                  FutureBuilder<Uint8List?>(
                    future: _imageService.getImageBytes(targetUser.profilePicture!),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox(
                          height: 80,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      if (!snapshot.hasData || snapshot.data == null) {
                        return const CircleAvatar(
                          radius: 40,
                          child: Icon(Icons.person, size: 40),
                        );
                      }
                      return CircleAvatar(
                        radius: 40,
                        backgroundImage: MemoryImage(snapshot.data!),
                      );
                    },
                  )
                else
                  const CircleAvatar(
                    radius: 40,
                    child: Icon(Icons.person, size: 40),
                  ),

                const SizedBox(height: 16),

                // Uploads Header
                const Text(
                  "Uploads",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                // 3. User Posts
                FutureBuilder<List<Post>>(
                  future: _postsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Text("Error: ${snapshot.error}");
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text("No posts yet");
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
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: AppBottomNavBar(selectedIndex: 4),
    );
  }
}