import 'package:flutter/material.dart';
import '../widgets/app_bottom_bar.dart';
import '../globals.dart';
import '../services/post_service.dart';
import '../models/post.dart';
import '../widgets/PostWidget.dart';

class PostsHomePage extends StatefulWidget {
  const PostsHomePage({super.key, required this.title});
  final String title;
  @override
  State<PostsHomePage> createState() => _PostsHomePageState();
}

class _PostsHomePageState extends State<PostsHomePage> {

  final PostService _postService = PostService();
  Future<List<Post>>? _postsFuture;

  @override
  Widget build(BuildContext context) {

    // Wait until user exists
    if (global_user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    _postsFuture ??= _postService.getPosts();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children:[
            Text("POSTS HOME PAGE"),
             FutureBuilder<List<Post>>(
              future: _postsFuture,
              builder: (context, snapshot) {
                // Loading
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Error
                if (snapshot.hasError) {
                  print(snapshot.error); 
                  return Text("Error: ${snapshot.error}");
                }

                // Empty
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
                          child: PostWidget(post: posts[index]),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ]
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(selectedIndex: 0),
    );
  }
} 