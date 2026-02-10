import 'package:flutter/material.dart';
import '../widgets/app_bottom_bar.dart';

class PostsHomePage extends StatefulWidget {
  const PostsHomePage({super.key, required this.title});
  final String title;
  @override
  State<PostsHomePage> createState() => _PostsHomePageState();
}

class _PostsHomePageState extends State<PostsHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(child: Text("POSTS HOME PAGE"),),
      bottomNavigationBar: AppBottomNavBar(selectedIndex: 0),
    );
  }
}