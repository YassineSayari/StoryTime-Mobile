import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:storytime/models/story_model.dart';
import 'package:storytime/services/shared_preferences.dart';
import 'package:storytime/services/stories_service.dart';
import 'package:storytime/widgets/mystory_container.dart';

class MyStories extends StatefulWidget {
  const MyStories({super.key});

  @override
  State<MyStories> createState() => _MyStoriesState();
}

class _MyStoriesState extends State<MyStories> {
  late Future<List<Story>> stories;

  @override
  void initState() {
    super.initState();
    stories = Future.value([]);
    _loadUserInfo().then((_) {
      if (userId != null) {
        setState(() {
          stories = StoryService().getStoriesByUser(userId!);
        });
      }
    });
  }

  final SharedPrefs sharedPrefs = SharedPrefs();
  late Map<String, dynamic> userInfo = {};
  late String? userId = " ";

  Future<void> _loadUserInfo() async {
    try {
      final data = await SharedPrefs.getUserInfo();
      setState(() {
        userInfo = data;
        userId = data["userId"];
        print("User loaded: id $userId");
      });
    } catch (error) {
      print("Error loading user info: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Stories'),
      ),
      body: FutureBuilder<List<Story>>(
        future: stories,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No stories found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final story = snapshot.data![index];
                return MyStoryContainer(story:story);
              },
            );
          }
        },
      ),
    );
  }
}
