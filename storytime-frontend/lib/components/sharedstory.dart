import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../languages/readsharedstory.dart';
import 'like_button.dart';

class sharedStory extends StatefulWidget {
  final String topic;
  final String story;
  final String owner;
  final List<String> likes;
  final String storyId;

  const sharedStory({super.key,required this.topic, required this.story,required this.owner, required this.likes,required this.storyId});

  @override
  State<sharedStory> createState() => _sharedStoryState();
}

class _sharedStoryState extends State<sharedStory> {

  final currentUser=FirebaseAuth.instance.currentUser;
  bool isLiked=false;

  @override
  void initState()
  {
    super.initState();
    isLiked=widget.likes.contains(currentUser?.email);
  }

  void toggleLike()
  {
    setState(() {
      isLiked= !isLiked;
    });

    DocumentReference storyRef= FirebaseFirestore.instance.collection('sharedStories').doc(widget.storyId);
    if (isLiked)
      {
        storyRef.update({
          'likes': FieldValue.arrayUnion([currentUser?.email])
        });
      }
    else
      {
       storyRef.update({
         'likes':FieldValue.arrayRemove([currentUser?.email])
       });
      }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Color(0xff8191da),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      width: 350,
      height: null,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Title: ${widget.topic}',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only( right: 16.0),
              child: Text(
                'By: ${widget.owner}',
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 10,
                ),
              ),
            ),
          ),
          SizedBox(height: 30),

          Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => readSharedStory(
                        topic: widget.topic,
                        story: widget.story,
                        storyId: widget.storyId,
                      ),
                    ),
                  );
                },
                child: Text('read full story')
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                LikeButton(isLiked: isLiked, onTap:toggleLike),
                  SizedBox(height: 5),
                  Text(widget.likes.length.toString()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
