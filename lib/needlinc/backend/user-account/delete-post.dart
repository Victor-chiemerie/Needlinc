import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:needlinc/needlinc/needlinc-variables/colors.dart';
import 'package:needlinc/needlinc/widgets/snack-bar.dart';
import 'package:random_string/random_string.dart';
import 'package:flutter/material.dart';

class DeletePost {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  DateTime now = DateTime.now();
  final String randomUrl = randomAlphaNumeric(16);

  //Todo Delete Home Post for Images and Write Ups
  Future<bool> deleteHomePagePost(
      {required BuildContext context, required String postId}) async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) {
        showSnackBar(
            context, 'Sorry!!!', 'User not logged in', NeedlincColors.red);
        return false;
      }

      // Get post details from Firestore
      DocumentSnapshot postSnapshot =
          await _firestore.collection('homePage').doc(postId).get();
      if (!postSnapshot.exists) {
        showSnackBar(context, 'Ooops!!!', 'Linc not found', NeedlincColors.red);
        return false;
      }

      Map<String, dynamic> postData =
          postSnapshot.data() as Map<String, dynamic>;
      List<dynamic> imageUrls = postData['postDetails']['images'];

      if (imageUrls.length > 0) {
        // Delete images from Firebase Storage
        for (var imageUrl in imageUrls) {
          final Reference storageRef = _firebaseStorage.refFromURL(imageUrl);
          await storageRef.delete();
        }
      }

      // Delete post data from Firestore
      await _firestore.collection('homePage').doc(postId).delete();

      showSnackBar(context, 'Confirmed!',
          'Home page Linc successfully deleted!', Colors.green);
      return true;
    } catch (e) {
      showSnackBar(context, 'Ooops!!!', 'Error deleting Linc from homepage: $e',
          NeedlincColors.red);
      return false;
    }
  }

