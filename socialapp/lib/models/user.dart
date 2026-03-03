class User {
  final String name;
  final String email;
  final String birthday;
  final String? profilePicture;
  final String? bannerPicture;

  User({
    required this.name,
    required this.email,
    required this.birthday,
    this.profilePicture,
    this.bannerPicture,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      email: json['email'],
      birthday: json['birthday'],
      profilePicture: json['profilePicture'],
      bannerPicture: json['bannerPicture'],
    );
  }
}