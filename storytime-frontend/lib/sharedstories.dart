import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'components/sharedstory.dart';

class sharedStories extends StatefulWidget {
  const sharedStories({super.key});

  @override
  State<sharedStories> createState() => _sharedStoriesState();
}

class _sharedStoriesState extends State<sharedStories> {
  final currentUser=FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
            children: [
              SizedBox(height: 30),
              Text("Popular Stories ",
                style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color:Color(0xFF9F7BFF)),
              ),
              Expanded(
                  child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('sharedStories').snapshots(),
                      builder: (context,snapshot){
                      if(snapshot.hasData)
                        {
                          return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index){
                            final shStory=snapshot.data!.docs[index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: sharedStory(
                                  topic: shStory['topic'],
                                  story:shStory['story'] ,
                                  owner:shStory['user_email'],
                                  storyId: shStory.id,
                                  likes: List<String>.from(shStory['likes']?? []),
                              ),
                            );

                          },
                          );
                        } else if(snapshot.hasError)
                          {
                            return Center(
                              child: Text("Error" + snapshot.error.toString()),
                            );
                          }
                      return Center(child: CircularProgressIndicator(),
                      );
                      },
                  ),
              ),
              Center(child: Text('User :${currentUser!.email!}')),
            ],
          ),
        ),

    );
  }
}
