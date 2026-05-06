class Post {
  final String email;
  final String title;
  final String description;
  final String postPicture;

  Post({
    required this.email,
    required this.title,
    required this.description,
    required this.postPicture,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'title': title,
      'description': description,
      'postPicture': postPicture,
    };
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      email: json['email'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      postPicture: json['picture_path'] ?? '',
    );
  }
}