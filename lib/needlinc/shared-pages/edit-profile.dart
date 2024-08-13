import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:needlinc/needlinc/backend/user-account/functionality.dart';
import 'package:needlinc/needlinc/backend/user-account/user-online-information.dart';
import '../backend/user-account/edit-user-posts.dart';
import '../needlinc-variables/colors.dart';
import '../widgets/TextFieldBorder.dart';
import 'auth-pages/welcome.dart';
import 'construction.dart';

class editProfile extends StatefulWidget {
  String profilePictureUrl;
  String fullName;
  String userName;
  String email;
  String bio;
  String location;
  String phoneNumber;
  String userCategory;
  String skillSet;
  String businessName;

  editProfile({
    super.key,
    required this.profilePictureUrl,
    required this.fullName,
    required this.userName,
    required this.email,
    required this.bio,
    required this.location,
    required this.phoneNumber,
    required this.userCategory,
    required this.skillSet,
    required this.businessName,
  });

  @override
  State<editProfile> createState() => _editProfileState();
}

class _editProfileState extends State<editProfile> {
  Uint8List? profilePicture;
  bool pickPhoto = false;
  //This modal shows image selection either from gallery or camera
  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
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
                    leading: const Icon(
                      Icons.photo_library,
                    ),
                    title: const Text(
                      'Gallery',
                      style: TextStyle(),
                    ),
                    onTap: () {
                      _selectFile(true);
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(
                    Icons.photo_camera,
                  ),
                  title: const Text(
                    'Camera',
                    style: TextStyle(),
                  ),
                  onTap: () {
                    _selectFile(false);
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

  Future _selectFile(bool imageFrom) async {
    try {
      XFile? imageFile = await ImagePicker().pickImage(
          source: imageFrom ? ImageSource.gallery : ImageSource.camera);
      if (imageFile != null) {
        profilePicture = await imageFile.readAsBytes();
        pickPhoto = true;
        setState(() {});
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Failed to select image: $e');
      }
    }
  }

  // Create a global key that uniquely identifies the Form widget
  final _formField = GlobalKey<FormState>();

  TextEditingController profilePictureUrlController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController skillSet = TextEditingController();
  TextEditingController businessName = TextEditingController();

  @override
  void initState() {
    // Initialize controllers with previous data (replace with your actual data)
    profilePictureUrlController.text = widget.profilePictureUrl;
    fullNameController.text = widget.fullName;
    userNameController.text = widget.userName;
    phoneNumberController.text = widget.phoneNumber.toString().substring(4);
    bioController.text = widget.bio;
    emailController.text = widget.email;
    locationController.text = widget.location;
    skillSet.text = widget.skillSet;
    businessName.text = widget.businessName;

    super.initState();
  }

  List<DateTime?> _selectedDates = [DateTime.now()];
  List<DateTime?>? selectADate;
  bool changeDOB = false;
  bool loading = false;

  void _handleDateSelection(List<DateTime?> selectedDates) {
    setState(() {
      selectADate = _selectedDates;
      _selectedDates =
          selectedDates; // Hide the calendar after a date is selected
    });
  }

  void showCalendar() {
    setState(() {
      changeDOB = true;
    });
  }

  void hideCalendar() {
    setState(() {
      changeDOB = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: NeedlincColors.blue1),
        backgroundColor: NeedlincColors.white,
        leading: InkWell(
          onTap: () {
            if (changeDOB == false) {
              Navigator.pop(context);
            }
            hideCalendar();
          },
          child: const Icon(Icons.arrow_back_ios_new),
        ),
        title: const Text(
          'Leave',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 15,
          ),
        ),
        elevation: 0,
        // actions: [
        //   InkWell(
        //     onTap: () {
        //       showDialog(
        //         context: context,
        //         builder: (context) => const Construction(),
        //       );
        //     },
        //     child: Container(
        //       margin: const EdgeInsets.only(right: 10.0),
        //       child: const Icon(Icons.more_vert),
        //     ),
        //   ),
        // ],
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users') // Replace with your collection name
                      .doc(FirebaseAuth.instance.currentUser!
                          .uid) // Replace with your document ID
                      .snapshots(),
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Center(child: Text("Something went wrong"));
                    }
                    if (snapshot.connectionState == ConnectionState.active ||
                        snapshot.connectionState == ConnectionState.done) {
                      var userData =
                          snapshot.data?.data() as Map<String, dynamic>;
                      return Padding(
                        padding: const EdgeInsets.all(15),
                        child: changeDOB
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 100),
                                  Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          20.0), // Adjust the border radius as needed
                                    ),
                                    elevation:
                                        4.0, // Add elevation for a shadow effect
                                    child: Column(
                                      children: [
                                        CalendarDatePicker2(
                                          config: CalendarDatePicker2Config(),
                                          value: _selectedDates,
                                          onValueChanged: _handleDateSelection,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  ElevatedButton(
                                    onPressed: () {
                                      // Close the edit profile page
                                      if (changeDOB == false) {
                                        Navigator.pop(context);
                                      }
                                      hideCalendar();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      backgroundColor: NeedlincColors.blue1,
                                      padding: const EdgeInsets.all(16),
                                    ),
                                    child: const Text(
                                      'Save',
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Form(
                                key: _formField,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Profile Photo
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Stack(
                                          alignment: Alignment.bottomRight,
                                          children: [
                                            Container(
                                              width: 180,
                                              height: 180,
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                              ),
                                              child: profilePicture == null
                                                  ? Container(
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                            image: NetworkImage(
                                                                profilePictureUrlController
                                                                    .text),
                                                            opacity: 0.5,
                                                            fit: BoxFit.cover),
                                                      ),
                                                    )
                                                  : CircleAvatar(
                                                      radius: 60,
                                                      backgroundImage:
                                                          MemoryImage(
                                                              profilePicture!),
                                                      foregroundColor:
                                                          NeedlincColors.grey
                                                              .withOpacity(0.5),
                                                    ),
                                            ),
                                            Container(
                                              width: 45,
                                              height: 45,
                                              margin: const EdgeInsets.only(
                                                  right: 10),
                                              decoration: BoxDecoration(
                                                color: NeedlincColors.blue1,
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: NeedlincColors.white,
                                                  width: 5,
                                                ),
                                              ),
                                              child: InkWell(
                                                onTap: () {
                                                  _showPicker(context);
                                                },
                                                child: const Icon(Icons.add,
                                                    size: 35,
                                                    weight: 50,
                                                    color:
                                                        NeedlincColors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    //Todo Full Name
                                    TextFormField(
                                      controller: fullNameController,
                                      maxLength: 30,
                                      keyboardType: TextInputType.name,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Field cannot be empty";
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        label: const Text('Full Name'),
                                        hintText: "${userData['fullName']}",
                                        focusedBorder: Borders.FocusedBorder,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    //Todo user Name
                                    TextFormField(
                                      controller: userNameController,
                                      maxLength: 30,
                                      keyboardType: TextInputType.name,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Field cannot be empty";
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        label: const Text('User Name'),
                                        hintText: "${userData['userName']}",
                                        focusedBorder: Borders.FocusedBorder,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    //Todo Phone Number
                                    TextFormField(
                                      controller: phoneNumberController,
                                      maxLength: 10,
                                      keyboardType: TextInputType.phone,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Field cannot be empty";
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        label: const Text('+234'),
                                        hintText: "${userData['phoneNumber']}",
                                        focusedBorder: Borders.FocusedBorder,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    if(userData['userCategory'] == 'Freelancer'
                                    ||
                                        userData['userCategory'] == 'Business')
                                        //Todo Bio
                                        TextFormField(
                                            controller: bioController,
                                            maxLength: 80,
                                            keyboardType: TextInputType.text,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "Field cannot be empty";
                                              }
                                              return null;
                                            },
                                            decoration: const InputDecoration(
                                              label: Text('What do you want your clients to know about you?'),
                                              focusedBorder:
                                                  Borders.FocusedBorder,
                                            ),
                                          )
                                       else
                                         //Todo Bio
                                        TextFormField(
                                            controller: bioController,
                                          maxLength: 60,
                                            maxLines: 2,
                                            keyboardType: TextInputType.text,
                                            decoration: const InputDecoration(
                                              label: Text('Bio'),
                                              focusedBorder:
                                                  Borders.FocusedBorder,
                                            ),
                                          ),
                                    // const SizedBox(height: 15),
                                    // //Todo Email
                                    // TextFormField(
                                    //   controller: emailController,
                                    //   keyboardType: TextInputType.emailAddress,
                                    //   validator: (value) {
                                    //     if (value!.isEmpty) {
                                    //       return "Field cannot be empty";
                                    //     }
                                    //     return null;
                                    //   },
                                    //   decoration: InputDecoration(
                                    //     label: const Text('Email'),
                                    //     hintText: "${userData['email']}",
                                    //     focusedBorder: Borders.FocusedBorder,
                                    //   ),
                                    // ),
                                    const SizedBox(height: 10),
                                    //Todo Business / Skill-set
                                    if (userData['userCategory'] ==
                                        'Freelancer')
                                      TextFormField(
                                        controller: skillSet,
                                        keyboardType: TextInputType.text,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Field cannot be empty";
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          label: const Text('Skill Set'),
                                          hintText: "${userData['skillSet']}",
                                          focusedBorder: Borders.FocusedBorder,
                                        ),
                                      )
                                    else if (userData['userCategory'] ==
                                        'Business')
                                      TextFormField(
                                        controller: businessName,
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                          label: const Text('Business Name'),
                                          hintText:
                                              "${userData['businessName']}",
                                          focusedBorder: Borders.FocusedBorder,
                                        ),
                                      )
                                    else
                                      Container(),
                                    const SizedBox(height: 10),
                                    //Todo Location
                                    TextFormField(
                                      controller: locationController,
                                      keyboardType: TextInputType.streetAddress,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Field cannot be empty";
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        label: const Text('Address'),
                                        hintText: "${userData['address']}",
                                        focusedBorder: Borders.FocusedBorder,
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          loading = true;
                                        });
                                        // Add your logic for Client sign-in here
                                        if (_formField.currentState!
                                            .validate()) {
                                          // Save logic goes here
                                          if (pickPhoto) {
                                            UserAccount(userData['userId'])
                                                .editProfileWithPicture(
                                                    context: context,
                                                    profilePicture:
                                                        profilePicture!,
                                                    userCategory: userData[
                                                        'userCategory'],
                                                    profilePictureUrl:
                                                        profilePictureUrlController
                                                            .text,
                                                    fullName:
                                                        fullNameController.text,
                                                    userName:
                                                        userNameController.text,
                                                    email: emailController.text,
                                                    bio: bioController.text,
                                                    address:
                                                        locationController.text,
                                                    phoneNumber:
                                                        "+234${phoneNumberController.text}",
                                                    skillSet: skillSet.text,
                                                    businessName:
                                                        businessName.text)
                                                .whenComplete(() {
                                              updateUserPostsInDatabase()
                                                  .updateUserInformationInDatabasePost(
                                                      userData['userId']);
                                            });
                                            saveUserData('fullName',
                                                fullNameController.text);
                                            saveUserData('userName',
                                                userNameController.text);
                                            saveUserData(
                                                'email', emailController.text);
                                            saveUserData('address',
                                                locationController.text);
                                            saveUserData(
                                                'skillSet', skillSet.text);
                                            saveUserData('businessName',
                                                businessName.text);
                                          } else {
                                            UserAccount(userData['userId'])
                                                .editProfileWithOutPicture(
                                                    context: context,
                                                    userCategory: userData[
                                                        'userCategory'],
                                                    fullName:
                                                        fullNameController.text,
                                                    userName:
                                                        userNameController.text,
                                                    email: emailController.text,
                                                    bio: bioController.text,
                                                    address:
                                                        locationController.text,
                                                    phoneNumber:
                                                        "+234${phoneNumberController.text}",
                                                    skillSet: skillSet.text,
                                                    businessName:
                                                        businessName.text)
                                                .whenComplete(() {
                                              updateUserPostsInDatabase()
                                                  .updateUserInformationInDatabasePost(
                                                      userData['userId']);
                                            });
                                            saveUserData('fullName',
                                                fullNameController.text);
                                            saveUserData('userName',
                                                userNameController.text);
                                            saveUserData(
                                                'email', emailController.text);
                                            saveUserData('address',
                                                locationController.text);
                                            saveUserData(
                                                'skillSet', skillSet.text);
                                            saveUserData('businessName',
                                                businessName.text);
                                          }

                                          Navigator.pop(context);
                                        }
                                        // Close the edit profile page
                                      },
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        backgroundColor: NeedlincColors.blue1,
                                        padding: const EdgeInsets.all(16),
                                      ),
                                      child: const Text(
                                        'Save',
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w700,
                                          color: NeedlincColors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return const WelcomePage();
                  },
                ),
              ),
            ),
    );
  }
}
