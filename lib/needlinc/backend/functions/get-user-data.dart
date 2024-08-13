import 'package:cloud_firestore/cloud_firestore.dart';

Future<Map<String, dynamic>?> getUserDataWithUserId(String userId) async {
  try {
    // Reference to the Firestore collection
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    // Get the document snapshot based on the userId
    DocumentSnapshot userSnapshot = await users.doc(userId).get();

    // Check if the document exists
    if (userSnapshot.exists) {
      // Return the user data as a Map
      return userSnapshot.data() as Map<String, dynamic>;
    } else {
      // Document with the provided userId doesn't exist
      print('User not found');
      return null;
    }
  } catch (error) {
    // Handle errors
    print('Error fetching user data: $error');
    return null;
  }
}