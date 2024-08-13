import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:needlinc/needlinc/needlinc-variables/colors.dart';
import 'package:needlinc/needlinc/shared-pages/auth-pages/gender.dart';
import 'package:needlinc/needlinc/widgets/TextFieldBorder.dart';
import 'package:needlinc/needlinc/widgets/login-background.dart';
import 'package:needlinc/needlinc/widgets/snack-bar.dart';
import '../../backend/authentication/sign-up.dart';
import '../../backend/functions/check-email.dart';
import '../../backend/functions/check-user-name.dart';
import '../../widgets/page-transition.dart';
import '../user-type.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  bool addPhoto = false;
  bool notLoading = true;
  Uint8List? profilePicture;

  String saveUserInformation() {
    // Storing data in local storage
    SignUp(
      context,
      fullNameController.text.trim(),
      userNameController.text.trim(),
      emailController.text,
      passwordController.text.trim(),
      profilePicture!)
  .signUpWithEmailPassword();
  return 'Success';
}

  void _showAddPhoto() {
    setState(() {
      addPhoto = true;
    });
  }

  void _hideAddPhoto() {
    setState(() {
      addPhoto = false;
    });
  }

  final _formField = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final fullNameController = TextEditingController();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPassController = TextEditingController();

  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();
  final FocusNode _focusNode4 = FocusNode();
  final FocusNode _focusNode5 = FocusNode();
  bool confirmToggle = true;
  bool viewPassword = true;

  //This modal shows image selection either from gallery or camera
  void _showPicker(BuildContext context) {
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
        setState(() {});
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Failed to select image: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: NeedlincColors.blue1,
        foregroundColor: NeedlincColors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            if (addPhoto == false) {
              Navigator.pop(context);
            }
            _hideAddPhoto();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new, // Specify the icon you want to use
            size: 30, // Adjust the icon size as needed
          ),
        ),
        centerTitle: true,
        title: addPhoto
            ? const Text(
                'NEEDLINC',
                style: TextStyle(
                  fontSize: 12,
                ),
              )
            : null,
        actions: [
          if (addPhoto)
            TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const UserType()));
              },
              child: const Text(
                '',
                style: TextStyle(
                  fontSize: 16,
                  color: NeedlincColors.white,
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: notLoading
            ? SingleChildScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                child: Stack(
                  children: [
                    const backGround(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
                      child: Column(
                        children: [
                          const SizedBox(height: 40),
                          // main Card
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                addPhoto ? 'Add Profile photo' : 'NEEDLINC',
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w400,
                                  color: NeedlincColors.white,
                                ),
                              ),
                              // body
                              const SizedBox(height: 10),
                              if (!addPhoto)
                                Container(
                                  width: double.infinity,
                                  padding:
                                      const EdgeInsets.fromLTRB(27, 28, 27, 24),
                                  decoration: BoxDecoration(
                                    color: NeedlincColors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: NeedlincColors.grey,
                                        offset: Offset(0, 3),
                                        blurRadius: 3.0,
                                        spreadRadius: 1.0,
                                      )
                                    ],
                                  ),
                                  child: Form(
                                    key: _formField,
                                    autovalidateMode: AutovalidateMode.always,
                                    child: Column(
                                      children: [
                                        // Create New Account
                                        const Text(
                                          'Create New Account',
                                          style: TextStyle(
                                            fontSize: 23,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        // Enter Full Name
                                        TextFormField(
                                          controller: fullNameController,
                                          focusNode: _focusNode1,
                                          onEditingComplete: () {
                                            _fieldFocusChange(context,
                                                _focusNode1, _focusNode2);
                                          },
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Enter full name";
                                            }
                                            return null;
                                          },
                                          decoration: const InputDecoration(
                                            hintText: 'Enter Full Name',
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 8.0),
                                            focusedBorder:
                                                Borders.FocusedBorder,
                                            enabledBorder:
                                                Borders.EnabledBorder,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        // Enter User Name
                                        TextFormField(
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          controller: userNameController,
                                          focusNode: _focusNode2,
                                          onEditingComplete: () {
                                            _fieldFocusChange(context,
                                                _focusNode2, _focusNode3);
                                          },
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Enter Username";
                                            }
                                            return null;
                                          },
                                          decoration: const InputDecoration(
                                            hintText: 'Enter User Name',
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 8.0),
                                            focusedBorder:
                                                Borders.FocusedBorder,
                                            enabledBorder:
                                                Borders.EnabledBorder,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        // Email
                                        TextFormField(
                                          controller: emailController,
                                          focusNode: _focusNode3,
                                          onEditingComplete: () {
                                            _fieldFocusChange(context,
                                                _focusNode3, _focusNode4);
                                          },
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          validator: (value) {
                                            bool emailValid = RegExp(
                                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                                .hasMatch(value!);

                                            if (value.isEmpty) {
                                              return "Enter Email";
                                            } else if (!emailValid) {
                                              return "Enter Valid Email";
                                            }

                                            return null;
                                          },
                                          decoration: const InputDecoration(
                                            hintText: 'Email',
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 8.0),
                                            focusedBorder:
                                                Borders.FocusedBorder,
                                            enabledBorder:
                                                Borders.EnabledBorder,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        // Create Password
                                        TextFormField(
                                          obscureText: viewPassword,
                                          controller: passwordController,
                                          focusNode: _focusNode4,
                                          onEditingComplete: () {
                                            _fieldFocusChange(context,
                                                _focusNode4, _focusNode5);
                                          },
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Enter Password";
                                            } else if (passwordController
                                                    .text.length <
                                                8) {
                                              return "Password must be more than 8 characters";
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                            suffix: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  viewPassword = !viewPassword;
                                                });
                                              },
                                              child: Icon(viewPassword
                                                  ? Icons.visibility_off
                                                  : Icons.visibility),
                                            ),
                                            hintText: 'Create Password',
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 8.0),
                                            focusedBorder:
                                                Borders.FocusedBorder,
                                            enabledBorder:
                                                Borders.EnabledBorder,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        // Confirm Password
                                        TextFormField(
                                          obscureText: confirmToggle,
                                          controller: confirmPassController,
                                          focusNode: _focusNode5,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "confirm Password";
                                            } else if (confirmPassController
                                                    .text !=
                                                passwordController.text) {
                                              return "Passwords not match";
                                            }
                                            return null;
                                          },
                                          onEditingComplete: () {
                                            if (_formField.currentState!
                                                .validate()) {
                                              _showAddPhoto();
                                            }
                                          },
                                          decoration: InputDecoration(
                                            suffix: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  confirmToggle =
                                                      !confirmToggle;
                                                });
                                              },
                                              child: Icon(confirmToggle
                                                  ? Icons.visibility_off
                                                  : Icons.visibility),
                                            ),
                                            hintText: 'Confirm Password',
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 8.0),
                                            focusedBorder:
                                                Borders.FocusedBorder,
                                            enabledBorder:
                                                Borders.EnabledBorder,
                                          ),
                                        ),
                                        const SizedBox(height: 17),
                                        // create new account button
                                        ElevatedButton(
                                          onPressed: () async {
                                            if (_formField.currentState!
                                                .validate()) {
                                              if (await checkUserEmailExistence(emailController.text)){
                                              if (await checkUserNameAccess(userNameController.text))
                                              {
                                                _showAddPhoto();
                                              } else {
                                                showSnackBar(
                                                    context,
                                                    'Ooops!!!',
                                                    'This user name is already in use',
                                                    NeedlincColors.red);
                                              }
                                              }
                                              else{
                                                showSnackBar(
                                                    context,
                                                    'Ooops!!!',
                                                    'This email has been used to create an account already',
                                                    NeedlincColors.red);
                                              }
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                NeedlincColors.blue1,
                                            fixedSize: const Size(
                                                double.maxFinite, 30),
                                            shape: const BeveledRectangleBorder(
                                              borderRadius: BorderRadius.zero,
                                            ),
                                          ),
                                          child:
                                              const Text(
                                                'Create New Account',
                                                style: TextStyle(color: Colors.white),
                                                ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              // picture container
                              if (addPhoto)
                                Stack(
                                    alignment: Alignment.bottomRight,
                                    children: [
                                      Container(
                                          height: 210,
                                          width: 210,
                                          decoration: const BoxDecoration(
                                            color: NeedlincColors.white,
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: NeedlincColors.grey,
                                                offset: Offset(0, 3),
                                                blurRadius: 3.0,
                                                spreadRadius: 1.0,
                                              )
                                            ],
                                          ),
                                          child: profilePicture == null
                                              ? Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                    image: DecorationImage(
                                                      fit: BoxFit.fill,
                                                      image: AssetImage(
                                                          "assets/default.png"),
                                                    ),
                                                    shape: BoxShape.circle,
                                                  ),
                                                )
                                              : CircleAvatar(
                                                  radius: 60,
                                                  backgroundImage: MemoryImage(
                                                      profilePicture!),
                                                )),
                                      Container(
                                        margin:
                                            const EdgeInsets.only(right: 30),
                                        width: 45,
                                        height: 45,
                                        decoration: BoxDecoration(
                                          color: NeedlincColors.blue1,
                                          borderRadius:
                                              BorderRadius.circular(28),
                                          border: Border.all(
                                            color: NeedlincColors.white,
                                            width: 5,
                                          ),
                                        ),
                                        child: Align(
                                          child: InkWell(
                                            onTap: () {
                                              _showPicker(context);
                                            },
                                            child: const Icon(Icons.add,
                                                size: 35,
                                                weight: 50,
                                                color: NeedlincColors.white),
                                          ),
                                        ),
                                      ),
                                    ])
                            ],
                          ),
                          // Next button
                          const SizedBox(height: 270),
                          if (addPhoto)
                            Container(
                              alignment: Alignment.bottomRight,
                              padding:
                                  const EdgeInsets.only(right: 15, bottom: 55),
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (profilePicture != null) {
                                    notLoading = false;
                                    setState(() {});
                                    saveUserInformation();
                                    Navigator.push(context,
                                        SizeTransition5(const Gender()));
                                    notLoading = true;
                                    emailController.clear();
                                    fullNameController.clear();
                                    userNameController.clear();
                                    passwordController.clear();
                                    confirmPassController.clear();
                                  } else {
                                    showSnackBar(
                                        context,
                                        'Hold on!!!',
                                        "Add a photo for this account",
                                        NeedlincColors.red);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  backgroundColor: NeedlincColors.blue1,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                ),
                                child: const Text(
                                  'NEXT',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }

  void _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
