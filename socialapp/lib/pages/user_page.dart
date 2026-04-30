import 'package:flutter/material.dart';
import 'package:socialapp/globals.dart';
import '../widgets/app_bottom_bar.dart';
import '../services/auth_service.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key, required this.title});
  final String title;
  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final AuthService _authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.picture_in_picture), //will be banner
            const SizedBox(height: 10),
            const Icon(Icons.circle), //will be profile pic
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
      bottomNavigationBar: AppBottomNavBar(selectedIndex: 4),
    );
  }
}