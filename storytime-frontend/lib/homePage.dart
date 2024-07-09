import 'dart:async';
import 'dart:convert';
//import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:storytime/models/story_model.dart';
import 'package:storytime/services/stories_service.dart';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:http/http.dart' as http;
import 'package:storytime/components/comment_button.dart';
import 'package:storytime/components/like_button.dart';
import 'package:storytime/languages/readsharedstory.dart';
import 'package:storytime/profile/profile_screen.dart';
import 'package:storytime/services/authentication_service.dart';
import 'package:storytime/sharedstories.dart';
import 'package:storytime/theme.dart';
import 'package:storytime/widgets/mystory_container.dart';
import 'languages/app_localizations.dart';
import 'languages/language_provider.dart';

import 'storyPage.dart';
import 'savedStories.dart';

class homePage extends StatefulWidget {
  const homePage({Key? key, required this.controller, this.userEmail}) : super(key: key);
  final PageController controller;
  final String? userEmail;


  @override
  State<homePage> createState() => homePageState();
}

class homePageState extends State<homePage> {
  //final _formKey = GlobalKey<FormState>();
  final TextEditingController topic = TextEditingController();
  String generatedStory = '';
  String generatedImageUrl = '';

  bool isLiked=true;


  List<String> imageCarouselUrls = [
    'assets/images/layla.jpeg',
    'assets/images/boy.jpeg',
    'assets/images/parent.jpeg',
    'assets/images/kid_astronaut.jpeg',
    'assets/images/lamb.jpeg',
    'assets/images/dinosaur2.jpeg',
    'assets/images/parent2.jpeg',
    'assets/images/hboy.jpeg',
    'assets/images/cat.jpeg',
    'assets/images/kid_swing.jpeg',
    'assets/images/parent3.jpeg',
    'assets/images/kid_run.jpeg',
    'assets/images/kid_adventuror.jpeg',

  ];


  LanguageProvider languageProvider = LanguageProvider();


  int currentPage = 0;
  late Timer timer;



  @override
  void initState() {
    super.initState();
    languageProvider.loadSavedLanguage(context);
    getUserImageUrl();


    timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (currentPage < imageCarouselUrls.length - 1) {
        currentPage++;
      } else {
        currentPage = 0;
      }
      widget.controller.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }



  Future<void> generateStory(String topic) async {
    print('Generating story...');

    final apiKey = 'AIzaSyCCfqRXuA96Z2UqjMRY4lKmMrSKkfQdImg'; // Replace with your actual API key
    final textEndpoint = 'https://generativelanguage.googleapis.com/v1beta2/models/chat-bison-001:generateMessage?key=$apiKey';
    final unsplashEndpoint = 'https://api.unsplash.com/photos/random';
    final unsplashAccessKey = 'hYIAb65E5FOFs_t2SyLqm6YBgd2vGXfv9hUfD_dujzI'; // Replace with your actual Unsplash API key

    Locale currentLocale = Localizations.localeOf(context);
    String languageCode = currentLocale.languageCode;

    Map<String, String> languageNames = {
      'en': 'English',
      'fr': 'Français',
      'es': 'Spanish',
      'de': 'German',
      'ar': 'Arabic',
    };

    String languageName = languageNames[languageCode] ?? 'Unknown';
    String langue = languageName.toLowerCase();
    print("Language for story: $langue");

    final prompt = {
      'context': 'Generate a short story for children. Make it 2 short paragraphs and provide a happy ending.',
      'examples': [
        {
          'input': {
            'content': 'Generate a short story for children about dragons. The language is English'
          },
          'output': {
            'content': 'Once upon a time, in a land far away, there lived a brave little dragon named Sparkle...'
          }
        },
        {
          'input': {
            'content': 'Generate a short story for children about فتاة تحب الكعكة. The language is arabic'
          },
          'output': {
            'content': 'ذات مرة، في أرض بعيدة، عاشت فتاة تحب الكعكة...'
          }
        }
      ],
      'messages': [
        {
          'content': 'Generate a short story for children in $langue about $topic'
        }
      ]
    };

    final textResponse = await http.post(
      Uri.parse(textEndpoint),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'prompt': prompt,
      }),
    );

    if (textResponse.statusCode == 200) {
      final textData = jsonDecode(textResponse.body);

      if ((textData.containsKey('candidates') && textData['candidates'] != null) ||(textData.containsKey('messages') && textData['messages'] != null)) {
        final storyContent = textData['candidates'] != null  ? textData['candidates'][0]['content']  : textData['messages'][0]['content'];

        setState(() {
          generatedStory = storyContent.toString(); // Convert storyContent to string
        });

        saveStory(topic, generatedStory, widget.userEmail!);

        final unsplashResponse = await http.get(
          Uri.parse('$unsplashEndpoint?query=$topic as a child friendly image'),
          headers: {'Authorization': 'Client-ID $unsplashAccessKey'},
        );

        if (unsplashResponse.statusCode == 200) {
          final unsplashData = jsonDecode(unsplashResponse.body);

          print('Unsplash Data: $unsplashData');

          if (unsplashData.containsKey('urls') && unsplashData['urls'] != null) {
            setState(() {
              generatedImageUrl = unsplashData['urls']['regular'];
            });

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StoryPage(story: generatedStory, imageUrl: generatedImageUrl),
              ),
            );
          } else {
            print('Error: Invalid Unsplash API response');
          }
        } else {
          print('Error generating image: ${unsplashResponse.reasonPhrase}');
        }
      } else {
        print('Error: Invalid textData structure - candidates or messages key missing or null');
      }

    } else {
      print('Error generating story: ${textResponse.reasonPhrase}');
      print('Text API Response: ${textResponse.statusCode}');
      print('Text API Response Body: ${textResponse.body}');
    }
  }




  
  void saveStory(String topic, String generatedStory, String userEmail) async {
    final CollectionReference storiesCollection =
    FirebaseFirestore.instance.collection('stories');

    final CollectionReference usersCollection =
    FirebaseFirestore.instance.collection('users');

    try {
      QuerySnapshot userQuery = await usersCollection
          .where('email', isEqualTo: userEmail)
          .limit(1)
          .get();

      if (userQuery.docs.isNotEmpty) {
        String userFirstName = userQuery.docs[0].get('firstName');
        String userLastName = userQuery.docs[0].get('lastName');

        await storiesCollection.add({
          'firstname': userFirstName,
          'lastname': userLastName,
          'story': generatedStory,
          'topic': topic,
          'email': userEmail,
        });

        print('Story saved successfully to Firestore!');
      }
    } catch (e) {
      print('Error saving story to Firestore: $e');
    }
  }

  Widget listeDesImages() {
    return Expanded(
      child: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery
              .of(context)
              .size
              .height * 0.6,
          child: PageView.builder(
            controller: widget.controller,
            itemCount: imageCarouselUrls.length,
            itemBuilder: (context, index) {
              return MyImage(imageUrl: imageCarouselUrls[index]);
            },
          ),
        ),
      ),
    );
  }


