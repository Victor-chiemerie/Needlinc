import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:needlinc/needlinc/backend/functions/decompose-strings.dart';
import 'package:needlinc/needlinc/backend/functions/image-compression-rate.dart';
import 'package:needlinc/needlinc/backend/user-account/functionality.dart';
import 'package:needlinc/needlinc/needlinc-variables/colors.dart';
import 'package:needlinc/needlinc/widgets/snack-bar.dart';
import 'package:random_string/random_string.dart';
import 'package:flutter/material.dart';
import '../functions/filter-special-characters.dart';
import 'notification.dart';

class UploadPost {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final String randomUrl = randomAlphaNumeric(16);
  DateTime now = DateTime.now();

  Future<bool> homePagePostForImageAndWriteUp(
      BuildContext context,
      List<Uint8List> images,
      String writeUp,
      String freelancerOption,
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
        _firebaseStorage.ref().child('homePage/${user!.uid}/$randomUrl');

        // Upload the compressed image data
        final UploadTask uploadTask = storageRef.putData(image, metadata);

        // Wait for the upload to complete
        await uploadTask;

        // Retrieve the download URL for the compressed image
        String imageUrl = await storageRef.getDownloadURL();
        imageUrls.add(imageUrl);
      }

      // Update user data in Firestore
      await _firestore.collection('homePage').doc(randomUrl).set({
        'userDetails': {
          'profilePicture': await getUserData('profilePicture') ?? '',
          'fullName': await getUserData('fullName') ?? '',
          'userName': await getUserData('userName') ?? '',
          'userCategory': await getUserData('userCategory') ?? '',
          'address': await getUserData('address') ?? '',
          'skillSet': await getUserData('skillSet') ?? '',
          'businessName': await getUserData('businessName') ?? '',
          'userId': user!.uid ?? '',
        },
        'postDetails': {
          'images': imageUrls ?? '', // Storing multiple image URLs
          'writeUp': writeUp ?? '',
          'freelancerOption': freelancerOption ?? '',
          'hearts': [],
          'comments': [],
          'postId': randomUrl ?? '',
          'timeStamp': now.millisecondsSinceEpoch ?? '',
          'dbTimeStamp': FieldValue.serverTimestamp() ?? '',
        }
      });
      showSnackBar(context, 'Confirmed!',
          'Home page post successfully uploaded!', Colors.green);

