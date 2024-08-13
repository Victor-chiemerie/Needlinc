import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:needlinc/needlinc/backend/user-account/functionality.dart';
import 'package:needlinc/needlinc/needlinc-variables/colors.dart';
import 'package:needlinc/needlinc/widgets/snack-bar.dart';

import '../functions/decompose-strings.dart';

class UserAccount {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String uid;
  int millisecondsSinceEpoch = DateTime.now().millisecondsSinceEpoch;

  UserAccount(this.uid);

  Future<void> updateUserProfile(
      {required BuildContext context,
        required String fullName,
        required String userName,
        required String email,
        required String profilePicture,
        required String userID}) async {
    try {
      // Use the provided uid for the user
      final User? user = _auth.currentUser;
      addProfilePictureUrl(url: profilePicture);
      // Update user data in Firestore
      await _firestore.collection('users').doc(user!.uid).set({
        'fullName': fullName ?? "",
        'userName': userName ?? "",
        'email': email ?? "",
        'profilePicture': profilePicture ?? "",
        'userId': userID ?? "",
        'userCategory': '',
        'status': "unVerified",
        'notifications': [],
        'reviews': [],
        'averagePoint': 0.0,
        'timeStamp': millisecondsSinceEpoch ?? "",
        'dbTimeStamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      showSnackBar(context, 'Ooops!!!', 'Error $e', NeedlincColors.red);
    }
  }

  Future<bool> updateUserCompleteProfile() async {
    try {
      // Use the provided uid for the user
      final User? user = _auth.currentUser;

      //Getting the stored profile data from local storage to upload to firebasefirestore
      String? userCategory = await getUserData('userCategory');
      String? userName =  await getUserData('userName');
      String? address =  await getUserData('address');
      String? skillSet =  await getUserData('skillSet');
      String? businessName =  await getUserData('businessName');

      if (userCategory == 'Freelancer') {

        final userDataMap = {
          'gender': await getUserData('gender') ?? "",
          'profileOption': await getUserData('profileOption') ?? "",
          'birthDay': await getUserData('birthDay') ?? "",
          'address': await getUserData('address') ?? "",
          'status': "unVerified",
          'phoneNumber': await getUserData('phoneNumber') ?? "",
          'userCategory': await getUserData('userCategory') ?? "",
          'skillSet': await getUserData('skillSet') ?? "",
          'businessName': "",
          'searchIndex': combineWords(
                userName.toString().toLowerCase(),
            address.toString().toLowerCase(),
            '${userCategory.toString().toLowerCase()} ${skillSet.toString().toLowerCase()}',
          )

        };
        // Update user data in Firestore
        await _firestore.collection('users').doc(user!.uid).update(userDataMap);
      } else if (userCategory == 'Business') {
        final userDataMap = {
          'gender': await getUserData('gender') ?? "",
          'profileOption': await getUserData('profileOption') ?? "",
          'birthDay': await getUserData('birthDay') ?? "",
          'address': await getUserData('address') ?? "",
          'status': "unVerified",
          'phoneNumber': await getUserData('phoneNumber') ?? "",
          'userCategory': await getUserData('userCategory') ?? "",
          'skillSet': "",
          'businessName': await getUserData('businessName') ?? "",
          'searchIndex': combineWords(
            userName.toString().toLowerCase(),
            address.toString().toLowerCase(),
            '${userCategory.toString().toLowerCase()} ${businessName.toString().toLowerCase()}',
          )
        };
        // Update user data in Firestore
        await _firestore.collection('users').doc(user!.uid).update(userDataMap);
      } else {
        final userDataMap = {
          'gender': await getUserData('gender') ?? "",
          'profileOption': await getUserData('profileOption') ?? "",
          'birthDay': await getUserData('birthDay') ?? "",
          'address': await getUserData('address') ?? "",
          'status': "unVerified",
          'phoneNumber': await getUserData('phoneNumber') ?? "",
          'userCategory': await getUserData('userCategory') ?? "",
          'skillSet': "",
          'businessName': "",
          'searchIndex': combineWords(
            userName.toString().toLowerCase(),
            address.toString().toLowerCase(),
            userCategory.toString().toLowerCase(),
          )
        };
        // Update user data in Firestore
        await _firestore.collection('users').doc(user!.uid).update(userDataMap);
      }
      print('User profile updated successfully!');
      return true;
    } catch (e) {
      print('Error updating user profile: $e');
      return false;
    }
  }

  Future<void> editProfileWithOutPicture({
    required BuildContext context,
    required String userCategory,
    required String fullName,
    required String userName,
    required String email,
    required String bio,
    required String address,
    required String phoneNumber,
    required String skillSet,
    required String businessName,
  }) async {
    try {
      // Use the provided uid for the user
      final User? user = _auth.currentUser;

      if (userCategory == 'Freelancer') {
        final userDataMap = {
          'fullName': fullName ?? "",
          'userName': userName.toLowerCase() ?? "",
          'email': email ?? "",
          'bio': bio ?? "",
          'address': address ?? "",
          'phoneNumber': phoneNumber ?? "",
          'userCategory': userCategory ?? "",
          'skillSet': skillSet ?? "",
          'businessName': "",
          'searchIndex': combineWords(
            userName.toString().toLowerCase(),
            address.toString().toLowerCase(),
            '${userCategory.toString().toLowerCase()} ${skillSet.toString().toLowerCase()}',
          )
        };
        // Update user data in Firestore
        await _firestore.collection('users').doc(user!.uid).update(userDataMap);
      } else if (userCategory == 'Business') {
        final userDataMap = {
          'fullName': fullName ?? "",
          'userName': userName.toLowerCase() ?? "",
          'email': email ?? "",
          'bio': bio ?? "",
          'address': address ?? "",
          'phoneNumber': phoneNumber ?? "",
          'userCategory': userCategory ?? "",
          'skillSet': "",
          'businessName': businessName ?? "",
          'searchIndex': combineWords(
            userName.toString().toLowerCase(),
            address.toString().toLowerCase(),
            '${userCategory.toString().toLowerCase()} ${businessName.toString().toLowerCase()}',
          )
        };
        // Update user data in Firestore
        await _firestore.collection('users').doc(user!.uid).update(userDataMap);
      } else {
        final userDataMap = {
          'fullName': fullName ?? "",
          'userName': userName.toLowerCase() ?? "",
          'email': email ?? "",
          'bio': bio ?? "",
          'address': address ?? "",
          'phoneNumber': phoneNumber ?? "",
          'userCategory': userCategory ?? "",
          'skillSet': "",
          'businessName': "",
          'searchIndex': combineWords(
            userName.toString().toLowerCase(),
            address.toString().toLowerCase(),
            userCategory.toString().toLowerCase(),
          )
        };
        // Update user data in Firestore
        await _firestore.collection('users').doc(user!.uid).update(userDataMap);
      }

      showSnackBar(
          context, 'Confirmed!', "Profile update is successful", Colors.green);
    } catch (e) {
      showSnackBar(context, 'Ooops!!!', 'Error $e', NeedlincColors.red);
    }
  }

  Future<void> editProfileWithPicture({
    required BuildContext context,
    required Uint8List? profilePicture,
    required String userCategory,
    required String profilePictureUrl,
    required String fullName,
    required String userName,
    required String email,
    required String bio,
    required String address,
    required String phoneNumber,
    required String skillSet,
    required String businessName,
  }) async {
    try {
      // Use the provided uid for the user
      final User? user = _auth.currentUser;

      if (profilePicture!.isNotEmpty) {
        deleteProfilePicture(profilePictureUrl);
        profilePictureUrl = await uploadProfilePicture(profilePicture!);
        addProfilePictureUrl(url: profilePictureUrl);
      }

      if (userCategory == 'Freelancer') {
        final userDataMap = {
          'fullName': fullName ?? "",
          'userName': userName.toLowerCase() ?? "",
          'email': email ?? "",
          'bio': bio ?? "",
          'profilePicture': profilePictureUrl ?? "",
          'address': address ?? "",
          'phoneNumber': phoneNumber ?? "",
          'userCategory': userCategory ?? "",
          'skillSet': skillSet ?? "",
          'businessName': "",
          'searchIndex': combineWords(
            userName.toString().toLowerCase(),
            address.toString().toLowerCase(),
            '${userCategory.toString().toLowerCase()} ${skillSet.toString().toLowerCase()}',
          )
        };
        // Update user data in Firestore
        await _firestore.collection('users').doc(user!.uid).update(userDataMap);
      } else if (userCategory == 'Business') {
        final userDataMap = {
          'fullName': fullName ?? "",
          'userName': userName.toLowerCase() ?? "",
          'email': email ?? "",
          'bio': bio ?? "",
          'profilePicture': profilePictureUrl ?? "",
          'address': address ?? "",
          'phoneNumber': phoneNumber ?? "",
          'userCategory': userCategory ?? "",
          'skillSet': "",
          'businessName': businessName ?? "",
          'searchIndex': combineWords(
            userName.toString().toLowerCase(),
            address.toString().toLowerCase(),
            '${userCategory.toString().toLowerCase()} ${businessName.toString().toLowerCase()}',
          )
        };
        // Update user data in Firestore
        await _firestore.collection('users').doc(user!.uid).update(userDataMap);
      } else {
        final userDataMap = {
          'fullName': fullName ?? "",
          'userName': userName.toLowerCase() ?? "",
          'email': email ?? "",
          'bio': bio ?? "",
          'profilePicture': profilePictureUrl ?? "",
          'address': address ?? "",
          'phoneNumber': phoneNumber ?? "",
          'userCategory': userCategory ?? "",
          'skillSet': "",
          'businessName': "",
          'searchIndex': combineWords(
            userName.toString().toLowerCase(),
            address.toString().toLowerCase(),
            userCategory.toString().toLowerCase(),
          )
        };
        // Update user data in Firestore
        await _firestore.collection('users').doc(user!.uid).update(userDataMap);
      }

      showSnackBar(
          context, 'Confirmed!', "Profile update is successful", Colors.green);
    } catch (e) {
      showSnackBar(context, 'Ooops!!!', 'Error $e', NeedlincColors.red);
    }
  }
}