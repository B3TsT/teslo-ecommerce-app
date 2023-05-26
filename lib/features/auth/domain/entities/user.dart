class User {
  final String id;
  final String email;
  final String fullName;
  final List<String> roles;
  final String token;

  User({
    required this.id,
    required this.email,
    required this.fullName,
    required this.roles,
    required this.token,
  });

  bool get isAdmin {
    return roles.contains('admin');
  }

  // factory User.fromJson(Map<String, dynamic> json) {
  //   return User(id: json['id'], email: json['email'], token: json['token']);
  // }

  // Map<String, dynamic> toJson() {
  //   return {'id': id, 'email': email, 'token': token};
  // }
}
