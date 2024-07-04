import 'package:flutter/material.dart';
import 'package:storytime/story.dart';

class MyStoryContainer extends StatelessWidget {
  final String title;
  final String story;
  final DateTime date;

  const MyStoryContainer({
    super.key,
    required this.title,
    required this.story,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            story,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 16.0,
            ),
          ),
          const SizedBox(height: 8.0),
          Row(
            children: [
              Text(
                'Date: ${date.toLocal().toIso8601String().substring(0, 10)}', // Formatting date to 'YYYY-MM-DD'
                style: const TextStyle(color: Colors.grey),
              ),
              Spacer(),
              GestureDetector(
                  onTap: () {
                      Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ReadStory(topic: title, story: story),
                    ),
                  );
                },
                  
                child: Text("continue Reading",style: TextStyle(color: Colors.purple),
                ),
                ),
            ],
          ),
        
          
        ],
      ),
    );
  }
}
