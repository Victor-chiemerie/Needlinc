import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../functions/image-compression-rate.dart';

// Storing data in local storage
Future<void> saveUserData(String key, String value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(key, value);
}

// Retrieving data from local storage
Future<String?> getUserData(String key) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}

// Removing data from local storage
Future<void> removeUserData(String key) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove(key);
}

Future<void> getGender({
  required String gender,
}) async {
  // Add user gender info in local storage
  saveUserData('gender', gender);
}

Future<void> displayProfileOption({
  required bool profileOption,
}) async {
  // Add user data in local storage
  saveUserData('profileOption', '$profileOption');
}

Future<void> getDateOfBirth({
  required String birthDay,
}) async {
  // Add user birth day date in local storage
  saveUserData('birthDay', birthDay);
}

Future<void> addLocation({
  required String location,
}) async {
  // Add user birth day date in local storage
  saveUserData('address', location);
}

Future<void> addPhoneNumber({
  required String phoneNumber,
}) async {
  // Add user birth day date in local storage
  saveUserData('phoneNumber', phoneNumber);
}

Future<void> addProfilePictureUrl({
  required String url,
}) async {
  // Add user birth day date in local storage
  saveUserData('profilePicture', url);
}

Future<void> userCategory({
  required BuildContext context,
  required String userType,
}) async {
  // Add user birth day date in local storage
  saveUserData('userCategory', userType);
}

Future<void> addSkillSet({
  required String skillSet,
}) async {
  // Add user birth day date in local storage
  saveUserData('skillSet', skillSet);
}

Future<void> addBusinessName({
  required String businessName,
}) async {
  // Add user birth day date in local storage
  saveUserData('businessName', businessName);
}

Future<void> addIsoCode({
  required String businessName,
}) async {
  // Add user birth day date in local storage
  saveUserData('businessName', businessName);
}

// Todo upload Profile Picture to FirebaseStorage
Future<String> uploadProfilePicture(Uint8List imageBytes) async {
  try {
    // Set metadata for the image
    firebase_storage.SettableMetadata metadata =
    firebase_storage.SettableMetadata(
      contentType: 'image/jpeg', // Change this to the appropriate content type
      // You can set other metadata properties here if needed
    );

    int quality = 85;
    // Check if the image quality is already below a certain threshold
    if (shouldCompress(imageBytes)) {
      int compressedFileSize = estimateCompressedFileSize(imageBytes);
      while (imageBytes.lengthInBytes > compressedFileSize) {
        // Compress the image
        imageBytes = await FlutterImageCompress.compressWithList(
          imageBytes,
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
    FirebaseStorage.instance.ref().child('profilePictures/${randomUrl}');

    // Upload the compressed image data
    final UploadTask uploadTask = storageRef.putData(imageBytes, metadata);

    // Wait for the upload to complete
    await uploadTask;

    // Retrieve the download URL for the compressed image
    final imageUrl = await storageRef.getDownloadURL();

    addProfilePictureUrl(url: imageUrl);
    // Return the download URL
    return imageUrl;
  } catch (error) {
    // Handle errors
    return 'Error uploading image to Firebase Storage: $error';
  }
}

// Function to determine whether compression is needed based on image quality
bool shouldCompress(Uint8List imageBytes) {
  // Replace these thresholds with your own criteria

  int maxAllowedFileSize = 999 * 1024; // 500 KB

  // Check file size
  bool fileSizeExceedThreshold =
  imageBytes.length > maxAllowedFileSize ? true : false;

  return fileSizeExceedThreshold;
}

//Todo Delete Profile Picture from FirebaseStorage
Future<String> deleteProfilePicture(String imageUrl) async {
  try {
    final Reference storageRef = FirebaseStorage.instance.refFromURL(imageUrl);
    await storageRef.delete();

    return 'Image successfully deleted from Firebase Storage';
  } catch (error) {
    return 'Error deleting image from Firebase Storage: $error';
  }
}