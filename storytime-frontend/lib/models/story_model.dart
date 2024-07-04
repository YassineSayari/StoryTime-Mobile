class Story {
  String? id;
  String title;
  String story;
  DateTime date;
  bool isShared;
  String owner;

  Story({
    this.id,
    required this.title,
    required this.story,
    required this.date,
    required this.isShared,
    required this.owner,
  });

  // Factory constructor to create a Story from JSON
  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: json['_id'] as String?,
      title: json['Title'] ?? '',
      story: json['Story'] ?? '',
      date: DateTime.parse(json['Date'] ?? DateTime.now().toIso8601String()),
      isShared: json['isShared'] ?? false,
      owner: json['Owner'] != null ? json['Owner']['_id'] ?? '' : '',
    );
  }

  // Method to convert a Story instance to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'Title': title,
      'Story': story,
      'Date': date.toIso8601String(),
      'isShared': isShared,
      'Owner': owner,
    };
  }
}
