import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:needlinc/needlinc/needlinc-variables/colors.dart';
import 'dart:typed_data';
import '../../widgets/snack-bar.dart';
import '../user-account/functionality.dart';
import '../user-account/user-online-information.dart';

class SignUp {
  final String fullName;
  final String userName;
  final String email;
  final String password;
  final Uint8List profilePicture;
  final BuildContext context;

  SignUp(this.context, this.fullName, this.userName, this.email, this.password,
      this.profilePicture);
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool?> signUpWithEmailPassword() async {
    try {
      bool firstResponse = false;
      bool secondResponse = false;
      String? profilePictureUrl;

      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .whenComplete(() {
        firstResponse = true;
      });

      if (firstResponse) {
        profilePictureUrl =
        await uploadProfilePicture(profilePicture).whenComplete(() {
          secondResponse = true;
        });
      }

      if (secondResponse) {
        UserAccount(userCredential.user!.uid)
            .updateUserProfile(
          context: context,
          fullName: fullName,
          userName: userName.toLowerCase(),
          email: email,
          profilePicture: profilePictureUrl!,
          userID: userCredential.user!.uid,
        )
            .whenComplete(() {
          saveUserData('profilePicture', profilePictureUrl!);
          saveUserData('fullName', fullName);
          saveUserData('userName', userName.toLowerCase());
          saveUserData('email', email);
          saveUserData('password', password);

          // You can add more logic here to save additional user information to the database, like full name, nickname, and profile picture.
        });
      }

      //Verify new users e-mail
      await sendEmailVerificationMessage(context);

      return true;
    } catch (e) {
      return false;
    }
  }

//   Future<UserCredential?> signUpWithFacebook() async {
//     try {
//       final LoginResult result = await FacebookAuth.instance.login(permissions: ["email"]);
//
//       if (result.status == LoginStatus.success) {
//         final AuthCredential credential = FacebookAuthProvider.credential(result.accessToken!.token);
//
//         UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
//
//         // You can add more logic here to save additional user information to the database, like full name, nickname, and profile picture.
//
//         return userCredential;
//       } else {
//         print("Error signing up with Facebook: ${result.status}");
//         return null;
//       }
//     } catch (e) {
//       print("Error signing up with Facebook: $e");
//       return null;
//     }
//   }

  //Email Verification Function (This is the function that sends the user a mail to verify his/her e-mail on the mechatronics platform)
  Future<void> sendEmailVerificationMessage(BuildContext context) async {
    try {
      _auth.currentUser!.sendEmailVerification();
    } on FirebaseException catch (error) {
      showSnackBar(context, 'Ooops!!!', error.message!, NeedlincColors.red);
    }
  }
}