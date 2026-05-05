class Post {
  final String id;
  final String title;
  final String description;
  final String postPicture;

  Post({
    required this.id,
    required this.title,
    required this.description,
    required this.postPicture,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'postPicture': postPicture,
    };
  }

  factory Post.fromJson(Map<String, dynamic> json) {
  return Post(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    postPicture: json['postPicture'],
  );
}
}