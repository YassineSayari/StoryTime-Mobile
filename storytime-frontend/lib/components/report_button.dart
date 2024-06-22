import 'package:flutter/material.dart';

class ReportButton extends StatelessWidget {
  final void Function()? onTap;

  const ReportButton({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Call the onTap function
      child: Icon(
        Icons.report_gmailerrorred_rounded,
        color: Colors.red[600],
      ),
    );
  }
}