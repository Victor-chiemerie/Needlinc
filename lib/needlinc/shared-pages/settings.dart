import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:needlinc/needlinc/needlinc-variables/colors.dart';
import 'package:needlinc/needlinc/backend/authentication/delete-account.dart';
import '../backend/user-account/functionality.dart';
import 'construction.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  bool _isSwitched = false;
  bool _isSwitched1 = true;
  bool _isSwitched2 = true;
  bool _isSwitched3 = true;
  bool _isSwitched4 = true;
  bool _isSwitched5 = false;
  bool _isSwitched6 = false;
  bool _isSwitched7 = false;
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double Height = screenSize.height;
    double Width = screenSize.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            }),
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue,
        title: const Text(
          "Settings",
          style: TextStyle(
            //color: Colors.blue,
            fontSize: 14,
          ),
        ),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: Height * 0.03),
              const Text("Display",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700)),
              SizedBox(height: Height * 0.005),
              Center(
                child: Container(
                    padding: const EdgeInsets.all(3.0),
                    width: Width * 0.95,
                    height: Height * 0.055,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      border: Border.all(
                        color: NeedlincColors.blue2,
                        width: 2.0,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Switch Themes"),
                        Switch(
                          value: _isSwitched,
                          onChanged: (value) {
                            setState(() {
                              _isSwitched = value;
                            });
                          },
                        )
                      ],
                    )),
              ),
              SizedBox(height: Height * 0.03),
              const Text("Notifications",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700)),
              SizedBox(height: Height * 0.005),
              Center(
                  child: Container(
                      padding: const EdgeInsets.all(3.0),
                      width: Width * 0.95,
                      height: Height * 0.055,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        border: Border.all(
                          color: NeedlincColors.blue2,
                          width: 2.0,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Allow Notifications"),
                          Switch(
                            value: _isSwitched1,
                            onChanged: (value) {
                              setState(() {
                                _isSwitched1 = value;
                              });
                            },
                          )
                        ],
                      ))),
              SizedBox(height: Height * 0.004),
              Center(
                child: Container(
                    padding: const EdgeInsets.all(3.0),
                    width: Width * 0.95,
                    height: Height * 0.055,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      border: Border.all(
                        color: NeedlincColors.blue2,
                        width: 2.0,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Chat Notifications"),
                        Switch(
                          value: _isSwitched2,
                          onChanged: (value) {
                            setState(() {
                              _isSwitched2 = value;
                            });
                          },
                        )
                      ],
                    )),
              ),
              SizedBox(height: Height * 0.004),
              Center(
                child: Container(
                    padding: const EdgeInsets.all(3.0),
                    width: Width * 0.95,
                    height: Height * 0.055,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      border: Border.all(
                        color: NeedlincColors.blue2,
                        width: 2.0,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Booking Notifications"),
                        Switch(
                          value: _isSwitched3,
                          onChanged: (value) {
                            setState(() {
                              _isSwitched3 = value;
                            });
                          },
                        )
                      ],
                    )),
              ),
              SizedBox(height: Height * 0.004),
              Center(
                  child: Container(
                      padding: const EdgeInsets.all(3.0),
                      width: Width * 0.95,
                      height: Height * 0.055,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        border: Border.all(
                          color: NeedlincColors.blue2,
                          width: 2.0,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Enable Push Notitfications"),
                          Switch(
                            value: _isSwitched4,
                            onChanged: (value) {
                              setState(() {
                                _isSwitched4 = value;
                              });
                            },
                          )
                        ],
                      ))),
              SizedBox(height: Height * 0.03),
              const Text("App Permissons",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700)),
              const Text(
                  "This allows you to control which permissions on the app"),
              Center(
                  child: Container(
                      padding: const EdgeInsets.all(3.0),
                      width: Width * 0.95,
                      height: Height * 0.055,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        border: Border.all(
                          color: NeedlincColors.blue2,
                          width: 2.0,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Contacts"),
                          Switch(
                            value: _isSwitched5,
                            onChanged: (value) {
                              setState(() {
                                _isSwitched5 = value;
                              });
                            },
                          )
                        ],
                      ))),
              Center(
                  child: Container(
                      padding: const EdgeInsets.all(3.0),
                      width: Width * 0.95,
                      height: Height * 0.055,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        border: Border.all(
                          color: NeedlincColors.blue2,
                          width: 2.0,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Photos"),
                          Switch(
                            value: _isSwitched6,
                            onChanged: (value) {
                              setState(() {
                                _isSwitched6 = value;
                              });
                            },
                          )
                        ],
                      ))),
              Center(
                  child: Container(
                      padding: const EdgeInsets.all(3.0),
                      width: Width * 0.95,
                      height: Height * 0.055,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        border: Border.all(
                          color: NeedlincColors.blue2,
                          width: 2.0,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Location"),
                          Switch(
                            value: _isSwitched7,
                            onChanged: (value) {
                              setState(() {
                                _isSwitched7 = value;
                              });
                            },
                          )
                        ],
                      ))),
              SizedBox(height: Height * 0.03),
              const Text("Account",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700)),
              SizedBox(height: Height * 0.005),
              // Center(
              //   child: Container(
              //       padding: const EdgeInsets.only(left: 4),
              //       width: Width * 0.95,
              //       height: Height * 0.0552,
              //       decoration: BoxDecoration(
              //         shape: BoxShape.rectangle,
              //         border: Border.all(
              //           color: NeedlincColors.blue2,
              //           width: 2.0,
              //         ),
              //       ),
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           const Text("Change Password"),
              //           IconButton(
              //             icon: const Icon(Icons.arrow_forward_ios,
              //                 size: 13, color: NeedlincColors.blue2),
              //             onPressed: () {
              //               showDialog(
              //                 context: context,
              //                 builder: (context) => const Construction(),
              //               );
              //             },
              //           ),
              //         ],
              //       )),
              // ),
              // Center(
              //   child: Container(
              //       padding: const EdgeInsets.all(3.0),
              //       width: Width * 0.95,
              //       height: Height * 0.0552,
              //       decoration: BoxDecoration(
              //         shape: BoxShape.rectangle,
              //         border: Border.all(
              //           color: NeedlincColors.blue2,
              //           width: 2.0,
              //         ),
              //       ),
              //       child: TextButton(
              //         onPressed: () {
              //           showDialog(
              //             context: context,
              //             builder: (context) => const Construction(),
              //           );
              //         },
              //         child: const Row(
              //           children: [
              //             Text(
              //               "Deactivate account",
              //               style: TextStyle(color: Colors.black),
              //             ),
              //           ],
              //         ),
              //       )),
              // ),
              // SizedBox(
              //   height: Height * 0.02,
              // ),
              // Center(
              //   child: Container(
              //       padding: const EdgeInsets.only(left: 4),
              //       width: Width * 0.95,
              //       height: Height * 0.0552,
              //       decoration: BoxDecoration(
              //         shape: BoxShape.rectangle,
              //         border: Border.all(
              //           color: NeedlincColors.blue2,
              //           width: 2.0,
              //         ),
              //       ),
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           const Text("Upgrade to Professional Account"),
              //           IconButton(
              //             icon: const Icon(Icons.arrow_forward_ios,
              //                 size: 13, color: NeedlincColors.blue2),
              //             onPressed: () {
              //               showDialog(
              //                 context: context,
              //                 builder: (context) => const Construction(),
              //               );
              //             },
              //           ),
              //         ],
              //       )),
              // ),
              // SizedBox(height: Height * 0.02),
              // Center(
              //   child: Container(
              //       width: Width * 0.95,
              //       height: Height * 0.0552,
              //       padding: const EdgeInsets.all(3.0),
              //       decoration: BoxDecoration(
              //         shape: BoxShape.rectangle,
              //         border: Border.all(
              //           color: NeedlincColors.blue2,
              //           width: 2.0,
              //         ),
              //       ),
              //       child: TextButton(
              //         onPressed: () {
              //           showDialog(
              //             context: context,
              //             builder: (context) => const Construction(),
              //           );
              //         },
              //         child: const Row(
              //           mainAxisAlignment: MainAxisAlignment.start,
              //           children: [
              //             Icon(Icons.thumb_up_outlined, color: Colors.black),
              //             Text(
              //               "Leave Feedback",
              //               style: TextStyle(color: Colors.black),
              //             ),
              //           ],
              //         ),
              //       )),
              // ),
              // SizedBox(height: Height * 0.02),
              Center(
                  child: Container(
                      padding: const EdgeInsets.all(3.0),
                      width: Width * 0.95,
                      height: Height * 0.0552,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        border:
                            Border.all(color: NeedlincColors.blue2, width: 2.0),
                      ),
                      child: TextButton(
                        onPressed: () {
                          showDialog<void>(
                            context: context,
                            barrierDismissible: false, // user must tap button!
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Delete Account permanently'),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      Text(
                                          'Do you want to proceed with this action?'),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('Yes'),
                                    onPressed: () {
                                      ManageAccount()
                                          .deleteThisUserAccount(userId);
                                      ManageAccount()
                                          .deleteProfilePicture(userId);
                                      Navigator.of(context)
                                          .pushNamedAndRemoveUntil(
                                              '//', (route) => false);
                                    },
                                  ),
                                  TextButton(
                                    child: Text('No'),
                                    onPressed: () {
                                      // Perform action when user selects "No"
                                      Navigator.of(context).pop(
                                          false); // Close dialog and return false
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: const Text(
                          "Delete Account",
                          style: TextStyle(color: Colors.red),
                        ),
                      )))
            ],
          ),
        ),
      ),
    );
  }
}
