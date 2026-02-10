import 'package:flutter/material.dart';
import '../pages/PostsHomePage.dart';
import '../pages/chats_page.dart';
import '../pages/following_page.dart';
import '../pages/user_page.dart';

class AppBottomNavBar extends StatelessWidget {
  final int selectedIndex;

  const AppBottomNavBar({
    super.key,
    required this.selectedIndex,
  });

  void _onItemTapped(BuildContext context, int index) {
    if (index == selectedIndex) return;

    Widget page;

    switch (index) {
      case 0:
        page = PostsHomePage(title: 'Home');
        break;
      case 1:
        page = ChatsPage(title: 'Chats');
        break;
      case 2:
        page = FollowingPage(title: 'Following');
        break;
      case 3:
      default:
        page = UserPage(title: 'User');
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.blueGrey[900],
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey[600],
      currentIndex: selectedIndex,
      onTap: (i) => _onItemTapped(context, i),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.message_rounded),
          label: 'Chats',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.feed_outlined),
          label: 'Following',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'User',
        ),
      ],
    );
  }
}
