import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:storytime/story.dart';

// Define the SavedStory class
class SavedStory {
  final String id;
  final String topic;
  final String story;

  SavedStory({required this.id, required this.topic, required this.story});
}

class SavedStoriesPage extends StatelessWidget {
  final String userEmail;

  SavedStoriesPage({Key? key, required this.userEmail}) : super(key: key);

  Future<List<SavedStory>> getUserStories() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('stories')
          .where('email', isEqualTo: userEmail)
          .get();

      List<SavedStory> userStories = snapshot.docs.map((doc) {
        return SavedStory(
          id: doc.id,
          topic: doc.get('topic'),
          story: doc.get('story'),
        );
      }).toList();

      return userStories;
    } catch (e) {
      print('Error getting user stories: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SavedStory>>(
      future: getUserStories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: SpinKitSpinningLines(color: Colors.blueAccent));
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('No saved stories found.');
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text('My Stories', style: TextStyle(fontSize: 30)),
              centerTitle: true,
            ),
            body: ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    snapshot.data![index].topic,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.redo),
                        onPressed: () async {
                          // Show a confirmation dialog
                          bool shareConfirmed = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Share Story'),
                                content: Text('Are you sure you want to share this story to sharedStories?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(true),
                                    child: Text('Share'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(false),
                                    child: Text('Cancel'),
                                  ),
                                ],
                              );
                            },
                          );

                          // Share the story if confirmed
                          if (shareConfirmed == true) {
                            try {
                              // Get the story details
                              String topic = snapshot.data![index].topic;
                              String story = snapshot.data![index].story;

                              // Add the story to the 'sharedStories' collection
                              await FirebaseFirestore.instance.collection('sharedStories').add({
                                'topic': topic,
                                'story': story,
                                'user_email': userEmail,
                                'likes': [], // Initialize likes to 0
                              });

                              // Optionally, you can show a success message or perform any other action
                              print('Story shared successfully to sharedStories collection!');
                            } catch (e) {
                              print('Error sharing story: $e');
                              // Handle the error as needed
                            }
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.share),
                        onPressed: () {
                          // Implement share functionality here
                          // You can use share plugins like 'share_plus'
                          // Example: Share.share(snapshot.data![index].story);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          // Show a confirmation dialog
                          bool deleteConfirmed = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Delete Story'),
                                content: Text('Are you sure you want to delete this story?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      print("Delete Confirmed");
                                      Navigator.of(context).pop(true);
                                    },
                                    child: Text('Delete'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(false),
                                    child: Text('Cancel'),
                                  ),
                                ],
                              );
                            },
                          );

                          // Delete the story if confirmed
                          if (deleteConfirmed == true) {
                            await FirebaseFirestore.instance
                                .collection('stories')
                                .doc(snapshot.data![index].id)
                                .delete();

                            // Reload the page to reflect changes
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SavedStoriesPage(userEmail: userEmail),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            Story(topic: snapshot.data![index].topic, story: snapshot.data![index].story),
                      ),
                    );
                  },
                );
              },
            ),
          );
        }
      },
    );
  }
}