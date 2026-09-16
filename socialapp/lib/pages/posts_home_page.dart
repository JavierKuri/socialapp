import 'package:flutter/material.dart';
import '../widgets/app_bottom_bar.dart';
import '../globals.dart';
import '../services/post_service.dart';
import '../models/post.dart';
import '../widgets/post_widget.dart';

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
  void initState() {
    super.initState();
    _postsFuture = _postService.getPosts();
  }

  // Refresh handler for pull-to-refresh
  Future<void> _refreshPosts() async {
    setState(() {
      _postsFuture = _postService.getPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Wait until user exists
    if (global_user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshPosts,
        child: FutureBuilder<List<Post>>(
          future: _postsFuture,
          builder: (context, snapshot) {
            // 1. Loading state
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            // 2. Error state
            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text("Error loading posts: ${snapshot.error}"),
                ),
              );
            }

            // 3. Empty state
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  "No posts yet",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }

            final posts = snapshot.data!;

            // 4. Full-screen list of posts
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: PostWidget(post: posts[index]),
                );
              },
            );
          },
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(selectedIndex: 0),
    );
  }
}