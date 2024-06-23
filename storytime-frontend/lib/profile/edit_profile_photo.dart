import 'package:flutter/material.dart';

import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:storytime/services/shared_preferences.dart';
import 'package:storytime/services/user_service.dart';
import 'package:storytime/theme.dart';

class EditProfileImageDialog extends StatefulWidget {
  final String idUser;

  EditProfileImageDialog({required this.idUser});

  @override
  _EditProfileImageDialogState createState() => _EditProfileImageDialogState();
}

class _EditProfileImageDialogState extends State<EditProfileImageDialog> {
  File? selectedImage;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (selectedImage != null) {
      String? authToken = await SharedPrefs.getAuthToken();
      await UserService().uploadImageUser(widget.idUser, selectedImage!, authToken!);

    //       ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: SuccessSnackBar(message: "Image changed successfully!"),
    //     duration: Duration(seconds: 2),
    //     behavior: SnackBarBehavior.floating,
    //     backgroundColor: Colors.transparent,
    //     elevation: 0,
    //   ),
    // );
      Navigator.of(context).pushReplacementNamed("/profile"); 
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select an image'),
        ),
      );
    }
  }

 @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Display selected image preview
            if (selectedImage != null)
              Container(
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: FileImage(selectedImage!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            SizedBox(height: 12),
            Center(
              child: Text(
                'Edit Profile Image',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: AppTheme.fontName,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Import New Photo',
              style:TextStyle(fontFamily: AppTheme.fontName,fontSize: 15,fontWeight: FontWeight.w500),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                primary: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _uploadImage,
                    child: Text('Save New Image',
                     style:TextStyle(fontFamily: AppTheme.fontName,fontSize: 15,fontWeight: FontWeight.w500,color: Colors.white),
                     ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      primary: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 5),
                Expanded(
                  child: TextButton(
                                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                                },
                                child: Text('Cancel',
                                 style:TextStyle(fontFamily: AppTheme.fontName,fontSize: 15,fontWeight: FontWeight.w500,color: Colors.white),
                                 ),
                                 style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      primary: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                              ),
                ),
              ],
            ),
            SizedBox(height: 12),
            
          ],
        ),
      ),
    );
  }
}