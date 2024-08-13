import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//This functuin gets the phone Number of a particular user
Future<String?> getPhoneNumber(BuildContext context, String userId) async {
  try {
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (documentSnapshot.exists) {
      Map<String, dynamic>? data = documentSnapshot.data();
      if (data != null && data.containsKey('phoneNumber')) {
        return data['phoneNumber'] as String;
      } else {
        print('Phone number field not found');
        return null;
      }
    } else {
      print('User document does not exist');
      return null;
    }
  } on FirebaseException catch (e) {
    print("Error fetching user data: $e");
    return null;
  }
}
