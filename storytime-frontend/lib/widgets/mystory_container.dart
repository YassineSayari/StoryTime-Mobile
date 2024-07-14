import 'package:flutter/material.dart';
import 'package:storytime/components/like_button.dart';
import 'package:storytime/components/comment_button.dart';
import 'package:storytime/models/comment_model.dart';
import 'package:storytime/models/story_model.dart';
import 'package:storytime/services/comment_service.dart';
import 'package:storytime/services/shared_preferences.dart';
import 'package:storytime/services/stories_service.dart';
import 'package:storytime/story.dart';

class MyStoryContainer extends StatefulWidget {
  final Story story;

  const MyStoryContainer({
    super.key,
    required this.story,
  });

  @override
  State<MyStoryContainer> createState() => _MyStoryContainerState();
}

class _MyStoryContainerState extends State<MyStoryContainer> {


  bool isLiked=false;
  final StoryService storyService = StoryService();
  final CommentService commentService = CommentService();
  late  List<Comment> _comments=[];

  @override
  void initState()
  {
    super.initState();

        _loadUserInfo().then((_) {
      if ( widget.story.likes.contains(userId) ) {
        setState(() {
          isLiked=true;
        });
      }
    });
    loadComments();
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

  Future<void> loadComments() async {
    try {
      print("loading comments for story:::::::::::::: ${widget.story.id}");
      final comments = await commentService.getCommentsForStory(widget.story.id!);
      setState(() {
        // Assuming you have a variable in the state to hold comments
        _comments = comments;
        print("Comments loaded: ${comments.length}");
      });
    } catch (error) {
      print("Error loading comments::::::::::::: $error");
    }
  }

  void toggleLike() async {
    if (userId == null) {
      print("User ID is null");
      return;
    }

    try {
      if (isLiked) {
        bool success = await storyService.removeLike(widget.story.id!, userId!);
        if (success) {
          setState(() {
            isLiked = false;
            widget.story.likes.remove(userId!);
          });
        }
      } else {
        bool success = await storyService.likeStory(widget.story.id!, userId!);
        if (success) {
          setState(() {
            isLiked = true;
            widget.story.likes.add(userId!);
          });
        }
      }
    } catch (error) {
      print("Error toggling like: $error");
    }
  }


  



  @override
  Widget build(BuildContext context) {
   return  Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: const Color.fromARGB(255, 31, 140, 194),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            //spreadRadius: 5,
            blurRadius: 2,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      width: 350,
      height: null,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Title: ${widget.story.title}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              widget.story.story,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 30),
        
          const SizedBox(height: 8.0),
          Row(
            children: [
              Text(
                'Date: ${widget.story.date.toLocal().toIso8601String().substring(0, 10)}', // Formatting date to 'YYYY-MM-DD'
                style: const TextStyle(color: Colors.grey),
              ),
              const Spacer(),
              GestureDetector(
                  onTap: () {
                      Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ReadStory(story: widget.story,comments: _comments),
                    ),
                  );
                },
                  
                child: const Text("continue Reading",style: TextStyle(color: Colors.purple),
                ),
                ),
            ],
          ),
            Row(
              children: [
                Column(
                  children: [
                  LikeButton(isLiked: isLiked, onTap:toggleLike),
                    const SizedBox(height: 5),
                    Text(widget.story.likes.length.toString()),
                  ],
                ),
                const SizedBox(width: 120),
            Column(
              children: [
                CommentButton(
                  onTap: (){
                
                  },
                ),
                 const SizedBox(height: 5),
                Text(_comments.length.toString()),
              ],
            ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
