import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:storytime/const.dart';
import 'package:storytime/models/comment_model.dart';

class CommentService{
  final String apiUrl = '$baseUrl/api/v1/comments';

  Future<List<Comment>> getCommentsForStory(String storyId) async {
    print("FETCHING COMMENTS /////////// $storyId");
    final response = await http.get(Uri.parse("$apiUrl/getCommentsForStory/$storyId"));
    print(response.statusCode);
    print(response.body);
        if (response.statusCode == 200) {
      print("::::::::::got COMMENTS::::::::::");
          final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((eventData) => Comment.fromJson(eventData)).toList();
    } else {
      throw Exception('Failed to load COMMENTS');
    }
  }




}
