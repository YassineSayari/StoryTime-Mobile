class User {
  final String id;
  final String fullName;
  final String email;
  final List<String> roles;
  final String? image;
  final String gender;
  final bool isEnabled;
  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.roles,
    this.image,
    required this.gender,
    required this.isEnabled,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id']?? '',
      fullName: json['fullName']?? '',
      email: json['email']?? '',
      roles: List<String>.from(json['roles']),
      image: json['image'],
      gender: json['gender']?? '',
      isEnabled: json['isEnabled'],
    );
  }

Map<String, dynamic> toJson() {
  return {
    'id': id,
    'fullName': fullName,
    'email': email,
    'roles': roles,
    'image': image,
    'gender': gender,
    'isEnabled': isEnabled,
  };
}}
