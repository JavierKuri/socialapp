import 'package:flutter/material.dart';
import '../services/image_service.dart';
import '../models/post.dart';

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
        // TODO
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