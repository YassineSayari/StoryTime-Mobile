import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:storytime/const.dart';
import '../models/story_model.dart';


class StoryService{
  final String apiUrl = '$baseUrl/api/v1/stories';


  Future<List<Story>> getStoriesByUser(String id) async {

    print("getting stories for user :::::::::::: $id");
    final response = await http.get(Uri.parse("$apiUrl/getStoriesByUser/$id"));

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

    if (response.statusCode == 200) {
          final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((eventData) => Story.fromJson(eventData)).toList();
    } else {
      throw Exception('Failed to load stories');
    }
  }

}