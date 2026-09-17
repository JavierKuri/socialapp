import 'package:flutter/material.dart';
import '../services/image_service.dart';
import '../models/post.dart';
import '../pages/detailed_post_page.dart';

class SmallPostWidget extends StatelessWidget {
  final Post post;
  final ImageService _imageService = ImageService();

  SmallPostWidget({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailedPostPage(post: post),
            ),
          );
      },
      child: FutureBuilder(
        future: _imageService.getImageBytes(post.postPicture),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox(
              height: 100,
              child: Center(child: CircularProgressIndicator()),
            );
          }
          return Image.memory(snapshot.data!, fit: BoxFit.cover);
        },
      ),
    );
  }
}