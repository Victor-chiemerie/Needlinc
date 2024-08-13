import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:needlinc/needlinc/needlinc-variables/colors.dart';
import '../backend/user-account/upload-news.dart';
import '../widgets/snack-bar.dart';

class NewsPostPage extends StatefulWidget {
  const NewsPostPage({Key? key}) : super(key: key);

  @override
  State<NewsPostPage> createState() => _NewsPostPageState();
}

class _NewsPostPageState extends State<NewsPostPage> {
  List<Uint8List>? imagePosts = [];
  TextEditingController writeUp = TextEditingController();
  bool notLoading = true;

  Future<void> _selectFile(BuildContext context, bool imageFrom) async {
    try {
      List<Uint8List> imageBytes = [];

      if (imageFrom) {
        XFile? imageFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
        if (imageFile != null) {
          Uint8List singleImageByte = await imageFile.readAsBytes();
          imageBytes.add(singleImageByte);
        }
      } else {
        XFile? imageFile =
            await ImagePicker().pickImage(source: ImageSource.camera);
        if (imageFile != null) {
          Uint8List singleImageByte = await imageFile.readAsBytes();
          imageBytes.add(singleImageByte);
        }
      }

      if (imageBytes.isNotEmpty) {
        imagePosts = imageBytes;
        setState(() {});
      }
    } on PlatformException catch (e) {
      showSnackBar(
          context, 'Snap!!', "Failed to select image: $e", NeedlincColors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: NeedlincColors.white,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: NeedlincColors.black1),
        actions: [
          Container(
              margin: const EdgeInsets.only(top: 15.0, right: 15.0),
              child: Text(
                "",
                style: GoogleFonts.spaceGrotesk(
                  color: NeedlincColors.black1,
                  decoration: TextDecoration.underline,
                ),
              ))
        ],
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.cancel),
        ),
      ),
      body: notLoading
          ? SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Column(
                  children: [
                    // Image display section using Wrap
                    imagePosts != null && imagePosts!.isNotEmpty
                        ? Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(
                                    left: 10.0, bottom: 10.0, right: 10.0),
                                decoration: BoxDecoration(
                                    color: NeedlincColors.black3,
                                    borderRadius: BorderRadius.circular(9.0)),
                                child: TextField(
                                  maxLines: 8,
                                  keyboardType: TextInputType.multiline,
                                  controller: writeUp,
                                  decoration: InputDecoration(
                                    hintText: 'Make an announcement...',
                                    border: const OutlineInputBorder(
                                        borderSide: BorderSide.none),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide:
                                          const BorderSide(color: Colors.blue),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 12.0),
                                  ),
                                  style: const TextStyle(fontSize: 16.0),
                                ),
                              ),
                              Wrap(
                                spacing: 8.0, // Spacing between the images
                                runSpacing: 8.0, // Spacing between the rows
                                children: imagePosts!.map((image) {
                                  return Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.3, // Image width
                                    height: MediaQuery.of(context).size.width *
                                        0.3, // Image height
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: MemoryImage(image),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          )
                        : Container(
                            margin: const EdgeInsets.only(
                                left: 10.0, bottom: 10.0, right: 10.0),
                            decoration: BoxDecoration(
                                color: NeedlincColors.black3,
                                borderRadius: BorderRadius.circular(9.0)),
                            child: TextField(
                              maxLines: 8,
                              keyboardType: TextInputType.multiline,
                              controller: writeUp,
                              decoration: InputDecoration(
                                hintText: 'Make an announcement...',
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide:
                                      const BorderSide(color: Colors.blue),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 12.0),
                              ),
                              style: const TextStyle(fontSize: 16.0),
                            ),
                          ),
                    InkWell(
                      onTap: () {
                        _selectFile(context, false);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 25.0),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(Icons.camera_alt_outlined,
                                color: NeedlincColors.blue2),
                            Text("Take a photo",
                                style: GoogleFonts.oxygen(fontSize: 16)),
                            Container(
                                padding: const EdgeInsets.only(left: 160.0),
                                child: const Icon(
                                    Icons.arrow_forward_ios_rounded)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 320,
                      child: Divider(color: NeedlincColors.black2),
                    ),
                    InkWell(
                      onTap: () {
                        _selectFile(context, true);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(Icons.image_outlined,
                                color: NeedlincColors.blue2),
                            Text("Choose from gallery",
                                style: GoogleFonts.oxygen(fontSize: 16)),
                            Container(
                                padding: const EdgeInsets.only(left: 100.0),
                                child: const Icon(
                                    Icons.arrow_forward_ios_rounded)),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 36.0, bottom: 10.0),
                      alignment: Alignment.bottomRight,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            notLoading = false;
                          });
                          if (imagePosts == null && writeUp.text.isEmpty) {
                            showSnackBar(context, 'Sorry!', "Empty fields",
                                NeedlincColors.red);
                            setState(() {
                              notLoading = true;
                            });
                          } else {
                            if (imagePosts!.isNotEmpty &&
                                writeUp.text.isNotEmpty) {
                              setState(() {
                                notLoading = false;
                              });
                              notLoading = await UploadNews()
                                  .newsPagePostForImageAndWriteUp(
                                      context, imagePosts!, writeUp.text);
                              Navigator.pop(context);
                            } else if (imagePosts!.isNotEmpty &&
                                writeUp.text.isEmpty) {
                              setState(() {
                                notLoading = false;
                              });
                              notLoading = await UploadNews()
                                  .newsPagePostForImage(context, imagePosts!);
                              Navigator.pop(context);
                            } else if (imagePosts!.isEmpty &&
                                writeUp.text.isNotEmpty) {
                              setState(() {
                                notLoading = false;
                              });
                              notLoading = await UploadNews()
                                  .newsPagePostForWriteUp(
                                      context, writeUp.text);
                              Navigator.pop(context);
                            } else {
                              showSnackBar(context, 'Sorry!', "Empty fields",
                                  NeedlincColors.red);
                              setState(() {
                                notLoading = true;
                              });
                            }
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              NeedlincColors.blue1),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: const BorderSide(color: Colors.blue),
                            ),
                          ),
                        ),
                        child: notLoading
                            ? const Text(
                                "Make public",
                                style: TextStyle(color: NeedlincColors.white),
                              )
                            : const CircularProgressIndicator(),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
