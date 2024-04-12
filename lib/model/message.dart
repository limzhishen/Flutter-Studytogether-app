import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String messageText;
  final String senderID;
  final Timestamp createdAt;

  Message({required this.messageText, required this.senderID, required this.createdAt});
}
