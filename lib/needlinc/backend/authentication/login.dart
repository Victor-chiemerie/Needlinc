import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:needlinc/needlinc/backend/user-account/functionality.dart';
import 'package:needlinc/needlinc/needlinc-variables/colors.dart';
import '../../shared-pages/user-type.dart';
import '../../widgets/snack-bar.dart';

FirebaseAuth _auth = FirebaseAuth.instance;
Future<User?> loginUser(
    String email, String password, BuildContext context) async {
  try {
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential.user!.uid)
        .get();

    if (userSnapshot.exists) {
      // The user document exists in Firestore.
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const UserType(),
        ),
      );

      saveUserData('address', await userSnapshot['address']);
      saveUserData('fullName', await userSnapshot['fullName']);
      saveUserData('profilePicture', await userSnapshot['profilePicture']);
      saveUserData('userCategory', await userSnapshot['userCategory']);
      saveUserData('userId', await userSnapshot['userId']);
      saveUserData('userName', await userSnapshot['userName']);
      saveUserData('skillSet', await userSnapshot['skillSet']);
      saveUserData('businessName', await userSnapshot['businessName']);

      showSnackBar(context, 'Hi !!!', 'Welcome back!', Colors.green);
    } else {
      // The user document does not exist in Firestore.
      const Center(
        child: Text(
            "We are sorry, try reloading or check your internet connection"),
      );
    }

    return userCredential.user!;
  } catch (e) {
    showSnackBar(
        context, 'Ooops!!!', 'Error logging in: $e', NeedlincColors.red);
    Container(
      padding: const EdgeInsets.all(10.0),
      child: const Center(
        child: Text(
            "There is a problem with your account, try reaching us via needlinc@gmail.com to help you out, we want to see that you have no problem trying to use needlinc to meet your needs, thank you...!"),
      ),
    );
    return null; // Handle the error as needed
  }
}

Future<void> resetPassword(
    {required BuildContext context, required String Email}) async {
  try {
    if (Email != null) {
      _auth.sendPasswordResetEmail(email: Email);
      showSnackBar(context, 'Confirm!',
          "Reset Password request has been sent to this E-mail", Colors.green);
    }
  } on FirebaseException catch (error) {
    showSnackBar(context, 'Ooops!!!', error.message!, NeedlincColors.red);
  }
}
  