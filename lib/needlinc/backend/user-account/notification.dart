import 'package:cloud_firestore/cloud_firestore.dart';
import '../functions/get-user-data.dart';

void commentsAndHeartsNotification({
  required String myUserId,
  required String otherUserId,
  required String postId,
  required String pageType,
  required String actionType
}) async {

  DateTime now = DateTime.now();

  Map<String, dynamic>? _myInfomation = await getUserDataWithUserId(myUserId);
  Map<String, dynamic>? _otherInfomation = await getUserDataWithUserId(otherUserId);

  Map<String, dynamic> notification = {
    'myUserId': myUserId,
    'myUserName': _myInfomation!['userName'] ?? "",
    'otherUserId': otherUserId,
    'otherUserName': _otherInfomation!['userName'] ?? "",
    'postId': postId,
    'pageType': pageType,
    'actionType': actionType,
    'timeStamp': now.millisecondsSinceEpoch,
   // 'dbTimeStamp': FieldValue.serverTimestamp(),
  };

  // Step 1: Retrieve the current data
  DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(otherUserId)
      .get();
  // Step 2: Modify the 'comments' array within 'postDetails'
  Map<String, dynamic> data = await documentSnapshot.data() as Map<String, dynamic>? ?? {};
  List<dynamic> currentArray = [];

  //Todo Check the database if there is any notification for the user
  if(data['notifications'] != null) {
    currentArray = (data['notifications'] as List<dynamic>) ?? [];
  }

  currentArray.add(notification);

  data['notifications'] = currentArray;

  // Step 3: Update Firestore with the modified data
  await FirebaseFirestore.instance.collection('users').doc(otherUserId).update(data);

}