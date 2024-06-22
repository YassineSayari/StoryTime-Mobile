import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:storytime/theme.dart';
import 'authentication_helper.dart';
import '../languages/app_localizations.dart';
import '../languages/language_provider.dart';
import 'login.dart';
import '../databasehelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../homePage.dart';

class Subscribe extends StatefulWidget {
  const Subscribe({Key? key, required this.controller}) : super(key: key);
  final PageController controller;

  @override
  State<Subscribe> createState() => SubscribeState();
}

class SubscribeState extends State<Subscribe> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController mail = TextEditingController();
  final TextEditingController prenom = TextEditingController();
  final TextEditingController nom = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController passwordconf = TextEditingController();

  LanguageProvider languageProvider = LanguageProvider();

  @override
  void initState() {
    super.initState();

    // Load the saved language
    languageProvider.loadSavedLanguage(context);
  }

  final DatabaseHelper databaseHelper = DatabaseHelper.instance;

  Future<UserCredential?> signInWithGoogle() async {

    showDialog(context: context,
      builder: (context){
        return Center(child: CircularProgressIndicator());
      },
    );


    UserCredential? userCredential = await AuthenticationHelper.signInWithGoogle();


    if (userCredential != null) {
      String userEmail = userCredential.user?.email ?? "";
      print("signed Up with email: $userEmail");

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => homePage(controller: widget.controller, userEmail: userEmail),
        ),
      );
    }
  }

  bool log = false;
  bool mdp = false;

  void verifier() async {
    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: mail.text,
        password: password.text,
      );

      if (userCredential.user != null && password.text == passwordconf.text) {
        log = true;
        mdp = true;

        await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
          'email': mail.text,
          'firstName': prenom.text,
          'lastName': nom.text,
          'password':password.text,
        });
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Login(controller: widget.controller, appLocalizationDelegate: AppLocalizations.of(context),)),
        );
      }
    } on FirebaseAuthException catch (e) {
      // Handle registration errors
      if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      } else {
        print('Error: ${e.message}');
      }
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
                              controller: prenom,
                              keyboardType: TextInputType.text,
                              style: TextInputDecorations.textStyle,
                                 decoration: TextInputDecorations.customInputDecoration(
                                 labelText: AppLocalizations.of(context).translate('first_name_label') ?? 'First Name',
                                 hintText: AppLocalizations.of(context).translate('first_name_label') ?? 'First Name',
                                 ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your first name';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16),
                            TextFormField(
                              controller: nom,
                              keyboardType: TextInputType.text,
                              style: TextInputDecorations.textStyle,
                                 decoration: TextInputDecorations.customInputDecoration(
                                 labelText: AppLocalizations.of(context).translate('last_name_label') ?? 'Last Name',
                                 hintText: AppLocalizations.of(context).translate('last_name_label') ?? 'Last Name',
                                 ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your last name';
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
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    verifier();
                                    if (log && mdp) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => Login(controller: widget.controller, appLocalizationDelegate: AppLocalizations.of(context),)),
                                      );
                                    }
                                  }
                                },
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
                          UserCredential? userCredential = await signInWithGoogle();
                        
                          if (userCredential != null) {
                            String userEmail = userCredential.user?.email ?? "";
                            print("signed Up with email: $userEmail");
                          }
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