Future<List<Story>> getSharedStories() async {
  try {
    // Create an instance of StoryService
    final storyService = StoryService();
    
    // Call the instance method
    List<Story> stories = await storyService.getSharedStories();

    return stories;
  } catch (e) {
    print('Error getting shared stories: $e');
    return [];
  }
}


  Future<int> getCommentsCount(String storyId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> commentsSnapshot = await FirebaseFirestore.instance
          .collection('sharedStories')
          .doc(storyId)
          .collection('comments')
          .get();

      return commentsSnapshot.size;
    } catch (e) {
      print('Error getting comments count: $e');
      return 0;
    }
  }
  
  Future<void> handleLogout() async{
    AuthService authService=AuthService();
    print("loggin out");
    Navigator.of(context).pushReplacementNamed('/login');
    authService.logout();
      }


Future<void> getUserImageUrl() async {
  try {

    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get();


        print("getting user image:::::::::::::");

    var userData = userDoc.data() as Map<String, dynamic>?;
     String? userImage = userData?['image'];
     final storage= FirebaseStorage.instance;
     

    if (userImage != null && userImage.isNotEmpty) {
      // Fetch the image URL from Firebase Storage
      print("getting image:::::::::::::::::::::::");
      final ref=storage.ref().child(userImage);
      String image= await ref.getDownloadURL();
       print("image to dispaly:::::::::::$image");
    } else {
      print('no image found::::::::::::::::::');
      final noImageref=storage.ref().child('no_image.jpg');
      String image= await noImageref.getDownloadURL();
      print("image to dispaly:::::::::::$image");
    }
  } catch (e) {
    // If any error occurs, return the default image URL
    print("error : $e");
  }
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: CustomScrollView(
      slivers: [
        const SliverAppBar(
          expandedHeight: 200,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              'StoryTime',
              style: TextStyle(
                color: Colors.black,
                fontFamily: AppTheme.fontName,
                fontSize: 30,
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextFormField(
              controller: topic,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).translate('story_prompt') ??
                    'Enter Your Story Topic',
                labelStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(
                    width: 3,
                    color: Colors.black45,
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(
                    width: 3,
                    color: Colors.black,
                  ),
                ),
              ),
              maxLines: 5,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a story topic';
                }
                return null;
              },
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 20.0), // Spacer
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(right:20.0,left: 20.0),
            child: Expanded(
              child: ElevatedButton(
                onPressed: () {
                  print("button pressed");
                  generateStory(topic.text);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9F7BFF),
                ),
                child: Text(
                  AppLocalizations.of(context).translate('generate_story_button') ??
                      'Generate Story',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: listeDesImages(),
          ),
        ),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Center(
              child: Text(
                "Stories around the world",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 35,
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: FutureBuilder<List<Story>>(
              future: getSharedStories(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No shared stories found.');
                } else {
                  return Animate(
                    child: Column(
                      children: snapshot.data!.map((story) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: MyStoryContainer(
                            story:story,
                          ),
                        );
                      }).toList(),
                    ),
                  ) .fade(duration: 500.ms)
  .scale(delay: 500.ms) ;
                }
              },
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const sharedStories(),
                  ),
                );
                print("button pressed");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9F7BFF),
              ),
              child: const Text(
                "Discover More",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
                SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: () {
                  handleLogout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9F7BFF),
              ),
              child: const Text(
                "logout",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  
        bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label:
            AppLocalizations.of(context).translate('home_label') ?? 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label:'Stories',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label:
            AppLocalizations.of(context).translate('profile_label') ??
                'Profile',
          ),

          BottomNavigationBarItem(
            icon: const Icon(Icons.menu_book),
            label:
            AppLocalizations.of(context).translate('stories_label') ??
                'My Stories',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Color.fromARGB(255, 63, 23, 121),
        onTap: (index) {
          switch (index) {
            case 0:
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const sharedStories(),
                ),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Profile(),
                ),
              );

              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyStories(),
                      
                ),
              );
              break;
          }
        },
      ),
  );
  }
}

  class MyImage extends StatelessWidget {
  final String imageUrl;

  const MyImage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Image.asset(
        imageUrl,
        width: 150,
        height: 350,
        fit: BoxFit.cover,
      ),
    );
  }
}