import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:needlinc/needlinc/widgets/login-background.dart';
import 'package:needlinc/needlinc/widgets/snack-bar.dart';
import '../../backend/user-account/functionality.dart';
import '../../backend/user-account/user-online-information.dart';
import '../../business-pages/business-main.dart';
import '../../needlinc-variables/colors.dart';
import '../../widgets/TextFieldBorder.dart';

class BizNameAndExp extends StatefulWidget {
  const BizNameAndExp({super.key});

  @override
  State<BizNameAndExp> createState() => _BizNameAndExpState();
}

class _BizNameAndExpState extends State<BizNameAndExp> {
  // Controller for the 'Other' text field
  final TextEditingController _businessName = TextEditingController();

  bool isExperience = false;

  void showExperience() {
    setState(() {
      isExperience = true;
    });
  }

  void hideExperience() {
    setState(() {
      isExperience = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeedlincColors.white,
      appBar: AppBar(
        backgroundColor: NeedlincColors.blue1,
        foregroundColor: NeedlincColors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            if (isExperience == false) {
              Navigator.pop(context);
            }
            hideExperience();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new, // Specify the icon you want to use
            size: 30, // Adjust the icon size as needed
          ),
        ),
        centerTitle: true,
        title: const Text(
          'NEEDLINC',
          style: TextStyle(
            fontSize: 12,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          child: Stack(
            children: [
              const backGround(),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                child: Column(
                  children: [
                    if (isExperience) const SizedBox(height: 45),
                    if (!isExperience)
                      SizedBox(
                        height: 40,
                        child: TextFormField(
                          controller: _businessName,
                          decoration: const InputDecoration(
                            hintText: 'Add the Name of your business',
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 8.0),
                            filled: true,
                            fillColor: NeedlincColors.white,
                            focusedBorder: Borders.FocusedBorder,
                            enabledBorder: Borders.EnabledBorder,
                          ),
                        ),
                      ),
                    if (isExperience)
                      const Text(
                        'How long have you been in this buisness?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: NeedlincColors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w500),
                      ),
                    if (isExperience) const SizedBox(height: 20),
                    if (isExperience)
                      const Text(
                        "What's your experience?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: NeedlincColors.white,
                          fontSize: 14,
                        ),
                      ),
                    if (isExperience) const SizedBox(height: 20),
                    if (isExperience)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
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
                        child: const Row(
                          children: [Text('Started since')],
                        ),
                      ),
                    SizedBox(height: isExperience ? 325 : 520),
                    Container(
                      alignment: Alignment.bottomRight,
                      padding: const EdgeInsets.only(right: 15),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_businessName.text.isNotEmpty) {
                            showSnackBar(context, 'Confirmed!',
                                _businessName.text, Colors.green);
                            addBusinessName(
                                businessName: _businessName.text.toLowerCase());
                            showSnackBar(context, 'Confirmed!',
                                _businessName.text, Colors.green);
                            UserAccount(FirebaseAuth.instance.currentUser!.uid)
                                .updateUserCompleteProfile();
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BusinessMainPages(currentPage: 0)),
                                    (route) => false,
                                        );
                          } else {
                            showSnackBar(context, 'Sorry!!!',
                                'Enter a business name', NeedlincColors.red);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: NeedlincColors.blue1,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
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
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
