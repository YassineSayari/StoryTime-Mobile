import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:storytime/components/comment.dart';
import 'package:storytime/components/report_button.dart';

import '../formatdate.dart';

class readSharedStory extends StatefulWidget {
  final String topic;
  final String story;
  final String storyId;

  const readSharedStory({
    super.key,
    required this.topic,
    required this.story,
    required this.storyId,
  });

  @override
  State<readSharedStory> createState() => _readSharedStoryState();
}

class _readSharedStoryState extends State<readSharedStory> {
  FlutterTts flutterTts = FlutterTts();
  bool isPlaying = false;
  bool isPaused = false;

  TextEditingController _commentController = TextEditingController();
  TextEditingController _reportMessageController=TextEditingController();

  @override
  void initState() {
    super.initState();
    flutterTts.setLanguage("en-US"); // text language

    initTTS();

    // pause handler
    flutterTts.setPauseHandler(() {
      setState(() {
        isPaused = true;
        isPlaying = false;
      });
    });
    flutterTts.setContinueHandler(() {
      setState(() {
        isPaused = false;
        isPlaying = true;
      });
    });
  }

  void initTTS() {
    flutterTts.getVoices.then((data) {
      try {
        List<Map> voices = List<Map>.from(data);
        print(voices);
      } catch (e) {
        print(e);
      }
    });
  }

  void _speak() async {
    try {
      setState(() {
        isPlaying = true;
        isPaused = false;
      });

      await flutterTts.setSpeechRate(0.5);

      await flutterTts.setVoice({
        "name": "en-US-language",
        "locale": "en-US",
      });

      await flutterTts.setPitch(1.0);

      await flutterTts.speak(widget.story);

      // Listen for TTS completion to update the UI
      flutterTts.setProgressHandler((String text, int start, int end, String word) {
        if (end == 1) {
          setState(() {
            isPlaying = false;
            isPaused = false;
          });
        }
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  void _pause() async {
    if (isPlaying) {
      await flutterTts.pause();
      setState(() {
        isPaused = true;
        isPlaying = false;
      });
    }
  }

// Restart story
  void _restart() {
    //if (isPaused) {
      flutterTts.stop();
      setState(() {
        isPaused = false;
        isPlaying = false;
      });
      _speak();
   // }
  }

  final currentUser = FirebaseAuth.instance.currentUser;

  void addComment(String commentText) {
    if (commentText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Container(
            alignment: Alignment.center,
            child: Text(
              'Empty message',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          backgroundColor: Colors.teal,
          behavior: SnackBarBehavior.floating,
          width: 200,
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      FirebaseFirestore.instance
          .collection('sharedStories')
          .doc(widget.storyId)
          .collection("comments")
          .add({
        'commentText': commentText,
        'commentedBy': currentUser?.email,
        'commentTime': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Comment added'),
          backgroundColor: Colors.teal,
          behavior: SnackBarBehavior.floating,
          width: 200,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  //report comment dialog
  void reportDialog(String reportedCommentText, String reportedUser)
  {
    showDialog(context: context,
        builder: (context)=>AlertDialog(
          title: Text('Report this comment'),
          content:TextField(
            controller: _reportMessageController,
            decoration: InputDecoration(hintText: 'Add your report...'),
          ) ,
        actions: [
          TextButton(onPressed: () {
            addReport(
              _reportMessageController.text,
              reportedCommentText,
              reportedUser,
              DateTime.now(),
            );
            _reportMessageController.clear();
            Navigator.pop(context);
          },
            child: Text('Report'),
          ),
          TextButton(onPressed: (){
             Navigator.pop(context);
            _reportMessageController.clear();
          },
            child: Text('Cancel'),
          ),
        ],
        ),

    );
  }




  //report comment method
  void addReport(String reportMessage, String reportedComment, String reportedUser, DateTime reportTime) {
    if (reportMessage.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Empty report message'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          width: 200,
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      //add report
      FirebaseFirestore.instance.collection('reportedComments').add({
        'reportMessage': reportMessage,
        'reportedComment': reportedComment,
        'reportedUser': reportedUser,
        'reportedBy': currentUser?.email,
        'reportTime': reportTime,
      });

      //success snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Reported comment successfully'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          width: 200,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }


  //report story method
  Future<void> reportStory(String reportMessage, DateTime reportTime) async {
    if (reportMessage.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Empty report message'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          width: 200,
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      try {
        DocumentSnapshot storySnapshot = await FirebaseFirestore.instance
            .collection('sharedStories')
            .doc(widget.storyId)
            .get();

        String storyOwner = storySnapshot['user_email'];

        // Add report
        await FirebaseFirestore.instance.collection('reportedStories').add({
          'reportMessage': reportMessage,
          'reportedStory': widget.story,
          'reportedStoryTopic': widget.topic,
          'reportedStoryOwner': storyOwner,
          'reportedBy': currentUser?.email,
          'reportTime': reportTime,
        });

        // Success snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Reported Story successfully'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            width: 200,
            duration: Duration(seconds: 2),
          ),
        );
      } catch (e) {
        print("Error retrieving story: $e");
        // Handle the error (e.g., show an error snackbar)
      }
    }
  }

  //report story dialog
  void reportStoryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Report this story'),
        content: TextField(
          controller: _reportMessageController,
          decoration: InputDecoration(hintText: 'Add a report...'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              reportStory(
                _reportMessageController.text,
                DateTime.now(),
              );
              _reportMessageController.clear();
              Navigator.pop(context);
            },
            child: Text('Report'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _reportMessageController.clear();
            },
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.topic),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ReportButton(
                  onTap: () {
                    reportStoryDialog();
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.topic}:\n',
                    style: TextStyle(
                      fontSize: 29,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: isPlaying ? null : () => _speak(),
                        icon: Icon(Icons.play_arrow),
                        iconSize: 48,
                      ),
                      SizedBox(width: 10),
                      IconButton(
                        onPressed: isPaused ? null : () => _pause(),
                        icon: Icon(Icons.pause),
                        iconSize: 48,
                      ),
                      SizedBox(width: 10),
                      IconButton(
                        onPressed: () => _restart(),
                        icon: Icon(Icons.replay),
                        iconSize: 48,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  SingleChildScrollView(
                    child: Text(
                      '${widget.story}',
                      style: TextStyle(
                        fontSize: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Comments :",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
            SizedBox(height: 5),
            SingleChildScrollView(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("sharedStories")
                    .doc(widget.storyId)
                    .collection("comments")
                    .orderBy("commentTime", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final commentData = snapshot.data!.docs[index].data()
                      as Map<String, dynamic>;
                      return Comment(
                        text: commentData['commentText'],
                        user: commentData['commentedBy'],
                        time: formatDate(commentData['commentTime']),
                        onTapReport: () {
                          // padd comment details to dialog
                          reportDialog(
                              commentData['commentText'],
                              commentData['commentedBy']);
                        },
                      );
                    },
                  );
                },
              ),
            ),
            Container(
              color: Colors.grey[400],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        decoration: InputDecoration(
                          hintText: 'Add a comment...',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        addComment(_commentController.text);
                        _commentController.clear();
                      },
                      icon: Icon(Icons.arrow_forward),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    /*  bottomNavigationBar: Container(
        color: Colors.grey[400],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    hintText: 'Add a comment...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  addComment(_commentController.text);
                  _commentController.clear();
                },
                icon: Icon(Icons.arrow_forward),
              ),
            ],
          ),
        ),
      ),*/
    );
  }
}