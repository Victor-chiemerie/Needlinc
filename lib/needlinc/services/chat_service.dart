import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:needlinc/needlinc/shared-pages/chat-pages/message_format.dart';
import 'package:uuid/uuid.dart';

import '../backend/functions/get-user-data.dart';

const uuid = Uuid();

class ChatService {
  // get instance of fireStore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /**get user stream */
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection("users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        // go through each individual user
        final user = doc.data();

        // return user
        return user;
      }).toList();
    });
  }

  /**send messages to firebase */
  Future<void> sendMessage(
    String myUserId,
    otherUserId,
    myUserName,
    otherUserName,
    myProfilePicture,
    otherProfilePicture,
      myUserCategory,
    otherUserCategory,
    message,
    MessageType type,
  ) async {
    final Timestamp timeStamp = Timestamp.now();
    String messageID = uuid.v4();
    var _messageType = "";
    switch (type) {
      case MessageType.Text:
        _messageType = "text";
        break;
      case MessageType.Image:
        _messageType = "image";
        break;
      default:
    }

    // create a new message
    Message newMessage = Message(
      senderID: myUserId,
      receiverID: otherUserId,
      messageID: messageID,
      message: message,
      timeStamp: timeStamp,
      type: _messageType,
    );

    // construct chat room ID for the two users (sorted to ensure uniqueness)
    List<String> ids = [myUserId, otherUserId];
    ids.sort(); // sort the ids (this ensures chat room ID is the same for any 2 people)
    String chatRoomID = ids.join('_');

    try {
      // add new message to database
      await _firestore
          .collection("chats")
          .doc(chatRoomID)
          .collection("messages")
          .doc(messageID)
          .set(newMessage.toMap());

      // update last sent message to database
      await _firestore.collection("chats").doc(chatRoomID).set({
        "profilePictures": [myProfilePicture, otherProfilePicture],
        "userNames": [myUserName, otherUserName],
        "userTokens": ["", ""],
        "userIds": [myUserId, otherUserId],
        "messageId": "${chatRoomID}",
        "chatId": messageID,
        "userCategories": [myUserCategory, otherUserCategory],
        "text": newMessage.message
                .startsWith("https://firebasestorage.googleapis.com")
            ? "An Image was sent"
            : newMessage.message,
        "timeStamp": newMessage.timeStamp.millisecondsSinceEpoch,
        'dbTimeStamp': FieldValue.serverTimestamp(),
        "block": false
      });
    } catch (e) {
      print("Error sending message: $e");
    }
  }

  /**retrieve messages from firebase */
  Stream<QuerySnapshot> getMessages(String userID, otherUserID) {
    // construct a chat room ID for the 2 users
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');

    // return fetched chat
    return _firestore
        .collection("chats")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timeStamp", descending: true)
        .snapshots();
  }

  /**delete a message */
  Future<void> deleteChat(String myUserId, otherUserId, messageId) async {
    // construct chat room ID for the two users (sorted to ensure uniqueness)
    List<String> ids = [myUserId, otherUserId];
    ids.sort(); // sort the ids (this ensures chat room ID is the same for any 2 people)
    String chatRoomID = ids.join('_');

    try {
      // set deleted field to true
      await _firestore
          .collection("chats")
          .doc(chatRoomID)
          .collection("messages")
          .doc(messageId)
          .update({
        "isDeleted": true,
      });
    } catch (e) {
      print("Error sending message: $e");
    }
  }

  // edit messages

  // Update last chat between two users
}
