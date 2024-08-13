import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:needlinc/needlinc/needlinc-variables/colors.dart';
import '../backend/user-account/upload-post.dart';
import '../widgets/snack-bar.dart';

class HomePostPage extends StatefulWidget {
  const HomePostPage({Key? key}) : super(key: key);

  @override
  State<HomePostPage> createState() => _HomePostPageState();
}

class _HomePostPageState extends State<HomePostPage> {
  List<Uint8List>? imagePosts = [];
  TextEditingController writeUp = TextEditingController();
  bool freelancerOption = false;
  bool notLoading = true;
  String selectedOccupations = "";

  List<String> occupations = [
    "Electrician",
    "Mechanic",
    "Makeup Artist",
    "Plumber",
    "Other",
  ];

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
      showSnackBar(context, 'Ooops!!!', "Failed to select image: $e",
          NeedlincColors.red);
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
                                    hintText: 'Write A Post...',
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
                                hintText: 'Write A Post...',
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
                    // TODO Handle CheckBox
                    Container(
                      alignment: Alignment.topLeft,
                      margin: const EdgeInsets.only(left: 8.0, top: 10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: freelancerOption,
                            onChanged: (bool? newValue) {
                              setState(() {
                                freelancerOption = newValue!;
                              });
                            },
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Notify a freelancer',
                                style: GoogleFonts.oxygen(
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.6,
                                child: const Text(
                                  'This allows your post to directly notify a freelancer who you might need to come work for you.',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: NeedlincColors.black2),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: freelancerOption,
                      child: Container(
                        margin: const EdgeInsets.only(top: 34.5, bottom: 31.4),
                        child: Column(
                          children: [
                            const Text('Select an Occupation::'),
                            const SizedBox(height: 6.0),
                            Wrap(
                              spacing: 8.0,
                              runSpacing: 8.0,
                              children: occupations.map((category) {
                                return ChoiceChip(
                                  label: Text(
                                    category,
                                    style: TextStyle(
                                      color: selectedOccupations == category
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                  selected: selectedOccupations == category,
                                  onSelected: (selected) {
                                    setState(() {
                                      selectedOccupations =
                                          selected ? category : "";
                                    });
                                  },
                                  backgroundColor:
                                      selectedOccupations == category
                                          ? Colors.blue
                                          : null,
                                  selectedColor: NeedlincColors.blue1,
                                );
                              }).toList(),
                            ),
                          ],
                        ),
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
                          if (imagePosts!.length == 0 && writeUp.text.isEmpty) {
                            showSnackBar(context, 'Warning!!', "Empty fields",
                                Color.fromARGB(255, 247, 174, 66));
                            setState(() {
                              notLoading = true;
                            });
                          } else {
                            if (imagePosts!.length > 0 &&
                                writeUp.text.isNotEmpty) {
                              setState(() {
                                notLoading = false;
                              });
                              notLoading = await UploadPost()
                                  .homePagePostForImageAndWriteUp(
                                      context,
                                      imagePosts!,
                                      writeUp.text,
                                      selectedOccupations);
                              Navigator.pop(context);
                            } else if (imagePosts!.length > 0 &&
                                writeUp.text.isEmpty) {
                              notLoading = await UploadPost()
                                  .homePagePostForImage(context, imagePosts!,
                                      selectedOccupations);
                              Navigator.pop(context);
                            } else if (imagePosts!.length == 0 &&
                                writeUp.text.isNotEmpty) {
                              notLoading = await UploadPost()
                                  .homePagePostForWriteUp(context, writeUp.text,
                                      selectedOccupations);
                              Navigator.pop(context);
                            } else {
                              showSnackBar(context, 'Warning', "Empty fields",
                                  Color.fromARGB(255, 247, 174, 66));
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
                              "POST",
                              style: TextStyle(color: Colors.white)
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
