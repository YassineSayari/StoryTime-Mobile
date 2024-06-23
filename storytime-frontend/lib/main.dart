import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storytime/homePage.dart';
import 'package:storytime/profile/profile_screen.dart';
import 'languages/app_localizations.dart';
import 'authentication/login.dart';
import 'languages/language_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LanguageProvider()),
        // Add other providers if needed
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final PageController controller = PageController(initialPage: 0);
late Widget current_page = Container();


  @override
  void initState() {
    super.initState();
    initUser();
  }

  Future<void> initUser() async {
  final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
  var id = sharedPrefs.getString('userId');
  var role = sharedPrefs.getString('userRole');

  print('Role: $role, ID: $id');

  if (id != null) {
    switch (role) {
      case 'Admin':
        print('redirecting to admin page');
        setState(() {
           current_page = homePage(controller: controller,);
        });
        break;
      case 'User':
        print('redirecting to user page');
 setState(() {
           current_page = homePage(controller: controller,);
        });
        break;        
      default:
        print('Unknown role, redirecting to sign in');
        setState(() {
           current_page = Login(controller: controller,);
        });
        break;
    }
  } else {
    print('redirecting to sign in');
    setState(() {
           current_page = Login(controller: controller,);
        });
  }
}


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<LanguageProvider>(context, listen: false).loadSavedLanguage(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return StreamBuilder<Locale>(
            stream: Provider.of<LanguageProvider>(context).appLocale,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final appLocale = snapshot.data;
                final appLocalizationDelegate = AppLocalizations.of(context)!;

                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: appLocalizationDelegate.appTitle,
                  home: current_page,
                   routes:{
                    '/login': (context)=>Login(controller: controller),
                    '/home':(context)=> homePage(controller: controller),
                    '/profile':(context) =>const Profile(),
                  },
                  locale: appLocale,
                  localizationsDelegates: [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  supportedLocales: [const Locale('en', ''), const Locale('fr', ''), const Locale('es', ''), const Locale('de', ''), const Locale('ar', '')],
                );
              } else {
                return MaterialApp(
                  home: Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
              }
            },
          );
        } else {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
      },
    );
  }
}

