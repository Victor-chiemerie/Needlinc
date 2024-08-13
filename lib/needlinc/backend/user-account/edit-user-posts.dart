import 'package:cloud_firestore/cloud_firestore.dart';

class updateUserPostsInDatabase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateUserInformationInDatabasePost(String userId) async {
    try {
      // Retrieve user information
      final userDoc = await _firestore.collection('users').doc(userId).get();
      final userData = userDoc.data() as Map<String, dynamic>?;

      if (userData != null) {
        final userDetails = userData;

        // Update fields in homePage
        await _updateFieldsInCollection('homePage', userId, userDetails);

        // Update fields in marketPlacePage
        await _updateFieldsInCollection('marketPlacePage', userId, userDetails);

        // Update fields in newsPage (assuming similar structure)
        await _updateFieldsInCollection('newsPage', userId, userDetails);

        print('User information updated in all pages successfully!');
      }
    } catch (e) {
      print('Error updating user information: $e');
    }
  }





  Future<void> _updateFieldsInCollection(String collectionName, String userId, Map<String, dynamic> userDetails) async {
    try {
      // Retrieve post IDs authored by the user
      final userPostsQuerySnapshot = await _firestore.collection(collectionName).where('userDetails.userId', isEqualTo: userId).get();
      // Update userDetails fields in documents corresponding to user's posts
      for (final postDoc in userPostsQuerySnapshot.docs) {
        final postId = postDoc.id;

        // Update userDetails fields in the document
        await _firestore.collection(collectionName).doc(postId).update({
          'userDetails': userDetails,
        });
      }
    } catch (e) {
      print('Error updating fields in $collectionName: $e');
    }
  }



}
