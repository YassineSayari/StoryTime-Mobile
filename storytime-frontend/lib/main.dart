import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:storytime/homePage.dart';
import 'languages/app_localizations.dart';
import 'authentication/login.dart';
import 'languages/language_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyDRjcOG-UtA5pPXXMqm1zz6mtLqU3IXlaM',
      appId: '1:82081837207:android:9dda6b3d277c2a99bcb9d2',
      messagingSenderId: '82081837207',
      projectId: 'story-time-f39d7',
    ),
  );

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

class MyApp extends StatelessWidget {
  final PageController controller = PageController(initialPage: 0);

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
                 // home: homePage(controller: controller, userEmail: "userEmail"),
                  home: Login(
                    controller: controller,
                    appLocalizationDelegate: appLocalizationDelegate,
                  ),
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


