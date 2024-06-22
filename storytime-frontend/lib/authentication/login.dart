import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storytime/theme.dart';
import '../forgotpassword.dart';
import '../homePage.dart';
import '../languages/app_localizations.dart';
import '../languages/language_provider.dart';
import 'subscribe.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'authentication_helper.dart';
import '../databasehelper.dart';
import 'createprofile.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Login extends StatefulWidget {
  const Login({Key? key, required this.controller, required this.appLocalizationDelegate}) : super(key: key);
  final PageController controller;
  final AppLocalizations appLocalizationDelegate;

  @override
  State<Login> createState() => LoginState();
}

class LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController mail = TextEditingController();
  final TextEditingController password = TextEditingController();

  LanguageProvider languageProvider = LanguageProvider();
  String selectedLanguage = 'Language : ';

  Map<String, String> languageNames = {
    'en': 'English',
    'fr':'Français',
    'es': 'Español',
    'de': 'Deutsch',
    'ar': 'العربية',
  };

  @override
  void initState() {
    super.initState();

    // Load the saved language
    languageProvider.loadSavedLanguage(context);
  }

  Future<UserCredential?> signInWithGoogle() async {
    
    showDialog(context: context,
        builder: (context){
          return Center(child: SpinKitSpinningLines(color: Colors.blueAccent));
        },
    );


    UserCredential? userCredential = await AuthenticationHelper.signInWithGoogle();

    if (userCredential != null) {
      String userEmail = userCredential.user?.email ?? "";
      print("signed Up with email: $userEmail");

      bool isRegistered = await DatabaseHelper.instance.isUserRegistered(userEmail);

      if (isRegistered) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => homePage(controller: widget.controller, userEmail: userEmail),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreateProfile(
              controller: widget.controller,
              userEmail: userEmail,
            ),
          ),
        );
      }
    }
  }

  bool log = false;
  bool mdp = false;
  String email = "";
  late bool obscurePassword=true;


    void saveToPrefsIfExists(UserCredential userCredential) async {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .get();
        if (userDoc.exists) {
          Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
          print("User is found::::::::::Saving to Prefs:::::::::::::::::::");

          // Save user info in shared preferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('email', userData['email']);
          prefs.setString('firstName', userData['firstName']);
          prefs.setString('lastName', userData['lastName']);
          prefs.setString('image', userData['image']?? ' ');
        }
        else{
          print("::::::::::::No user found::::::::::");
        }

    }

  void verifier() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: mail.text,
        password: password.text,
      );

      if (userCredential.user != null) {
        email = userCredential.user!.email!;
        setState(() {
          log = true;
          mdp = true;
        });
        saveToPrefsIfExists(userCredential);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => homePage(controller: widget.controller, userEmail: email),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      } else {
        print('Error: ${e.message}');
      }
    }
  }

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        //  decoration: BoxDecoration(
        // image: DecorationImage(
        //   image: AssetImage('assets/images/backgroundlogin.jpg'),
        //   fit: BoxFit.cover,
        // ),
        //  ),
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: SizedBox(
                          width:110,
                          child: DropdownButton<String>(
                            value: selectedLanguage,
                            items: <String>[
                              'Language : ',
                              'en',
                              'fr',
                              'es',
                              'de',
                              'ar'
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value == 'Language : '
                                    ? value
                                    : languageNames[value] ?? value),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              if (value != null) {
                                setState(() {
                                  selectedLanguage = value;
                                  Provider.of<LanguageProvider>(context, listen: false)
                                      .changeLanguage(context, Locale(value));
                                });
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Email",
                            style: TextInputDecorations.textFieldLabelStyle,
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            height: 70,
                            child: TextFormField(
                              controller: mail,
                              keyboardType: TextInputType.emailAddress,
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
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Password",
                            style: TextInputDecorations.textFieldLabelStyle,
                          ),
                          const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          height: 70,
          child: TextFormField(
            controller: password,
            keyboardType: TextInputType.text,
            obscureText: obscurePassword,
            style: TextInputDecorations.textStyle,
            decoration: InputDecoration(
        labelText: AppLocalizations.of(context)
            .translate('password_label') ??
            'Password',
        hintText: AppLocalizations.of(context)
            .translate('password_label') ??
            'Password',
        suffixIcon: IconButton(
          icon: Icon(
            obscurePassword
                ? Icons.visibility
                : Icons.visibility_off,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              obscurePassword = !obscurePassword;
            });
          },
        ),
        labelStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 18,
        ),
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        filled: true,
        fillColor: Color.fromARGB(122, 238, 238, 238), // Gray background when not enabled
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(
            width: 1,
            color: Colors.grey,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(
            width: 3,
            color: Colors.blue,
          ),
        ),
        disabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(
            width: 1,
            color: Colors.grey,
          ),
        ),
            ),
            validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a password';
        }
        return null;
            },
          ),
        ),
        
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              verifier();
                            }
                          },
                          style: AppButtonStyles.submitButtonStyle,
                          child: Text(
                            AppLocalizations.of(context).translate('login_button') ?? 'Login',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return ForgotPassword();
                                  },
                                ),
                              );
                            },
                            child: Text(
                              AppLocalizations.of(context).translate('forgot_pw') ?? 'Forgot Password',
                              style: TextStyle(
                                color: const Color.fromARGB(255, 27, 49, 161),
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
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
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                           Text(
                             AppLocalizations.of(context).translate('no_account_question') ?? "Don't have an account ?",
                            style: const TextStyle(
                              color: Color.fromARGB(255, 193, 147, 147),
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      Subscribe(controller: widget.controller),
                                ),
                              );
                            },
                            child: Text(
                               AppLocalizations.of(context).translate('sub_button') ?? 'Subscribe !',
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}