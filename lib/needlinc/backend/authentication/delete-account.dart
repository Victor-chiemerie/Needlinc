import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ManageAccount{

  Future<void> deleteThisUserAccount(String userId) async {
    try {
      // Check user authentication
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null || currentUser.uid != userId) {
        throw Exception("User not authenticated or not authorized to perform this action.");
      }

      // Delete user's homepage posts and associated images
      QuerySnapshot homepagePosts = await FirebaseFirestore.instance
          .collection('homePage')
          .where('userDetails.userId', isEqualTo: userId)
          .get();
      homepagePosts.docs.forEach((doc) async {
        // Delete images associated with the post
        List<String>? imageUrls = List<String>.from(doc['postDetails']['images']);
        if (imageUrls != null && imageUrls.isNotEmpty) {
          imageUrls.forEach((url) async {
            Reference storageRef = FirebaseStorage.instance.refFromURL(url);
            await storageRef.delete();
          });
        }

        // Delete the post
        await doc.reference.delete();
      });

      // Delete user's comments on homepage posts
      await deleteUserCommentsOnPage('homePage', userId);


      // Delete user's marketplace posts and associated images
      QuerySnapshot marketplacePosts = await FirebaseFirestore.instance
          .collection('marketPlacePage')
          .where('userDetails.userId', isEqualTo: userId)
          .get();
      marketplacePosts.docs.forEach((doc) async {
        // Delete images associated with the post
        List<String>? imageUrls = List<String>.from(doc['productDetails']['images']);
        if (imageUrls != null && imageUrls.isNotEmpty) {
          imageUrls.forEach((url) async {
            Reference storageRef = FirebaseStorage.instance.refFromURL(url);
            await storageRef.delete();
          });
        }

        // Delete the post
        await doc.reference.delete();
      });

      // Delete user's comments on marketplace posts
      await deleteUserCommentsOnPage('marketPlacePage', userId);


      // Delete user's news posts and associated images
      QuerySnapshot newsPosts = await FirebaseFirestore.instance
          .collection('newsPage')
          .where('userDetails.userId', isEqualTo: userId)
          .get();
      newsPosts.docs.forEach((doc) async {
        // Delete images associated with the post
        List<String>? imageUrls = List<String>.from(doc['newsDetails']['images']);
        if (imageUrls != null && imageUrls.isNotEmpty) {
          imageUrls.forEach((url) async {
            Reference storageRef = FirebaseStorage.instance.refFromURL(url);
            await storageRef.delete();
          });
        }

        // Delete the post
        await doc.reference.delete();
      });

      // Delete user's comments on news posts
      await deleteUserCommentsOnPage('newsPage', userId);


      // Delete user's chats
      QuerySnapshot chats = await FirebaseFirestore.instance
          .collection('chats')
          .where('userIds', arrayContains: userId)
          .get();
      chats.docs.forEach((doc) async {
        String chatId = doc['chatId'];
        await doc.reference.delete();

        // Delete messages in the chat
        QuerySnapshot messages = await FirebaseFirestore.instance
            .collection('chats')
            .doc(chatId)
            .collection(chatId)
            .get();
        messages.docs.forEach((message) async {
          await message.reference.delete();
        });
      });

      // Delete user's document from 'users' collection
      await FirebaseFirestore.instance.collection('users').doc(userId).delete();

      // Delete user's authentication record
      await currentUser.delete();

      // Log out the user
      await FirebaseAuth.instance.signOut();

      print('User account deleted successfully.');
    } catch (e) {
      print('Error deleting user account: $e');
    }
  }


  deleteProfilePicture(String userId) async {

    // Delete user's profile picture if it exists
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();
    if (userDoc.exists) {
      String? profilePictureUrl = userDoc['profilePicture'];
      if (profilePictureUrl != null && profilePictureUrl.isNotEmpty) {
        Reference storageRef = FirebaseStorage.instance.refFromURL(profilePictureUrl);
        await storageRef.delete();
      }
    }

  }




  Future<void> deleteUserCommentsOnPage(String pageName, String userId) async {
    try{
      if(pageName == 'homePage'){
        QuerySnapshot posts = await FirebaseFirestore.instance
            .collection(pageName)
            .get();

        posts.docs.forEach((doc) async {
          List<dynamic> comments = List<dynamic>.from(
              doc['postDetails']['comments']);

          comments.removeWhere((comment) => comment['userId'] == userId);

          await doc.reference.update({'postDetails.comments': comments});
        });
      }
      else if(pageName == 'marketPlacePage'){
        QuerySnapshot posts = await FirebaseFirestore.instance
            .collection(pageName)
            .get();

        posts.docs.forEach((doc) async {
          List<dynamic> comments = List<dynamic>.from(
              doc['productDetails']['comments']);
          comments.removeWhere((comment) => comment['userId'] == userId);

          await doc.reference.update({'productDetails.comments': comments});
        });
      }
      else if(pageName == 'newsPage'){
        QuerySnapshot posts = await FirebaseFirestore.instance
            .collection(pageName)
            .get();

        posts.docs.forEach((doc) async {
          List<dynamic> comments = List<dynamic>.from(
              doc['newsDetails']['comments']);
          comments.removeWhere((comment) => comment['userId'] == userId);

          await doc.reference.update({'newsDetails.comments': comments});
        });
      }
      else{
        print('Error');
      }
    } catch (error){
      print(error);
    }

  }


}
