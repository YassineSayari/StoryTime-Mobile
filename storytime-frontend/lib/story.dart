import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ReadStory extends StatefulWidget {
  final String story;
  final String topic;

  const ReadStory({Key? key, required this.topic, required this.story}) : super(key: key);

  @override
  _ReadStoryState createState() => _ReadStoryState();
}

class _ReadStoryState extends State<ReadStory> {
  FlutterTts flutterTts = FlutterTts();
  bool isPlaying = false;
  bool isPaused = false;

  @override
  void initState() {
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
        title: Text(widget.topic),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
              Text(
                '${widget.story}',
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
