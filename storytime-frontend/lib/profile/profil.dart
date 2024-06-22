import 'dart:io';

import 'package:flutter/material.dart';
import 'profile_service.dart';
import '../databasehelper.dart';
import '../User.dart';
import 'editprofilepage.dart';
import '../languages/app_localizations.dart';

class Profile extends StatefulWidget {
  final String userEmail;

  Profile({required this.userEmail});

  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  late Future<User?> _userFuture;
  late ProfileService _profileBackend;
  late String _imagePath = 'assets/images/backgroundlogin.jpg';

  @override
  void initState() {
    super.initState();
    _profileBackend = ProfileService(DatabaseHelper()); // Initialize with your DatabaseHelper
    _userFuture = _profileBackend.getUserData(widget.userEmail);
    _profileBackend.loadImagePath((imagePath) { 
      setState(() {
        _imagePath = imagePath;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('profile_label') ?? 'Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<User?>(
          future: _userFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.cyan,
                  backgroundColor: Colors.blueGrey,
                ),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data == null) {
              return Text('User not found for email: ${widget.userEmail}');
            }

            User user = snapshot.data!;
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    _profileBackend.pickImage((imagePath) {
                      setState(() {
                        _imagePath = imagePath;
                      });
                    });
                  },
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                      border: Border.all(color: Colors.white, width: 1),
                      image: DecorationImage(
                        image: _imagePath.startsWith('assets')
                            ? AssetImage(_imagePath) as ImageProvider<Object>
                            : FileImage(File(_imagePath)) as ImageProvider<Object>,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${user.firstName} ${user.lastName}',
                  style: TextStyle(fontSize: 30, color: const Color.fromARGB(255, 106, 26, 26)),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.mail),
                    Text(
                      "Total Stories: ",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfilePage(user: user),
                        ),
                      );
                    },
                    child: Text(
                      AppLocalizations.of(context).translate('edit_button') ?? 'Edit',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: AppLocalizations.of(context)!.translate('home_label') ?? 'Home',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: AppLocalizations.of(context)!.translate('profile_label') ?? 'Profile',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.menu_book),
            label: AppLocalizations.of(context)!.translate('stories_label') ?? 'My Stories',
          ),
        ],
        currentIndex: 1,
        selectedItemColor: Colors.amber[800],
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pop(context);
              break;
            case 1:
              break;
            case 2:
              // Handle My Stories tab click
              break;
          }
        },
      ),
    );
  }
}
