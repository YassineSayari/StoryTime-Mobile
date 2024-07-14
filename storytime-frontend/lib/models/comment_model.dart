class Comment {
  String? id;
  String comment;
  DateTime date;
  bool isReported;
  String story;
  User user;

  Comment({
    this.id,
    required this.comment,
    required this.date,
    required this.isReported,
    required this.story,
    required this.user,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['_id'] as String?,
      comment: json['Comment'] ?? '',
      date: DateTime.parse(json['Date'] ?? DateTime.now().toIso8601String()),
      isReported: json['isReported'] ?? false,
      story: json['Story'] ?? '',
      user: json['User'] != null ? User.fromJson(json['User']) : User(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'Comment': comment,
      'Story': story,
      'Date': date.toIso8601String(),
      'isReported': isReported,
      'User': user.toJson(),
    };
  }
}

class User {
  String id;
  String fullName;
  String email;
  String image;

  User({
    this.id = '',
    this.fullName = '',
    this.email = '',
    this.image = '',
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'fullName': fullName,
      'email': email,
      'image': image,
    };
  }
}
