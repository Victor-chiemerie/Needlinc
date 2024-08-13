import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../needlinc-variables/colors.dart';

class HelpAction extends StatelessWidget {
  const HelpAction({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(10.0),
          child: const Center(
            child: Text(
                "There is a problem with your account, try creating a new account again or reaching us via needlinc@gmail.com to help you out, we want to see that you have no problem trying to use needlinc to meet your needs, thank you."),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.of(context)
                .pushNamedAndRemoveUntil('//', (route) => false);
            FirebaseAuth.instance.currentUser!.delete();
          },
          child: Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: NeedlincColors.blue1)),
            child: const Text("Go back"),
          ),
        )
      ],
    );
  }
}
