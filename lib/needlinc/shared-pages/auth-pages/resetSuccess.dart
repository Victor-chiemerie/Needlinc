import 'package:flutter/material.dart';
import 'package:needlinc/needlinc/shared-pages/auth-pages/sign-in.dart';

import '../../needlinc-variables/colors.dart';

class ResetSuccess extends StatefulWidget {
  const ResetSuccess({super.key});

  @override
  State<ResetSuccess> createState() => _ResetSuccessState();
}

class _ResetSuccessState extends State<ResetSuccess> {
  @override
  void initState() {
    // implement initState
    super.initState();
    // Set a delay to navigate to the second screen after 2.2 seconds
    Future.delayed(const Duration(milliseconds: 2300), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const SignupPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeedlincColors.white,
      appBar: AppBar(
        foregroundColor: NeedlincColors.blue1,
        backgroundColor: NeedlincColors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'NEEDLINC',
          style: TextStyle(
            fontSize: 12,
          ),
        ),
      ),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 50, 20, 60),
          child: Text(
            'You have successfully confirmed your Email',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: NeedlincColors.blue1,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
