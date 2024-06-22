import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_tts/flutter_tts.dart';

class StoryPage extends StatefulWidget {
  final String story;
  final String imageUrl;

  const StoryPage({Key? key, required this.story, required this.imageUrl}) : super(key: key);

  @override
  _StoryPageState createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  FlutterTts flutterTts = FlutterTts();
  bool isPlaying = false;
  bool isPaused = false;

  @override
  void initState() {
    super.initState();
    flutterTts.setLanguage("en-US"); // Set the language of the text
    initTTS();

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

    flutterTts.setProgressHandler((String text, int start, int end, String word) {
      if (end == 1) {
        setState(() {
          isPlaying = false;
          isPaused = false;
        });
      }
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

      await flutterTts.setSpeechRate(0.5); // Adjust the speech rate if needed
      await flutterTts.speak(widget.story);
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

  void _replay() async {
    await flutterTts.stop();
    _speak();
  }

  void _stop() async {
    await flutterTts.stop();
    setState(() {
      isPlaying = false;
      isPaused = false;
    });
  }

  @override
  void dispose() {
    _stop(); // Stop TTS when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Story Page'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: StoryImage(imageUrl: widget.imageUrl),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: isPlaying ? null : _speak,
                icon: Icon(Icons.play_arrow),
                iconSize: 48,
              ),
              SizedBox(width: 10),
              IconButton(
                onPressed: isPaused ? null : _pause,
                icon: Icon(Icons.pause),
                iconSize: 48,
              ),
              SizedBox(width: 10),
              IconButton(
                onPressed: _replay,
                icon: Icon(Icons.replay),
                iconSize: 48,
              ),
            ],
          ),
          SizedBox(height: 16),
          ListTile(
            title: Text(
              'Generated Story:\n${widget.story}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}

class StoryImage extends StatelessWidget {
  final String imageUrl;

  const StoryImage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      placeholder: (context, url) => Container(
        width: 150,
        height: 150,
        color: Colors.grey,
      ),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}
