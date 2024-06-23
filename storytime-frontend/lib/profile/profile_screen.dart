import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


import '../models/user_model.dart';
import 'profile_container.dart';
import '../services/shared_preferences.dart';
import '../services/user_service.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}
  
class _ProfileState extends State<Profile> {
  late String userId;
  late Future<User> user;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await SharedPrefs.getUserInfo().then((userInfo) {
      setState(() {
        userId = userInfo['userId'] ?? '';
        print("id : $userId");
      });
    });
    user = UserService().getUserbyId(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:  Color(0xff006df1),
      ),
      body: FutureBuilder<User>(
        future: user,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SpinKitDualRing(color: Colors.blue,),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            User currentUser = snapshot.data!;
            return ProfileContainer( user: currentUser);
          }
        },
      ),
    );
  }
}
