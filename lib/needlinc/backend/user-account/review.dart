import 'package:cloud_firestore/cloud_firestore.dart';
import '../functions/get-user-data.dart';

void sendReviewstoDatabase({
  required String myUserId,
  required String otherUserId,
  required int rating,
  required String reviewMessage,
}) async {

  DateTime now = DateTime.now();

  Map<String, dynamic>? _myInfomation = await getUserDataWithUserId(myUserId);
  Map<String, dynamic>? _otherInfomation = await getUserDataWithUserId(otherUserId);


  Map<String, dynamic> userReview = {
    'myUserId': myUserId,
    'myUserName': await _myInfomation!['userName'] ?? "",
    'otherUserId': otherUserId,
    'otherUserName': _otherInfomation!['userName'] ?? "",
    'rating': rating,
    'reviewMessage': reviewMessage,
    'averagePoint': rating,
    'timeStamp': now.millisecondsSinceEpoch,
  };

  // Step 1: Retrieve the current data
  DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(otherUserId)
      .get();
  // Step 2: Modify the 'reviews' array within 'users'
  Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>? ?? {};
  List<Map<String, dynamic>> currentArray = [];

  // Check the database if there are any reviews for the user
  if (data['reviews'].length > 0) {
    currentArray = (data['reviews'] as List<dynamic>).cast<Map<String, dynamic>>();
    num numerator = currentArray.fold<num>(0, (num previousValue, Map<String, dynamic> map) {
      return previousValue + (map['rating'] ?? 0);
    });
    num denominator = 5 * currentArray.length;

    userReview['averagePoint'] = (numerator / denominator) * 5;

    currentArray.add(userReview);

    data['reviews'] = currentArray;

    // Step 3: Update Firestore with the modified data
    await FirebaseFirestore.instance.collection('users').doc(otherUserId).update(data);

    await FirebaseFirestore.instance.collection('users').doc(otherUserId).update({'averagePoint' : userReview['averagePoint']});
  }
  else{
    currentArray.add(userReview);

    data['reviews'] = currentArray;

    // Step 3: Update Firestore with the modified data
    await FirebaseFirestore.instance.collection('users').doc(otherUserId).update(data);

    await FirebaseFirestore.instance.collection('users').doc(otherUserId).update({'averagePoint' : userReview['averagePoint']});
  }


}
