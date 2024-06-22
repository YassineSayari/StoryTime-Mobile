import 'package:flutter/material.dart';
import '../databasehelper.dart';
import 'package:storytime/User.dart';
import 'profile_service.dart';

class EditProfilePage extends StatefulWidget {
  final User user;

  EditProfilePage({required this.user});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  TextEditingController _oldPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  late ProfileService _profileBackend;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.user.firstName);
    _lastNameController = TextEditingController(text: widget.user.lastName);
    _emailController = TextEditingController(text: widget.user.email);
    _oldPasswordController.text = "";
    _profileBackend = ProfileService(DatabaseHelper.instance);
  }

  void verifyAndUpdateProfile() async {
    try {
      bool success = await _profileBackend.verifyAndUpdateProfile(
        widget.user,
        _oldPasswordController.text,
        _newPasswordController.text,
        _confirmPasswordController.text,
      );

      if (success) {
        Navigator.pop(context);
        _showAlertDialog("Updated successfully", "Success");
      }
    } catch (error) {
      _showAlertDialog(error.toString(), "Error");
    }
  }

  void _showAlertDialog(String message, String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile', style: TextStyle(fontSize: 30)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  hintStyle: const TextStyle(
                    fontSize: 15.0,
                    color: Color(0xffA9A9A9),
                    fontWeight: FontWeight.w500,
                  ),
                  contentPadding: const EdgeInsets.all(15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  hintStyle: const TextStyle(
                    fontSize: 15.0,
                    color: Color(0xffA9A9A9),
                    fontWeight: FontWeight.w500,
                  ),
                  contentPadding: const EdgeInsets.all(15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                enabled: false,
                decoration: InputDecoration(
                  hintStyle: const TextStyle(
                    fontSize: 15.0,
                    color: Color(0xffA9A9A9),
                    fontWeight: FontWeight.w500,
                  ),
                  contentPadding: const EdgeInsets.all(15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _oldPasswordController,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: 'Old Password',
                  hintStyle: const TextStyle(
                    fontSize: 15.0,
                    color: Color(0xffA9A9A9),
                    fontWeight: FontWeight.w500,
                  ),
                  contentPadding: const EdgeInsets.all(15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Enter New Password',
                  hintStyle: const TextStyle(
                    fontSize: 15.0,
                    color: Color(0xffA9A9A9),
                    fontWeight: FontWeight.w500,
                  ),
                  contentPadding: const EdgeInsets.all(15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirm New Password',
                  hintStyle: const TextStyle(
                    fontSize: 15.0,
                    color: Color(0xffA9A9A9),
                    fontWeight: FontWeight.w500,
                  ),
                  contentPadding: const EdgeInsets.all(15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: verifyAndUpdateProfile,
                child: Text(
                  'Save',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20), // Added space for better layout
            ],
          ),
        ),
      ),
    );
  }
}
