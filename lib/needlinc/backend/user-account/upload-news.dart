import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:needlinc/needlinc/backend/functions/image-compression-rate.dart';
import 'package:needlinc/needlinc/needlinc-variables/colors.dart';
import 'package:random_string/random_string.dart';
import '../../widgets/snack-bar.dart';
import 'functionality.dart';

class UploadNews {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final String randomUrl = randomAlphaNumeric(16);
  DateTime now = DateTime.now();

  Future<bool> newsPagePostForImageAndWriteUp(
      BuildContext context,
      List<Uint8List> images,
      String writeUp,
      ) async {
    try {
      // Set metadata for the image
      firebase_storage.SettableMetadata metadata =
      firebase_storage.SettableMetadata(
        contentType:
        'image/jpeg', // Change this to the appropriate content type
        // You can set other metadata properties here if needed
      );

      final User? user = _auth.currentUser;
      List<String> imageUrls = [];

      // Upload each image and collect URLs
      for (var image in images) {
        // Compress image if needed
        if (shouldCompress(image)) {
          int quality = 85;
          int compressedFileSize = estimateCompressedFileSize(image);

          while (image.lengthInBytes > compressedFileSize) {
            image = await FlutterImageCompress.compressWithList(
              image,
              quality: quality, // Adjust the quality (0 to 100)
            );

            quality -= 5;

            if (quality < 5) {
              break;
            }
          }
        }

        // Generate a random URL for storage
        final String randomUrl = randomAlphaNumeric(16);

        // Create a reference to the Firebase Storage location
        final Reference storageRef =
        _firebaseStorage.ref().child('newsPage/${user!.uid}/$randomUrl');

        // Upload the compressed image data
        final UploadTask uploadTask = storageRef.putData(image, metadata);

        // Wait for the upload to complete
        await uploadTask;

        // Retrieve the download URL for the compressed image
        String imageUrl = await storageRef.getDownloadURL();
        imageUrls.add(imageUrl);
      }

      // Update user data in Firestore
      await _firestore.collection('newsPage').doc(randomUrl).set({
        'userDetails': {
          'profilePicture': await getUserData('profilePicture'),
          'fullName': await getUserData('fullName'),
          'userName': await getUserData('userName'),
          'userCategory': await getUserData('userCategory'),
          'address': await getUserData('address'),
          'userId': user!.uid,
        },
        'newsDetails': {
          'images': imageUrls, // Storing multiple image URLs
          'writeUp': writeUp,
          'hearts': [],
          'comments': [],
          'newsId': randomUrl,
          'timeStamp': now.millisecondsSinceEpoch,
          'dbTimeStamp': FieldValue.serverTimestamp(),
        }
      });
      showSnackBar(context, 'Confirmed!',
          'News page post successfully uploaded!', Colors.green);

      return true;
    } catch (e) {
      showSnackBar(context, 'Ooops!!!', 'Error uploading post to News Page: $e',
          NeedlincColors.red);
      return false;
    }
  }

