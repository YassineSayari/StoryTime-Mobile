import 'package:flutter/material.dart';
import 'languages/app_localizations.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  final _emailController =TextEditingController();

  Future sendPasswordReset() async
  {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      backgroundColor: Colors.blueGrey,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Enter Your Email : '),

      Padding(
        padding: const EdgeInsets.symmetric(horizontal:25.0),
        child: TextField(
          controller: _emailController,
          keyboardType: TextInputType.text,
          style: TextStyle(
            color: Color(0xFF000000),
            fontSize: 27,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.translate('email_label') ?? 'Email',
            labelStyle: TextStyle(
              color: Color(0xFF7743DB),
              fontSize: 15,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                width: 3,
                color: Colors.deepPurple,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                width: 3,
                color: Colors.white,
              ),
            ),
            hintText: 'Email',
            fillColor: Colors.grey,
            filled: true,
          ),
        ),
      ),
          MaterialButton(
              onPressed: sendPasswordReset,
              child: Text('Reset Password '),
              color: Colors.blueGrey,
          ),
        ],
      ),

    );
  }
}
