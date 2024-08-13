import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<void> signUpWithGoogle() async {
  try {
    // Initialize Firebase
    await Firebase.initializeApp();

    // Initialize Google Sign-In
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      // Obtain the GoogleSignInAuthentication object
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

      // Create a new credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      // Sign in to Firebase with the Google credentials
      await FirebaseAuth.instance.signInWithCredential(credential);

      // User signed in
      print('User signed in with Google!');
    } else {
      // Handle sign-in failure
      throw ('Google sign-in failed!');
    }
  } catch (e) {
    throw ('Error signing up with Google: $e');
  }
}