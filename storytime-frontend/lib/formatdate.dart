import 'package:cloud_firestore/cloud_firestore.dart';

String formatDate(Timestamp timestamp)
{
  DateTime dateTime=timestamp.toDate();
  String y=dateTime.year.toString();
  String m=dateTime.month.toString();
  String d=dateTime.day.toString();

  String formatedDate= "$d/$m/$y";

  return formatedDate;
}