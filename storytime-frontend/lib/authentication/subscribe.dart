import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:storytime/const.dart';
import 'package:storytime/theme.dart';
import '../languages/app_localizations.dart';
import '../languages/language_provider.dart';
import 'login.dart';
import 'package:http/http.dart' as http;

class Subscribe extends StatefulWidget {
  const Subscribe({Key? key, required this.controller}) : super(key: key);
  final PageController controller;

  @override
  State<Subscribe> createState() => SubscribeState();
}

class SubscribeState extends State<Subscribe> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController mail = TextEditingController();
  final TextEditingController fullname = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController passwordconf = TextEditingController();

  LanguageProvider languageProvider = LanguageProvider();

  @override
  void initState() {
    super.initState();

    // Load the saved language
    languageProvider.loadSavedLanguage(context);
  }

  Future<void> _handleSignUp() async {
  print("SIGNING UPPPPPPPPPP");

  var request = http.MultipartRequest(
    'POST',
    Uri.parse('$baseUrl/api/v1/users/signup'), 
  );

  request.fields['fullName'] = fullname.text;
  request.fields['email'] = mail.text;
  request.fields['password'] = password.text;
  request.fields['roles[]'] = 'User';


  print("sending data:::::::::request::::::$request");
  print("request fields:::: ${request.fields},,,,,,,,, request files:::: ${request.files}");

  var response = await request.send();
  print("response::::$response");

  if (response.statusCode == 200) {
    print("Signup successful");
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: SuccessSnackBar(message: "Signup successfull , waiting for admin confirmation!"),
    //     duration: Duration(seconds: 2),
    //     behavior: SnackBarBehavior.floating,
    //     backgroundColor: Colors.transparent,
    //     elevation: 0,
    //   ),
    // );
    Navigator.of(context).pop();
  } else {
    // Handle error
    print("Signup failed");
  }
}







  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              // Image.asset(
              //   "assets/images/backgroundlogin.jpg",
              //   fit: BoxFit.cover,
              // ),
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height:70),
                        
                            TextFormField(
                              controller: fullname,
                              keyboardType: TextInputType.text,
                              style: TextInputDecorations.textStyle,
                                 decoration: TextInputDecorations.customInputDecoration(
                                 labelText: AppLocalizations.of(context).translate('last_name_label') ?? 'Name',
                                 hintText: AppLocalizations.of(context).translate('last_name_label') ?? 'Name',
                                 ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16),
                            TextFormField(
                              controller: mail,
                              keyboardType: TextInputType.text,
                              style: TextInputDecorations.textStyle,
                                 decoration: TextInputDecorations.customInputDecoration(
                                 labelText: AppLocalizations.of(context).translate('email_label') ?? 'Email',
                                 hintText: AppLocalizations.of(context).translate('email_label') ?? 'Your Email',
                                 ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter an email';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16),
                            TextFormField(
                              controller: password,
                              keyboardType: TextInputType.text,
                              obscureText: true,
                              style: TextInputDecorations.textStyle,
                                 decoration: TextInputDecorations.customInputDecoration(
                                 labelText: AppLocalizations.of(context).translate('password_label') ?? 'Password',
                                 hintText: AppLocalizations.of(context).translate('password_label') ?? 'Password',
                                 ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a password';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16),
                            TextFormField(
                              controller: passwordconf,
                              keyboardType: TextInputType.text,
                              obscureText: true,
                              style: TextInputDecorations.textStyle,
                                 decoration: TextInputDecorations.customInputDecoration(
                                 labelText: AppLocalizations.of(context).translate('pw_conf_label') ?? 'Confirm Password',
                                 hintText: AppLocalizations.of(context).translate('pw_conf_label') ?? 'Confirm Password',
                                 ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Password does not match';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: ElevatedButton(
                                onPressed:  
                                 
                                   _handleSignUp,
                                  
                                
                                style: AppButtonStyles.submitButtonStyle,
                                child: Text(
                                  AppLocalizations.of(context).translate('sub_button') ?? 'Subscribe',
                                  style: TextStyle(color: Colors.white, fontSize: 20),
                                ),
                              ),
                            ),
                            SizedBox(height: 15),
                            GestureDetector(
                        onTap: () async {
                          // UserCredential? userCredential = await signInWithGoogle();
                        
                          // if (userCredential != null) {
                          //   String userEmail = userCredential.user?.email ?? "";
                          //   print("signed Up with email: $userEmail");
                          // }
                        },
                        child: SvgPicture.asset(
                          'assets/images/signin_with_google.svg',
                          fit: BoxFit.fill,
                          height: 70,
                        ),
                      ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                 Text(
                                  AppLocalizations.of(context).translate('has_account_question') ?? "Already have an account? ",
                                  style: TextStyle(
                              color: Color.fromARGB(255, 193, 147, 147),
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Login(controller: widget.controller,appLocalizationDelegate: AppLocalizations.of(context),)),
                                    );
                                  },
                                  child:  Text(
                                    AppLocalizations.of(context).translate('login_label') ?? "Login ! ",
                                    style: TextStyle(
                                color: const Color.fromARGB(255, 27, 49, 161),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
