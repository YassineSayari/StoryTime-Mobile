import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:storytime/const.dart';
import '../models/story_model.dart';


class StoryService{
  final String apiUrl = '$baseUrl/api/v1/stories';


  Future<List<Story>> getStoriesByUser(String id) async {

    print("getting stories for user :::::::::::: $id");
    final response = await http.get(Uri.parse("$apiUrl/getStoriesByUser/$id"));

     print("Response status code: ${response.statusCode}");
  print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      print("::::::::::got Stories::::::::::");
          final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((eventData) => Story.fromJson(eventData)).toList();
    } else {
      throw Exception('Failed to load stories');
    }
  }

    Future<List<Story>> getSharedStories() async {
    final response = await http.get(Uri.parse("$apiUrl/getSharedStories"));
    print("::::::::::getting shared Stories::::::::::");
    if (response.statusCode == 200) {
       print("::::::::::got Shared Stories::::::::::");
          final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((eventData) => Story.fromJson(eventData)).toList();
    } else {
      throw Exception('Failed to load stories');
    }
  }

  Future<bool> likeStory(String storyId, String userId) async {
    final response = await http.patch(
      Uri.parse("$apiUrl/likeStory/$storyId"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userId': userId}),
    );
    print("User ::::$userId:::::::::adding like:::::::::::to story::::::$storyId");
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");
    if (response.statusCode == 200) {
      print("::::::::::LIKE ADDED::::::::::");
      return true;
    } else {
      throw Exception('Failed to like');
    }
  }

  Future<bool> removeLike(String storyId, String userId) async {
    final response = await http.patch(
      Uri.parse("$apiUrl/removeLike/$storyId"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userId': userId}),
    );
    print(":::::::::removing like:::::::::::");
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");
    if (response.statusCode == 200) {
      print("::::::::::LIKE REMOVED::::::::::");
      return true;
    } else {
      throw Exception('Failed to remove like');
    }
  }




////////////////////////////////////comments////////////////////////////



}