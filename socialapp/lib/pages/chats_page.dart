import 'package:flutter/material.dart';
import '../widgets/app_bottom_bar.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key, required this.title});
  final String title;
  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(child: Text("CHATS PAGE"),),
      bottomNavigationBar: AppBottomNavBar(selectedIndex: 1),
    );
  }
}