      return true;
    } catch (e) {
      showSnackBar(context, 'Ooops!!!', 'Error uploading post to homepage: $e',
          NeedlincColors.red);
      return false;
    }
  }

  //Todo Upload Home Post for Images
  Future<bool> homePagePostForImage(
      BuildContext context,
      List<Uint8List> images,
      String freelancerOption,
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
        _firebaseStorage.ref().child('homePage/${user!.uid}/$randomUrl');

        // Upload the compressed image data
        final UploadTask uploadTask = storageRef.putData(image, metadata);

        // Wait for the upload to complete
        await uploadTask;

        // Retrieve the download URL for the compressed image
        String imageUrl = await storageRef.getDownloadURL();
        imageUrls.add(imageUrl);
      }

      // Update user data in Firestore
      await _firestore.collection('homePage').doc(randomUrl).set({
        'userDetails': {
          'profilePicture': await getUserData('profilePicture') ?? '',
          'fullName': await getUserData('fullName') ?? '',
          'userName': await getUserData('userName') ?? '',
          'userCategory': await getUserData('userCategory') ?? '',
          'address': await getUserData('address') ?? '',
          'skillSet': await getUserData('skillSet') ?? '',
          'businessName': await getUserData('businessName') ?? '',
          'userId': user!.uid ?? '',
        },
        'postDetails': {
          'images': imageUrls ?? '', // Storing multiple image URLs
          'writeUp': "",
          'freelancerOption': freelancerOption ?? '',
          'hearts': [],
          'comments': [],
          'postId': randomUrl ?? '',
          'timeStamp': now.millisecondsSinceEpoch ?? '',
          'dbTimeStamp': FieldValue.serverTimestamp() ?? '',
        }
      });
      showSnackBar(context, 'Confirmed!',
          'Home page post successfully uploaded!', Colors.green);

      return true;
    } catch (e) {
      showSnackBar(context, 'Ooops!!!', 'Error uploading post to homepage: $e',
          NeedlincColors.red);
      return false;
    }
  }

  //Todo Upload Home Post for Write Ups
  Future<bool> homePagePostForWriteUp(
      context, String writeUp, String freelancerOption) async {
    try {
      // Set metadata for the image
      firebase_storage.SettableMetadata metadata =
      firebase_storage.SettableMetadata(
        contentType:
        'image/jpeg', // Change this to the appropriate content type
        // You can set other metadata properties here if needed
      );

      // Use the provided uid for the user
      final User? user = _auth.currentUser;

      // Update user data in Firestore
      await _firestore.collection('homePage').doc(randomUrl).set({
        'userDetails': {
          'profilePicture': await getUserData('profilePicture') ?? '',
          'fullName': await getUserData('fullName') ?? '',
          'userName': await getUserData('userName') ?? '',
          'userCategory': await getUserData('userCategory') ?? '',
          'skillSet': await getUserData('skillSet') ?? '',
          'businessName': await getUserData('businessName') ?? '',
          'address': await getUserData('address') ?? '',
          'userId': user!.uid ?? '',
        },
        'postDetails': {
          'images': [],
          'writeUp': writeUp ?? '',
          'freelancerOption': freelancerOption ?? '',
          'postId': randomUrl ?? '',
          'hearts': [],
          'comments': [],
          'timeStamp': now.millisecondsSinceEpoch ?? '',
          'dbTimeStamp': FieldValue.serverTimestamp() ?? '',
        }
      });
      showSnackBar(context, 'Confirmed!',
          'Home page post successfully uploaded!', Colors.green);
      return true;
    } catch (e) {
      showSnackBar(context, 'Ooops!!!', 'Error uploading post to homepage: $e',
          NeedlincColors.red);
    }
    return true;
  }

  Future<bool> MarketPlacePost({
    required BuildContext context,
    required List<Uint8List> images,
    required String description,
    required String productName,
    required String price,
    required String category,
  }) async {
    try {
      // Set metadata for the image
      firebase_storage.SettableMetadata metadata =
      firebase_storage.SettableMetadata(
        contentType:
        'image/jpeg', // Change this to the appropriate content type
        // You can set other metadata properties here if needed
      );

      final User? user = _auth.currentUser;
      final String productUrl =
      randomAlphaNumeric(16); // Unique identifier for the product
      List<String> imageUrls = [];

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

        final String imageId =
        randomAlphaNumeric(16); // Unique identifier for each image
        final Reference storageRef = _firebaseStorage
            .ref()
            .child('marketPlacePage/${user!.uid}/$productUrl/$imageId');
        final UploadTask uploadTask = storageRef.putData(image, metadata);

        await uploadTask.whenComplete(() => null);
        String imageUrl = await storageRef.getDownloadURL();
        imageUrls.add(imageUrl);
      }

      int millisecondsSinceEpoch = DateTime.now().millisecondsSinceEpoch;
      final String businessName = await getUserData('businessName') ?? '';
      final String userName = await getUserData('userName') ?? '';
      final String names =
      businessName == '' ? userName : '$userName $businessName';

      await _firestore.collection('marketPlacePage').doc(productUrl).set({
        'userDetails': {
          'profilePicture': await getUserData('profilePicture') ?? '',
          'fullName': await getUserData('fullName') ?? '',
          'userName': await getUserData('userName') ?? '',
          'userCategory': await getUserData('userCategory') ?? '',
          'skillSet': await getUserData('skillSet') ?? '',
          'businessName': await getUserData('businessName') ?? '',
          'address': await getUserData('address') ?? '',
          'userId': user!.uid ?? '',
        },
        'productDetails': {
          'images': imageUrls ??
              '', // Note: Field name changed to 'images' to reflect that it's a list
          'name': productName ?? '',
          'description': description ?? '',
          'price': filterSpecialCharsNoSpaces(price) ?? '',
          'category': category ?? '',
          'hearts': [] ?? '',
          'comments': [] ?? '',
          'productId': productUrl ?? '',
          'timeStamp': millisecondsSinceEpoch ?? '',
          'dbTimeStamp': FieldValue.serverTimestamp() ?? '',
          'searchIndex': combineWords(
            productName.toLowerCase(),
            names.toLowerCase(),
            category.toLowerCase(),
          )
        },
      });

      showSnackBar(context, 'Confirmed!',
          'Market Place page post successfully uploaded!', Colors.green);
      return true;
    } catch (e) {
      showSnackBar(context, 'Sorry!!!',
          'Error uploading post to Market Place page: $e', NeedlincColors.red);
      return false;
    }
  }

  //Todo Uploading Homepage and MarketPlace Comments
  Future<dynamic> uploadComments(
      {required BuildContext context,
        required String message,
        required String sourceOption,
        required String ownerOfPostUserId,
        required String id}) async {
    try {
      final User? user = _auth.currentUser;

      Map<String, dynamic> comment = {
        'profilePicture': await getUserData('profilePicture') ?? '',
        'fullName': await getUserData('fullName') ?? '',
        'userName': await getUserData('userName') ?? '',
        'userCategory': await getUserData('userCategory') ?? '',
        'address': await getUserData('address') ?? '',
        'userId': user!.uid ?? '',
        'message': message ?? '',
        'skillSet': await getUserData('skillSet') ?? '',
        'businessName': await getUserData('businessName') ?? '',
        'timeStamp': now.millisecondsSinceEpoch ?? '',
        'commentHearts': [] ?? '',
      };

      // Step 1: Retrieve the current data
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection(sourceOption)
          .doc(id)
          .get();
      // Step 2: Modify the 'comments' array within 'postDetails'
      Map<String, dynamic> data =
          await documentSnapshot.data() as Map<String, dynamic>? ?? {};

      Map<String, dynamic> postDetails = sourceOption == 'homePage'
          ? data['postDetails'] as Map<String, dynamic>? ?? {}
          : data['productDetails'] as Map<String, dynamic>? ?? {};

      List<dynamic> currentArray =
          (postDetails['comments'] as List<dynamic>) ?? [];

      currentArray.add(comment);

      postDetails['comments'] = currentArray;

      // Step 3: Update Firestore with the modified data
      sourceOption == 'homePage'
          ? await FirebaseFirestore.instance
          .collection(sourceOption)
          .doc(id)
          .update({'postDetails': postDetails})
          : await FirebaseFirestore.instance
          .collection(sourceOption)
          .doc(id)
          .update({'productDetails': postDetails});

      commentsAndHeartsNotification(
          myUserId: user!.uid,
          otherUserId: ownerOfPostUserId,
          postId: id,
          pageType: sourceOption,
          actionType: 'comment');
    } catch (e) {
      showSnackBar(context, 'Ooops!!!',
          'Error uploading reply to $sourceOption post $e', NeedlincColors.red);
    }
    return true;
  }

  //Todo Uploading Homepage and MarketPlace uploadHearts
  Future<dynamic> uploadHearts(
      {required BuildContext context,
        required String sourceOption,
        required String ownerOfPostUserId,
        required String id}) async {
    try {
      // Step 1: Retrieve the current data
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection(sourceOption)
          .doc(id)
          .get();
      // Step 2: Modify the 'comments' array within 'postDetails'
      Map<String, dynamic> data =
          await documentSnapshot.data() as Map<String, dynamic>? ?? {};

      Map<String, dynamic>? postDetails;

      switch(sourceOption){
        case 'homePage': {
           postDetails = data['postDetails'] as Map<String, dynamic>? ?? {};
          break;
        }
        case 'newsPage': {
          postDetails = data['newsDetails'] as Map<String, dynamic>? ?? {};
          break;
        }
        case 'marketPlacePage': {
          postDetails = data['productDetails'] as Map<String, dynamic>? ?? {};
          break;
        }
      }

      List<dynamic> currentArray =
          (postDetails!['hearts'] as List<dynamic>) ?? [];

      if (currentArray.contains(_auth.currentUser!.uid)) {
        // If the name is found, remove it from the set
        currentArray.remove(_auth.currentUser!.uid);
      } else {
        // If the name is not found, add it to the set
        currentArray.add(_auth.currentUser!.uid);
        commentsAndHeartsNotification(
            myUserId: _auth.currentUser!.uid,
            otherUserId: ownerOfPostUserId,
            postId: id,
            pageType: sourceOption,
            actionType: 'heart');
      }

      postDetails['hearts'] = currentArray;

      // Step 3: Update Firestore with the modified data
      switch(sourceOption){
        case 'homePage': {
          await FirebaseFirestore.instance
              .collection(sourceOption)
              .doc(id)
              .update({'postDetails': postDetails});
          break;
        }
        case 'newsPage': {
          await FirebaseFirestore.instance
              .collection(sourceOption)
              .doc(id)
              .update({'newsDetails': postDetails});
          break;
        }
        case 'marketPlacePage': {
          await FirebaseFirestore.instance
              .collection(sourceOption)
              .doc(id)
              .update({'productDetails': postDetails});
          break;
        }
      }

    } catch (e) {
      showSnackBar(context, 'Ooops!!!', 'Error', NeedlincColors.red);
    }
    return true;
  }
}