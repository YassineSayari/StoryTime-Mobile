import 'package:flutter/material.dart';

class AppTheme {
  static const Color nearlyWhite = Color(0xFFFAFAFA);
  static const Color white = Color(0xFFFFFFFF);
  static const String fontName = 'Rubik';
}

class AppColors {
  static const Color primaryColor = Colors.blue;
  static const Color dialogBackgroundColor = Colors.white;
  static const Color buttonTextPrimary = Colors.blue;
  static const Color buttonTextSecondary = Colors.grey;
  static const Color drawerItemColor = Color(0xFFFAFAFA);
  static const Color defaultDrawerIconColor = Color.fromARGB(255, 57, 45, 45);
  static const Color selectedDrawerIconColor = Color(0xFFFAFAFA);
  static const Color selectedTileBackgroundColor = Color.fromARGB(255, 54, 44, 198);
}

class AppButtonStyles {
  static ButtonStyle submitButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: const Color.fromARGB(255, 27, 49, 161),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
  );

  static TextStyle submitButtonTextStyle = const TextStyle(
    color: Colors.white,
    fontSize: 30,
    fontFamily: AppTheme.fontName,
    fontWeight: FontWeight.w500,
  );
}

class TextInputDecorations {
  static InputDecoration customInputDecoration({
    required String labelText,
    String? hintText,
    Icon? prefixIcon,
  }) {
    return InputDecoration(
     
      labelStyle: const TextStyle(
        color: Colors.grey,
        fontSize: 18,
      ),
      hintText: hintText,
      hintStyle: const TextStyle(
        color: Colors.grey,
        fontSize: 16, 
        fontWeight: FontWeight.w500,
      ),
      prefixIcon: prefixIcon,
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
    );
  }


 static InputDecoration passwordInputDecoration({
    required String labelText,
    String? hintText,
    Icon? prefixIcon,
  }) {
    return InputDecoration(
      labelStyle: const TextStyle(
        color: Colors.grey,
        fontSize: 18,
      ),
      hintText: hintText,
      hintStyle: const TextStyle(
        color: Colors.grey,
        fontSize: 16, 
        fontWeight: FontWeight.w500,
      ),
      prefixIcon: prefixIcon,
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
    );
  }


  static const TextStyle textStyle = TextStyle(
    color: Color(0xFF000000),
    fontSize: 15,
    fontWeight: FontWeight.w500,
    fontFamily: AppTheme.fontName,
  );

  static const TextStyle textFieldLabelStyle = TextStyle(
    color: Color(0xFF000000),
    fontSize: 20,
    fontWeight: FontWeight.w500,
    fontFamily:AppTheme.fontName,
  );
}
