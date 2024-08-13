import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageType {
  Text,
  Image,
}

class Message {
  final String senderID;
  final String receiverID;
  final String messageID;
  final String message;
  final Timestamp timeStamp;
  final String type;
  final bool isDeleted;

  Message({
    required this.senderID,
    required this.receiverID,
    required this.messageID,
    required this.message,
    required this.timeStamp,
    required this.type,
    this.isDeleted = false,
  });

  // convert to map
  Map<String, dynamic> toMap() {
    return {
      "senderID": senderID,
      "receiverID": receiverID,
      "message": message,
      "messageID": messageID,
      "timeStamp": timeStamp,
      "type": type,
      "isDeleted": isDeleted
    };
  }
}
