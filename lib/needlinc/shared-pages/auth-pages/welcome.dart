import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:needlinc/needlinc/needlinc-variables/colors.dart';
import 'package:needlinc/needlinc/shared-pages/auth-pages/intro-page.dart';
import '../../widgets/page-transition.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool shouldStartSecondAnimation = false;

  @override
  void initState() {
    // implement initState
    super.initState();
    // Set a delay to navigate to the second screen after 7 seconds
    Future.delayed(
      const Duration(seconds: 7),
      () => Navigator.pushReplacement(
          context, SizeTransition2(const WelcomePage2())),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: NeedlincColors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedTextKit(
              pause: const Duration(milliseconds: 500),
              animatedTexts: [
                TypewriterAnimatedText(
                  'NEEDLINC',
                  speed: const Duration(milliseconds: 150),
                  textStyle: const TextStyle(
                    color: NeedlincColors.blue1,
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
              isRepeatingAnimation: false,
              onFinished: () {
                // Start the second animation after the first one is finished
                setState(() {
                  shouldStartSecondAnimation = true;
                });
              },
            ),
            SizedBox(height: screenHeight * 0.08),
            Container(
              width: screenHeight,
              height: screenHeight * 0.4,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage("assets/Logo.png"),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.08),
            if (shouldStartSecondAnimation)
              AnimatedTextKit(
                pause: const Duration(milliseconds: 500),
                animatedTexts: [
                  TypewriterAnimatedText(
                    'Search, Seek, Find',
                    speed: const Duration(milliseconds: 150),
                    textStyle: const TextStyle(
                      color: NeedlincColors.blue1,
                      fontSize: 22,
                    ),
                  ),
                ],
                isRepeatingAnimation: false,
              ),
          ],
        ),
      ),
    );
  }
}
