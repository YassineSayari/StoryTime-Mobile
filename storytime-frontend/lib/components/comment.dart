import 'package:flutter/material.dart';
import 'package:storytime/components/report_button.dart';

class Comment extends StatelessWidget {
  final String text;
  final String user;
  final String time;
  final VoidCallback? onTapReport;


  const Comment({
    Key? key,
    required this.text,
    required this.user,
    required this.time,
    required this.onTapReport,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(3),
      ),
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(15),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: TextStyle(fontSize: 25),
                ),
                SizedBox(height: 11),
                Column(
                  children: [
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        user,
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                    ),
                    Text(
                      '.',
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        time,
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            ReportButton(
              onTap:
                onTapReport,
            ),
          ],
        ),
      ),
    );
  }
}