  //Todo Upload Home Post for Images
  Future<bool> newsPagePostForImage(
      BuildContext context,
      List<Uint8List> images,
      ) async {
    try {
      // Set metadata for the image
      firebase_storage.SettableMetadata metadata =
      firebase_storage.SettableMetadata(
        contentType:
        'image/jpeg', // Change this to the appropriate content type
        // You can set other metadata properties here if needed
      );

      final User? user = _auth.currentUser;
      List<String> imageUrls = [];

      // Upload each image and collect URLs
      for (var image in images) {
        // Compress image if needed
        if (shouldCompress(image)) {
          int quality = 85;
          int compressedFileSize = estimateCompressedFileSize(image);
          while (image.lengthInBytes > compressedFileSize) {
            image = await FlutterImageCompress.compressWithList(
              image,
              quality: quality, // Adjust the quality (0 to 100)
            );

            quality -= 5;

            if (quality < 5) {
              break;
            }
          }
        }

        // Generate a random URL for storage
        final String randomUrl = randomAlphaNumeric(16);

        // Create a reference to the Firebase Storage location
        final Reference storageRef =
        _firebaseStorage.ref().child('newsPage/${user!.uid}/$randomUrl');

        // Upload the compressed image data
        final UploadTask uploadTask = storageRef.putData(image, metadata);

        // Wait for the upload to complete
        await uploadTask;

        // Retrieve the download URL for the compressed image
        String imageUrl = await storageRef.getDownloadURL();
        imageUrls.add(imageUrl);
      }

      // Update user data in Firestore
      await _firestore.collection('newsPage').doc(randomUrl).set({
        'userDetails': {
          'profilePicture': await getUserData('profilePicture'),
          'fullName': await getUserData('fullName'),
          'userName': await getUserData('userName'),
          'userCategory': await getUserData('userCategory'),
          'address': await getUserData('address'),
          'userId': user!.uid,
        },
        'newsDetails': {
          'images': imageUrls, // Storing multiple image URLs
          'writeUp': "",
          'hearts': [],
          'comments': [],
          'newsId': randomUrl,
          'timeStamp': now.millisecondsSinceEpoch,
          'dbTimeStamp': FieldValue.serverTimestamp(),
        }
      });
      showSnackBar(context, 'Confirmed!',
          'News page post successfully uploaded!', Colors.green);

      return true;
    } catch (e) {
      showSnackBar(context, 'Ooops!!!', 'Error uploading post to News Page: $e',
          NeedlincColors.red);
      return false;
    }
  }

  //Todo Upload Home Post for Write Ups
  Future<bool> newsPagePostForWriteUp(context, String writeUp) async {
    try {
      // Use the provided uid for the user
      final User? user = _auth.currentUser;

      // Update user data in Firestore
      await _firestore.collection('newsPage').doc(randomUrl).set({
        'userDetails': {
          'profilePicture': await getUserData('profilePicture'),
          'fullName': await getUserData('fullName'),
          'userName': await getUserData('userName'),
          'userCategory': await getUserData('userCategory'),
          'address': await getUserData('address'),
          'userId': user!.uid,
        },
        'newsDetails': {
          'images': [],
          'writeUp': writeUp,
          'newsId': randomUrl,
          'hearts': [],
          'comments': [],
          'timeStamp': now.millisecondsSinceEpoch,
          'dbTimeStamp': FieldValue.serverTimestamp(),
        }
      });
      showSnackBar(context, 'Confirmed!',
          'News page post successfully uploaded!', Colors.green);
      return true;
    } catch (e) {
      showSnackBar(context, 'Ooops!!!', 'Error uploading post to News Page: $e',
          NeedlincColors.red);
    }
    return true;
  }

  //Todo Uploading News Comments
  Future<dynamic> uploadNewsComments(
      {required BuildContext context,
        required String message,
        required String sourceOption,
        required String ownerOfPostUserId,
        required String id}) async {
    try {
      final User? user = _auth.currentUser;

      Map<String, dynamic> comment = {
        'profilePicture': await getUserData('profilePicture'),
        'fullName': await getUserData('fullName'),
        'userName': await getUserData('userName'),
        'userCategory': await getUserData('userCategory'),
        'address': await getUserData('address'),
        'userId': user!.uid,
        'message': message,
        'timeStamp': now.millisecondsSinceEpoch,
        'commentHearts': [],
      };

      // Step 1: Retrieve the current data
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection(sourceOption)
          .doc(id)
          .get();
      // Step 2: Modify the 'comments' array within 'postDetails'
      Map<String, dynamic> data =
          await documentSnapshot.data() as Map<String, dynamic>? ?? {};

      Map<String, dynamic> newsDetails =
          data['newsDetails'] as Map<String, dynamic>? ?? {};

      List<dynamic> currentArray =
          (newsDetails['comments'] as List<dynamic>) ?? [];

      currentArray.add(comment);

      newsDetails['comments'] = currentArray;

      // Step 3: Update Firestore with the modified data
      await FirebaseFirestore.instance
          .collection(sourceOption)
          .doc(id)
          .update({'newsDetails': newsDetails});
    } catch (e) {
      showSnackBar(context, 'Ooops!!!',
          'Error uploading reply to $sourceOption post $e', NeedlincColors.red);
    }
    return true;
  }
}