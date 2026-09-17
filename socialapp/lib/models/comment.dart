import 'post.dart';

class Comment {
  final String email;
  final String description;
  final Post post;

  Comment({
    required this.email,
    required this.description,
    required this.post,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'description': description,
      'post': post,
    };
  }

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      email: json['email'] ?? '',
      description: json['description'] ?? '',
      post: json['post'] is Map<String, dynamic>
          ? Post.fromJson(json['post'])
          : Post(email: '', title: '', description: '', postPicture: ''),
    );
  }
}