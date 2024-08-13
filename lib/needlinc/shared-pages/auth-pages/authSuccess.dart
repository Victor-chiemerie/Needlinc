import 'package:flutter/material.dart';
import 'package:needlinc/needlinc/shared-pages/auth-pages/EnterApp.dart';
import 'package:needlinc/needlinc/widgets/login-background.dart';
import '../../needlinc-variables/colors.dart';

class Success extends StatefulWidget {
  const Success({super.key});

  @override
  State<Success> createState() => _SuccessState();
}

class _SuccessState extends State<Success> {
  @override
  void initState() {
    super.initState();
    // Set a delay to navigate to the second screen after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const CategoryPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: NeedlincColors.blue1,
        foregroundColor: NeedlincColors.white,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'NEEDLINC',
          style: TextStyle(
            fontSize: 12,
          ),
        ),
        elevation: 0,
      ),
      body: const SafeArea(
        child: Stack(
          children: [
            backGround(),
            Padding(
              padding: EdgeInsets.fromLTRB(25, 20, 25, 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 70),
                  // Successful message
                  Text(
                    'You have Successfully created your Needlinc account',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
