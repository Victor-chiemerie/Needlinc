import 'package:flutter/material.dart';
import 'package:needlinc/needlinc/shared-pages/auth-pages/sign-in.dart';
import '../../needlinc-variables/colors.dart';

class VerificationSMS extends StatefulWidget {
  const VerificationSMS({super.key});

  @override
  State<VerificationSMS> createState() => _VerificationSMSState();
}

class _VerificationSMSState extends State<VerificationSMS> {
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
            size: 28, // Adjust the icon size as needed
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
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 50, 20, 60),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Check your email for your reset password link',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: NeedlincColors.blue1,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignupPage()));
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: NeedlincColors.blue1,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  child: const Text(
                    "Go back",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
