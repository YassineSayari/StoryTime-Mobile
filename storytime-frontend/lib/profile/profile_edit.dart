import 'package:flutter/material.dart';
import 'package:storytime/const.dart';
import 'package:storytime/models/user_model.dart';
import 'package:storytime/services/user_service.dart';
import 'package:storytime/theme.dart';

import 'edit_profile_photo.dart';


class EditProfile extends StatefulWidget {
  final User user;
  const EditProfile({super.key, required this.user});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  UserService userService=UserService();

  
    final TextEditingController nameController=TextEditingController();
    final TextEditingController phoneController=TextEditingController();
    final TextEditingController countryController=TextEditingController();
    final TextEditingController addressController=TextEditingController();
    final TextEditingController emailController=TextEditingController();

      @override
  void initState() {
    nameController.text = widget.user.fullName;
    countryController.text = widget.user.fullName;
    emailController.text = widget.user.email;


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(
        title: Text('Edit Profile',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 45,fontFamily: AppTheme.fontName),),
        centerTitle: true,
      ),

      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 16,vertical:8),
        child: ListView(
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Profile photo",style: TextStyle(fontSize: 30,fontFamily: AppTheme.fontName,fontWeight: FontWeight.bold),
                    ),

                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: (){
                            print("change pressed");
                             showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return EditProfileImageDialog(idUser: widget.user.id);
                                  },
                                );
                                },
                                child: Text("Change",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 12.5,fontFamily: AppTheme.fontName),),
                                style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF9F7BFF),
                                  shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                          ),
                                        ),
                                      ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: (){},
             child: Text("Remove",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 12.5,fontFamily: AppTheme.fontName),),
             style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 172, 19, 19),
                              shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
                      ],
                    ),
                    
                  ],
                ),
                Spacer(),
                    Container(
                      width: 100,
                      height: 100,
                      padding: EdgeInsets.symmetric(horizontal: 8,vertical: 8),
                    decoration:    BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                              '$imageUrl/${widget.user.image}')
                              ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 20),
            TextFormField(
             controller: nameController,
              keyboardType: TextInputType.text,
              style: TextInputDecorations.textStyle,
              decoration: TextInputDecorations.customInputDecoration(labelText: 'Full Name'),
                      validator: (value) {
                             if (value == null || value.isEmpty) {
                               return 'Please enter a full name';
                              }
                               return null;
                             },
            ),

            SizedBox(height: 10),  

            TextFormField(
             controller: emailController,
              keyboardType: TextInputType.text,
              style: TextInputDecorations.textStyle,
              decoration: TextInputDecorations.customInputDecoration(labelText: 'City'),
                      validator: (value) {
                             if (value == null || value.isEmpty) {
                               return 'Please enter a city';
                              }
                               return null;
                             },
            ),

            SizedBox(height: 10),

            TextFormField(
             controller: phoneController,
              keyboardType: TextInputType.number,
              style: TextInputDecorations.textStyle,
              decoration: TextInputDecorations.customInputDecoration(labelText: 'Phone'),
                      validator: (value) {
                             if (value == null || value.isEmpty) {
                               return 'Please enter a phone number';
                              }
                               return null;
                             },
            ),

            SizedBox(height: 10),

            TextFormField(
             controller: countryController,
              keyboardType: TextInputType.text,
              style: TextInputDecorations.textStyle,
              decoration: TextInputDecorations.customInputDecoration(labelText: 'Country'),
                      validator: (value) {
                             if (value == null || value.isEmpty) {
                               return 'Please enter a country';
                              }
                               return null;
                             },
            ),

            SizedBox(height: 10),
            

            TextFormField(
             controller: addressController,
              keyboardType: TextInputType.text,
              style: TextInputDecorations.textStyle,
              decoration: TextInputDecorations.customInputDecoration(labelText: 'Address'),
                      validator: (value) {
                             if (value == null || value.isEmpty) {
                               return 'Please enter an adress';
                              }
                               return null;
                             },
            ),

            SizedBox(height: 10),

            ElevatedButton(onPressed: (){
            //  updateEmployee();
            },
             child: Text("Save",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 25,fontFamily: AppTheme.fontName, ),),
             style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF9F7BFF),
                              shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                  ),
                   minimumSize: Size(double.infinity, 60),
                ),
                          
             ),
          ],
        ),
      ),
    );
  }

    // Future<void> updateEmployee() async {

    //   String updatedAddress = '${countryController.text},${cityController.text},${addressController.text}';

    //   try {
    //     Map<String, dynamic> updatedData = {
    //       'fullName': nameController.text,
    //       'phone': phoneController.text,
    //       'address': updatedAddress,

    //     };

    //     print("updating employee");
    //     await userService.updateUser(widget.user.id, updatedData);
    //     Navigator.of(context).pushReplacementNamed('/profile');
    //     // ScaffoldMessenger.of(context).showSnackBar(
    //     //   SnackBar(
    //     //     content: SuccessSnackBar(message: "Profile updated successfully!"),
    //     //     duration: Duration(seconds: 2),
    //     //     behavior: SnackBarBehavior.floating,
    //     //     backgroundColor: Colors.transparent,
    //     //     elevation: 0,
    //     //   ),
    //     // );
    //   } catch (error) {
    //     print('Error updating employee: $error');
    //     // ScaffoldMessenger.of(context).showSnackBar(
    //     //          SnackBar(
    //     //     content: FailSnackBar(message: "Failed to update profile, please try again"),
    //     //     duration: Duration(seconds: 2),
    //     //     behavior: SnackBarBehavior.floating,
    //     //     backgroundColor: Colors.transparent,
    //     //     elevation: 0,
    //     //   ),
    //     // ); 
    //   }
    // }
  }
