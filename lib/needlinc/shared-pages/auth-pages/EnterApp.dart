import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:needlinc/needlinc/backend/user-account/functionality.dart';
import 'package:needlinc/needlinc/backend/user-account/user-online-information.dart';
import 'package:needlinc/needlinc/client-pages/client-main.dart';
import 'package:needlinc/needlinc/shared-pages/auth-pages/Occupation.dart';
import 'package:needlinc/needlinc/widgets/login-background.dart';
import '../../needlinc-variables/colors.dart';
import 'BizNameAndExp.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  String categtory = "User";
  double mainWidth = 150, activeWidth = 156;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: NeedlincColors.blue1,
        foregroundColor: NeedlincColors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'NEEDLINC',
          style: TextStyle(
            fontSize: 12,
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            const backGround(),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  const Text(
                    'Choose your category',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w400,
                      color: NeedlincColors.white,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // User
                          InkWell(
                            onTap: () {
                              setState(() {
                                categtory = "User";
                              });
                              userCategory(
                                  context: context, userType: categtory);
                            },
                            child: Stack(
                              children: [
                                Container(
                                  width: (categtory == "User")
                                      ? activeWidth
                                      : mainWidth,
                                  height: (categtory == "User")
                                      ? activeWidth
                                      : mainWidth,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: NeedlincColors.white,
                                    border: Border.all(
                                      width: 2,
                                      color: (categtory == "User")
                                          ? NeedlincColors.blue1
                                          : NeedlincColors.blue3,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Text(
                                    'I am a user',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: NeedlincColors.blue1,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Icon(
                                    Icons.circle,
                                    color: (categtory == "User")
                                        ? NeedlincColors.blue1
                                        : NeedlincColors.white,
                                  ),
                                )
                              ],
                            ),
                          ),
                          // Freelancer
                          InkWell(
                            onTap: () {
                              setState(() {
                                categtory = "Freelancer";
                              });
                              userCategory(
                                  context: context, userType: categtory);
                            },
                            child: Stack(
                              children: [
                                Container(
                                  width: (categtory == "Freelancer")
                                      ? activeWidth
                                      : mainWidth,
                                  height: (categtory == "Freelancer")
                                      ? activeWidth
                                      : mainWidth,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: NeedlincColors.white,
                                    border: Border.all(
                                      width: 2,
                                      color: (categtory == "Freelancer")
                                          ? NeedlincColors.blue1
                                          : NeedlincColors.blue3,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Text(
                                    'I offer services',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: NeedlincColors.blue1,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Icon(
                                    Icons.circle,
                                    color: (categtory == "Freelancer")
                                        ? NeedlincColors.blue1
                                        : NeedlincColors.white,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Business
                          InkWell(
                            onTap: () {
                              setState(() {
                                categtory = "Business";
                              });
                              userCategory(
                                  context: context, userType: categtory);
                            },
                            child: Stack(
                              children: [
                                Container(
                                  width: (categtory == "Business")
                                      ? activeWidth
                                      : mainWidth,
                                  height: (categtory == "Business")
                                      ? activeWidth
                                      : mainWidth,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: NeedlincColors.white,
                                    border: Border.all(
                                      width: 2,
                                      color: (categtory == "Business")
                                          ? NeedlincColors.blue1
                                          : NeedlincColors.blue3,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Text(
                                    'I sell products',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: NeedlincColors.blue1,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Icon(
                                    Icons.circle,
                                    color: (categtory == "Business")
                                        ? NeedlincColors.blue1
                                        : NeedlincColors.white,
                                  ),
                                )
                              ],
                            ),
                          ),
                          // Blogger
                          InkWell(
                            onTap: () {
                              setState(() {
                                categtory = "Blogger";
                              });
                              userCategory(
                                  context: context, userType: categtory);
                            },
                            child: Stack(
                              children: [
                                Container(
                                  width: (categtory == "Blogger")
                                      ? activeWidth
                                      : mainWidth,
                                  height: (categtory == "Blogger")
                                      ? activeWidth
                                      : mainWidth,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: NeedlincColors.white,
                                    border: Border.all(
                                      width: 2,
                                      color: (categtory == "Blogger")
                                          ? NeedlincColors.blue1
                                          : NeedlincColors.blue3,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Text(
                                    'News & Media',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: NeedlincColors.blue1,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Icon(
                                    Icons.circle,
                                    color: (categtory == "Blogger")
                                        ? NeedlincColors.blue1
                                        : NeedlincColors.white,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Next button
                  Expanded(
                    child: Container(
                      alignment: Alignment.bottomRight,
                      padding: const EdgeInsets.only(right: 15, bottom: 55),
                      child: ElevatedButton(
                        onPressed: () {
                          UserAccount(FirebaseAuth.instance.currentUser!.uid)
                              .updateUserCompleteProfile();
                          switch (categtory) {
                            case 'User':
                              {
                                userCategory(
                                    context: context, userType: 'User');
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>ClientMainPages(currentPage: 0)),
                                        (route) => false
                                            );
                              }
                              break;
                            case 'Freelancer':
                              {
                                userCategory(
                                    context: context, userType: 'Freelancer');
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const Occupation()),
                                            (route) => false);
                              }
                              break;
                            case 'Business':
                              {
                                userCategory(
                                    context: context, userType: 'Business');
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (context) => const BizNameAndExp()),
                                  (route) => false,
                                );
  
                              }
                              break;
                            case 'Blogger':
                              {
                                userCategory(
                                    context: context, userType: 'Blogger');
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ClientMainPages(currentPage: 0)),
                                        (route) => false
                                           );
                              }
                              break;
                            default:
                              {}
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
