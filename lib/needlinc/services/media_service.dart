import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:random_string/random_string.dart';

import '../backend/functions/image-compression-rate.dart';
import '../backend/user-account/functionality.dart';

class MediaService {
  Future<Uint8List?> showImageSourceActionSheet(BuildContext context) async {
    Completer<Uint8List?> completer = Completer();
    _showPicker(context, completer);
    return completer.future;
  }

  void _showPicker(BuildContext context, Completer<Uint8List?> completer) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.15,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            child: Wrap(
              children: [
                const SizedBox(height: 10),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Gallery'),
                  onTap: () async {
                    Uint8List? file = await _selectFile(true);
                    completer.complete(file);
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () async {
                    Uint8List? file = await _selectFile(false);
                    completer.complete(file);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<Uint8List?> _selectFile(bool imageFromGallery) async {
    try {
      final ImagePicker picker = ImagePicker();
      XFile? imageFile = await picker.pickImage(
        source: imageFromGallery ? ImageSource.gallery : ImageSource.camera,
      );
      if (imageFile != null) {
        return await imageFile.readAsBytes();
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Failed to select image: $e');
      }
    }
    return null;
  }

// Todo upload chat photo to FirebaseStorage
  Future<String> uploadChatPicture(Uint8List imageBytes) async {
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

      // Return the download URL
      return imageUrl;
    } catch (error) {
      // Handle errors
      return 'Error uploading image to Firebase Storage: $error';
    }
  }
}
