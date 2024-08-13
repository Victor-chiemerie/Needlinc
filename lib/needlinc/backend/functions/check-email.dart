import 'package:cloud_firestore/cloud_firestore.dart';

Future<bool> checkUserEmailExistence(String email) async {
  try {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Username already exists
      return false;
    } else {
      // Username does not exist
      return true;
    }
  } catch (error) {
    // Error occurred while checking
    print('Error checking username existence: $error');
    return false;
  }
}
