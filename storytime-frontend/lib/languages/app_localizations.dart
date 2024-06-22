import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(Locale('en'));
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
  _AppLocalizationsDelegate();

  Map<String, String> _localizedStrings = {
    'app_title': 'StoryTime',
    'welcome_message': 'Welcome to StoryTime!',
    // Add more translations as needed
    'email_label': 'Email',
    'password_label': 'Password',
    'login_button': 'Login',
    'no_account_question': "Don't have an account? ",
    'subscribe_label': 'Subscribe!',
    'first_name_label':'First Name',
    'last_name_label':'Last Name',
    'pw_conf_label':'Confirm your password',
    'sub_button':' Subscribe',
    'has_account_question': "Already have an account? ",
    'login_label': 'Login !',
    'home_label':'Home',
    'profile_label':'Profile',
    'stories_label':'My Stories',
    'generate_story_button':'Generate Story',
    'story_prompt':'Enter your story topic',
    'edit_button':'Edit',
    'forgot_pw':'Forgot Password ',

  };

  String get appTitle {
    return _localizedStrings['app_title'] ?? 'StoryTime';
  }

  String get welcomeMessage {
    return _localizedStrings['welcome_message'] ?? 'Welcome to StoryTime!';
  }

  // Add more getter methods for other translations

  String? translate(String key) {
    return _localizedStrings[key];
  }

  Future<void> load() async {
    // Load translations from an external source, e.g., a JSON file
    Map<String,
        String> loadedTranslations = await loadTranslationsFromExternalSource();

    // Update the localized strings with the loaded translations
    _localizedStrings = loadedTranslations;


    print('Changing language to: ${locale.languageCode}');
    print('Translations loaded: $_localizedStrings');
    print('Current Locale: ${locale.languageCode}');
  }

  Future<Map<String, String>> loadTranslationsFromExternalSource() async {
    switch (locale.languageCode) {
      case 'es':
      // Load Spanish translations
        return {
          'app_title': 'StoryTime',
          'welcome_message': '¡Bienvenido a StoryTime!',

          'email_label': 'Mail',
          'password_label': 'Contraseña',
          'login_button': 'Acceso',
          'no_account_question': "No tienes una cuenta? ",
          'subscribe_label': 'Suscribir!',
          'first_name_label': 'Nombre',
          'last_name_label': 'Apellido',
          'pw_conf_label': 'Confirma tu contraseña',
          'sub_button': 'Suscribirse',
          'has_account_question': '¿Ya tienes una cuenta? ',
          'login_label': '¡Iniciar sesión!',
          'home_label':'página principal',
          'profile_label': 'Perfil',
          'stories_label': 'Mis Historias',
          'generate_story_button': 'Generar Historia',
          'story_prompt': 'Ingresa el tema de tu historia',
          'edit_button':'Editar',
          'forgot_pw':'¿Olvidaste tu contraseña',


        };
      case 'de':
        return {
          'app_title': 'StoryTime',
          'welcome_message': 'Willkommen bei StoryTime!',
          'email_label': 'E-Mail',
          'password_label': 'Passwort',
          'login_button': 'Anmelden',
          'no_account_question': 'Sie haben noch kein Konto? ',
          'subscribe_label': 'Abonnieren!',
          'first_name_label':'Vorname',
          'first_name_label': 'Vorname',
          'last_name_label': 'Name',
          'pw_conf_label': 'Bestätige dein Passwort',
          'sub_button': 'Abonnieren',
          'has_account_question': 'Hast du bereits ein Konto? ',
          'login_label': 'Einloggen!',
          'home_label': 'Startseite',
          'profile_label': 'Profil',
          'stories_label': 'Meine Geschichten',
          'generate_story_button': 'Geschichte Generieren',
          'story_prompt': 'Gib das Thema deiner Geschichte ein',
          'edit_button':'Bearbeiten',
          'forgot_pw':'Passwort vergessen',

        };

      case 'ar':
        return {
          'app_title': 'StoryTime',
          'welcome_message': 'مرحبًا بك في ستوري تايم!',
          'email_label': 'البريد الإلكتروني',
          'password_label': 'كلمة المرور',
          'login_button': 'تسجيل الدخول',
          'no_account_question': 'ليس لديك حساب؟ ',
          'subscribe_label': 'الاشتراك!',
          'first_name_label': 'الاسم ',
          'last_name_label': ' اللقب ',
          'pw_conf_label': 'تأكيد كلمة المرور',
          'sub_button': 'الاشتراك',
          'has_account_question': 'هل لديك حساب بالفعل؟ ',
          'login_label': 'تسجيل الدخول!',
          'home_label': ' الصفحةالرئيسية',
          'profile_label': 'الصفحة الشخصية',
          'stories_label': 'قصصي',
          'generate_story_button': 'إنشاء قصة',
          'story_prompt': 'أدخل موضوع قصتك',
          'edit_button':'تعديل',
          'forgot_pw':'نسيت كلمة المرور ',
        };
      case 'fr':
        return{
        'email_label': 'E-mail',
        'password_label': 'Mot de passe',
        'login_button': 'Connexion',
        'no_account_question': 'Vous n\'avez pas de compte ? ',
        'subscribe_label': 'S\'abonner !',
        'first_name_label': 'Prénom',
        'last_name_label': 'Nom de famille',
        'pw_conf_label': 'Confirmez votre mot de passe',
        'sub_button': 'S\'abonner',
        'has_account_question': 'Vous avez déjà un compte ? ',
        'login_label': 'Connexion !',
        'home_label': 'Accueil',
        'profile_label': 'Profil',
        'stories_label': 'Mes histoires',
        'generate_story_button': 'Générer une histoire',
        'story_prompt': 'Entrez le sujet de votre histoire',
        'edit_button': 'Éditer',
        'forgot_pw': 'Mot de passe oublié ',

        };
      default:

        return {
          'app_title': 'StoryTime',
          'welcome_message': 'Welcome to StoryTime!',
        };
    }
  }
}
  class _AppLocalizationsDelegate
  extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
  return ['en','fr','es','de','ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
  AppLocalizations localizations = AppLocalizations(locale);
  await localizations.load();
  return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
  }

