class SignupRequest {
  final String name;
  final String email;
  final String password;
  final String birthday;
  final String? profilePicture;
  final String? bannerPicture;

  SignupRequest({
    required this.name,
    required this.email,
    required this.password,
    required this.birthday,
    this.profilePicture,
    this.bannerPicture,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'birthday': birthday,
      'profilePicture': profilePicture,
      'bannerPicture': bannerPicture,
    };
  }
}