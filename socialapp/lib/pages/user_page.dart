import 'package:flutter/material.dart';
import '../widgets/app_bottom_bar.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key, required this.title});
  final String title;
  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(child: Text("USER PAGE"),),
      bottomNavigationBar: AppBottomNavBar(selectedIndex: 4),
    );
  }
}