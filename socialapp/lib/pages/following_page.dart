import 'package:flutter/material.dart';
import '../widgets/app_bottom_bar.dart';

class FollowingPage extends StatefulWidget {
  const FollowingPage({super.key, required this.title});
  final String title;
  @override
  State<FollowingPage> createState() => _FollowingPageState();
}

class _FollowingPageState extends State<FollowingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(child: Text("Following PAGE"),),
      bottomNavigationBar: AppBottomNavBar(selectedIndex: 2),
    );
  }
}