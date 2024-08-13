import 'package:flutter/material.dart';
import 'package:needlinc/needlinc/needlinc-variables/colors.dart';
import 'package:needlinc/needlinc/shared-pages/auth-pages/sign-in.dart';
import 'package:needlinc/needlinc/widgets/login-background.dart';

import '../../widgets/page-transition.dart';

class WelcomePage2 extends StatefulWidget {
  const WelcomePage2({super.key});

  @override
  State<WelcomePage2> createState() => _WelcomePage2State();
}

class _WelcomePage2State extends State<WelcomePage2> {
  bool showNext = false;
  double small = 15, big = 19;
  final activeColor = NeedlincColors.blue1, inactiveColor = NeedlincColors.grey;

  void _showNext() {
    setState(() {
      showNext = true;
    });
  }

  void _hideNext() {
    setState(() {
      showNext = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: NeedlincColors.white,
      body: SafeArea(
        child: GestureDetector(
          onHorizontalDragEnd: (details) {
            // Check if the user swiped left or right
            if (details.primaryVelocity! > 0) {
              _hideNext();
            } else {
              _showNext();
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Stack(
                // Tripple Layer
                children: [
                  const backGround(),
                  Container(
                    height: 260,
                    padding: const EdgeInsets.only(left: 40, right: 40),
                    alignment: Alignment.center,
                    child: !showNext
                        ? RichText(
                            textAlign: TextAlign.center,
                            text: const TextSpan(
                              text: 'NEEDLINC ',
                              style: TextStyle(
                                  fontSize: 19, color: NeedlincColors.white),
                              children: [
                                TextSpan(
                                  text:
                                      'connects all FUTO students to freelancers or workers who are nearby',
                                  style: TextStyle(
                                      fontSize: 19,
                                      color: NeedlincColors.white,
                                      fontFamily: 'Comfortaa-Regular'),
                                )
                              ],
                            ),
                          )
                        : const Text(
                            'We provide a secure, safe and fast environment for both artisians and students',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 19,
                              color: NeedlincColors.white,
                              fontFamily: 'Comfortaa-Regular',
                            ),
                          ),
                  ),
                  SizedBox(height: screenHeight * 0.09),
                ],
              ),
              // NeedLinc image
              Container(
                width: screenWidth * 0.7,
                height: screenHeight * 0.35,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage("assets/Logo.png"),
                  ),
                ),
              ),
              Column(
                children: [
                  // Next button
                  if (showNext)
                    Container(
                      alignment: Alignment.bottomRight,
                      margin: const EdgeInsets.only(right: 20),
                      child: ElevatedButton(
                        onPressed: () => Navigator.pushReplacement(
                            context, SizeTransition5(const SignupPage())),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: NeedlincColors.blue1,
                          padding: const EdgeInsets.all(12),
                        ),
                        child: const Text(
                          "NEXT",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: NeedlincColors.white),
                        ),
                      ),
                    ),
                  // Little circles below
                  Container(
                    padding: const EdgeInsets.fromLTRB(30, 5, 30, 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: _hideNext,
                          child: Container(
                            width: showNext ? small : big,
                            height: showNext ? small : big,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: showNext ? inactiveColor : activeColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4.0),
                        GestureDetector(
                          onTap: _showNext,
                          child: Container(
                            width: showNext ? big : small,
                            height: showNext ? big : small,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: showNext ? activeColor : inactiveColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
