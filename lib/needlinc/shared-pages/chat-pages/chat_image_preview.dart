import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:needlinc/needlinc/needlinc-variables/colors.dart';
import 'package:needlinc/needlinc/services/media_service.dart';

class ImagePreviewScreen extends StatefulWidget {
  final Uint8List imageData;

  ImagePreviewScreen({
    required this.imageData,
  });

  @override
  State<ImagePreviewScreen> createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends State<ImagePreviewScreen> {
  final MediaService mediaService = MediaService();
  String imageUrl = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeedlincColors.black1,
      // appBar: AppBar(
      //   title: Text('Preview Image'),
      // ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Image.memory(widget.imageData),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: NeedlincColors.blue1),
                  onPressed: () {
                    // Go back to chat page
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: NeedlincColors.white),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: NeedlincColors.blue1),
                  onPressed: () async {
                    // Send to firebase
                    imageUrl =
                        await mediaService.uploadChatPicture(widget.imageData);
                    // Go back to chat page
                    Navigator.pop(context, imageUrl);
                  },
                  child: Text(
                    'Confirm',
                    style: TextStyle(color: NeedlincColors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
