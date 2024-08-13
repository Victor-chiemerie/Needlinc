import 'package:flutter/material.dart';
import 'package:needlinc/needlinc/shared-pages/auth-pages/verification_SMS.dart';
import 'package:needlinc/needlinc/widgets/snack-bar.dart';

import '../../backend/authentication/login.dart';
import '../../needlinc-variables/colors.dart';
import '../../widgets/TextFieldBorder.dart';

class ForgotPass extends StatefulWidget {
  const ForgotPass({super.key});

  @override
  State<ForgotPass> createState() => _ForgotPassState();
}

TextEditingController emailController = TextEditingController();

class _ForgotPassState extends State<ForgotPass> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeedlincColors.white,
      appBar: AppBar(
        foregroundColor: NeedlincColors.blue1,
        backgroundColor: NeedlincColors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new, // Specify the icon you want to use
            size: 27, // Adjust the icon size as needed
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            child: Column(
              children: [
                const Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: NeedlincColors.blue1,
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Please enter the email address associated with your account',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  height: 35,
                  child: TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email Address',
                      contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                      focusedBorder: Borders.FocusedBorder,
                      enabledBorder: Borders.EnabledBorder,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    if (emailController.text.isNotEmpty) {
                      resetPassword(
                          context: context, Email: emailController.text);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const VerificationSMS()));
                    }
                    else {
                      showSnackBar(context, 'Warning!!', "Email field is empty",
                          const Color.fromARGB(255, 248, 179, 75));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: NeedlincColors.blue1,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                  ),
                  child: const Text(
                    "NEXT",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