//Todo Delete News Post for Images and Write Ups
  Future<bool> deleteNewsPost(
      {required BuildContext context, required String postId}) async {
    try {
      // Get the current user
      final User? currentUser = _auth.currentUser;

      // If no user is logged in, return false
      if (currentUser == null) {
        return false;
      }

      // Fetch the post document
      DocumentSnapshot postSnapshot =
          await _firestore.collection('newsPage').doc(postId).get();

      // If post doesn't exist, return false
      if (!postSnapshot.exists) {
        return false;
      }

      // Extract post data
      Map<String, dynamic> postData =
          postSnapshot.data() as Map<String, dynamic>;

      // Get the user ID of the post owner
      String postOwnerId = postData['userDetails']['userId'];

      // Check if the current user is the owner of the post
      if (postOwnerId == currentUser.uid) {
        // Delete the images associated with the post
        List<dynamic> imageUrls = postData['newsDetails']['images'];

        if (imageUrls.length > 0) {
          // Delete images from Firebase Storage
          for (var imageUrl in imageUrls) {
            final Reference storageRef = _firebaseStorage.refFromURL(imageUrl);
            await storageRef.delete();
          }
        }

        // Delete the post
        await _firestore.collection('newsPage').doc(postId).delete();
        return true; // Deletion successful
      } else {
        return false; // User is not the owner of the post
      }
    } catch (e) {
      print('Error deleting post: $e');
      return false; // Error occurred during deletion
    }
  }

  //Todo Delete Market Place Post for Images and Write Ups
  Future<bool> deleteMarketPlacePagePost(
      {required BuildContext context, required String postId}) async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) {
        showSnackBar(
            context, 'Sorry!!!', 'User not logged in', NeedlincColors.red);
        return false;
      }

      // Get post details from Firestore
      DocumentSnapshot postSnapshot =
          await _firestore.collection('marketPlacePage').doc(postId).get();
      if (!postSnapshot.exists) {
        showSnackBar(context, 'Ooops!!!', 'Linc not found', NeedlincColors.red);
        return false;
      }

      Map<String, dynamic> postData =
          postSnapshot.data() as Map<String, dynamic>;
      List<dynamic> imageUrls = postData['productDetails']['images'];

      if (imageUrls.length > 0) {
        // Delete images from Firebase Storage
        for (var imageUrl in imageUrls) {
          final Reference storageRef = _firebaseStorage.refFromURL(imageUrl);
          await storageRef.delete();
        }
      }

      // Delete post data from Firestore
      await _firestore.collection('marketPlacePage').doc(postId).delete();

      showSnackBar(context, 'Confirmed!',
          'Market Place page Linc successfully deleted!', Colors.green);
      return true;
    } catch (e) {
      showSnackBar(context, 'Ooops!!!',
          'Error deleting Linc from market place: $e', NeedlincColors.red);
      return false;
    }
  }

  //
  // //Todo Delete Home Post for Images
  // Future<bool> deleteHomePageImagePost(BuildContext context, String postId) async {
  //   try {
  //     final User? user = _auth.currentUser;
  //     if (user == null) {
  //       showSnackBar(context, 'User not logged in');
  //       return false;
  //     }
  //
  //     // Get post details from Firestore
  //     DocumentSnapshot postSnapshot = await _firestore.collection('homePage').doc(postId).get();
  //     if (!postSnapshot.exists) {
  //       showSnackBar(context, 'Post not found');
  //       return false;
  //     }
  //
  //     Map<String, dynamic> postData = postSnapshot.data() as Map<String, dynamic>;
  //     List<dynamic> imageUrls = postData['postDetails']['images'];
  //
  //     // Delete images from Firebase Storage
  //     for (var imageUrl in imageUrls) {
  //       final Reference storageRef = _firebaseStorage.refFromURL(imageUrl);
  //       await storageRef.delete();
  //     }
  //
  //     // Delete post data from Firestore
  //     await _firestore.collection('homePage').doc(postId).delete();
  //
  //     showSnackBar(context, 'Home page image post successfully deleted!');
  //     return true;
  //   } catch (e) {
  //     showSnackBar(context, 'Error deleting image post from homepage: $e');
  //     return false;
  //   }
  // }
  //
  //
  //
  //
  //
  // //Todo Upload Home Post for Write Ups
  // Future<bool> deleteHomePageWriteUpPost(BuildContext context, String postId) async {
  //   try {
  //     final User? user = _auth.currentUser;
  //     if (user == null) {
  //       showSnackBar(context, 'User not logged in');
  //       return false;
  //     }
  //
  //     // Check if the post exists in Firestore
  //     DocumentSnapshot postSnapshot = await _firestore.collection('homePage').doc(postId).get();
  //     if (!postSnapshot.exists) {
  //       showSnackBar(context, 'Post not found');
  //       return false;
  //     }
  //
  //     // Delete post data from Firestore
  //     await _firestore.collection('homePage').doc(postId).delete();
  //
  //     showSnackBar(context, 'Home page write-up post successfully deleted!');
  //     return true;
  //   } catch (e) {
  //     showSnackBar(context, 'Error deleting write-up post from homepage: $e');
  //     return false;
  //   }
  // }
  //
  //

  //
  //
  // Future<bool> deleteMarketPlacePost(BuildContext context, String productId) async {
  //   try {
  //     final User? user = _auth.currentUser;
  //     if (user == null) {
  //       showSnackBar(context, 'User not logged in');
  //       return false;
  //     }
  //
  //     // Get product details from Firestore
  //     DocumentSnapshot productSnapshot = await _firestore.collection('marketPlacePage').doc(productId).get();
  //     if (!productSnapshot.exists) {
  //       showSnackBar(context, 'Product not found');
  //       return false;
  //     }
  //
  //     Map<String, dynamic> productData = productSnapshot.data() as Map<String, dynamic>;
  //     List<dynamic> imageUrls = productData['productDetails']['images'];
  //
  //     // Delete images from Firebase Storage
  //     for (var imageUrl in imageUrls) {
  //       final Reference storageRef = _firebaseStorage.refFromURL(imageUrl);
  //       await storageRef.delete();
  //     }
  //
  //     // Delete product data from Firestore
  //     await _firestore.collection('marketPlacePage').doc(productId).delete();
  //
  //     showSnackBar(context, 'Market Place Linc successfully deleted!');
  //     return true;
  //   } catch (e) {
  //     showSnackBar(context, 'Error deleting Linc from Market Place');
  //     return false;
  //   }
  // }
  //
  //
  //
  //
  //
  //
  //

  //Todo Delete Chat Post for Images and Write Ups
  Future<bool> deleteMessagePost(
      {required BuildContext context, required String chatCollection}) async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) {
        showSnackBar(
            context, 'Sorry!!!', 'User not logged in', NeedlincColors.red);
        return false;
      }

      // Get post details from Firestore
      DocumentSnapshot postSnapshot =
          await _firestore.collection('chats').doc(chatCollection).get();
      if (!postSnapshot.exists) {
        showSnackBar(
            context, 'Ooops!!!', 'message not found', NeedlincColors.red);
        return false;
      }

      // Delete post data from Firestore
      await _firestore.collection('chats').doc(chatCollection).delete();

      return true;
    } catch (e) {
      showSnackBar(
          context, 'Sorry!!!', 'Error deleting message', NeedlincColors.red);
      return false;
    }
  }

  //Todo Delete Chat Post for Images and Write Ups
  Future<bool> deleteChatPost(
      {required BuildContext context,
      required String chatCollection,
      required String chatId}) async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) {
        showSnackBar(
            context, 'Sorry!!!', 'User not logged in', NeedlincColors.red);
        return false;
      }

      // Get post details from Firestore
      DocumentSnapshot postSnapshot = await _firestore
          .collection('chats')
          .doc(chatCollection)
          .collection(chatCollection)
          .doc(chatId)
          .get();
      if (!postSnapshot.exists) {
        showSnackBar(context, 'ooops!!!', 'chat not found', NeedlincColors.red);
        return false;
      }

      Map<String, dynamic> postData =
          postSnapshot.data() as Map<String, dynamic>;
      List<dynamic> imageUrls = postData['image'];

      if (imageUrls.length > 0) {
        // Delete images from Firebase Storage
        for (var imageUrl in imageUrls) {
          final Reference storageRef = _firebaseStorage.refFromURL(imageUrl);
          await storageRef.delete();
        }
      }

      // Delete post data from Firestore
      await _firestore
          .collection('chats')
          .doc(chatCollection)
          .collection(chatCollection)
          .doc(chatId)
          .delete();

      return true;
    } catch (e) {
      showSnackBar(
          context, 'Ooops!!!', 'Error deleting chat', NeedlincColors.red);
      return false;
    }
  }
}
