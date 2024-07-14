import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:storytime/const.dart';
import 'package:storytime/models/comment_model.dart';
import 'package:storytime/models/story_model.dart';

class ReadStory extends StatefulWidget {
  final Story story;
  final List<Comment> comments;

  const ReadStory({Key? key, required this.story, required this.comments}) : super(key: key);

  @override
  _ReadStoryState createState() => _ReadStoryState();
}

class _ReadStoryState extends State<ReadStory> {
  FlutterTts flutterTts = FlutterTts();
  bool isPlaying = false;
  bool isPaused = false;

  @override
  void initState() {
      print("comments:::::::::::::: ${widget.comments}");

    super.initState();
    flutterTts.setLanguage("en-US"); // Set the language of the text

    initTTS();


    // Set the pause handler
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

      await flutterTts.speak(widget.story.story);

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

  void _restart() {
    if (isPaused) {
      flutterTts.stop();
      setState(() {
        isPaused = false;
        isPlaying = false;
      });
      _speak(); // Restart the story
    }
  }

  @override
  void dispose() {
    // Don't forget to stop TTS when the widget is disposed
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.story.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${widget..story.title}:\n',
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
              Text(
                '${widget.story.story}',
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
            SizedBox(height: 20),
              Text(
                'Comments:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
             ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.comments.length,
                itemBuilder: (context, index) {
                  final comment = widget.comments[index];
                  return CommentWidget(comment: comment);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CommentWidget extends StatelessWidget {
  final Comment comment;

  const CommentWidget({Key? key, required this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage('$imageUrl/${comment.user.image}'),
            radius: 20,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comment.user.fullName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(comment.comment),
                SizedBox(height: 4),
                Text(
                  comment.date.toLocal().toIso8601String().substring(0, 10),
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}