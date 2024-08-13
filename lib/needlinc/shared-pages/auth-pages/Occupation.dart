import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:needlinc/needlinc/widgets/login-background.dart';
import 'package:needlinc/needlinc/widgets/snack-bar.dart';
import '../../backend/user-account/functionality.dart';
import '../../backend/user-account/user-online-information.dart';
import '../../business-pages/business-main.dart';
import '../../needlinc-variables/colors.dart';
import '../../widgets/TextFieldBorder.dart';

class Occupation extends StatefulWidget {
  const Occupation({super.key});

  @override
  State<Occupation> createState() => _OccupationState();
}

class _OccupationState extends State<Occupation> {
  final occupations = [
    'Barber',
    'Carpenter',
    'Electrician',
    'Forex Trader',
    'Generator Repairer',
    'Graphics Designer',
    'Hairdresser',
    'Laptop Repairer',
    'Makeup artist',
    'Mechanic',
    'Phone Repairer',
    'Plumber',
    'Refrigerator Repairer',
    'Shoe Maker',
    'Software Developer',
    'Tailor',
    'Other',
  ];

  String? selectedOccupation; // Variable to store the value

  // Controller for the 'Other' text field
  final TextEditingController _otherOccupationController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeedlincColors.white,
      appBar: AppBar(
        backgroundColor: NeedlincColors.blue1,
        foregroundColor: NeedlincColors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
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
        child: Stack(
          children: [
            const backGround(),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  // DropdownButtonFormField for predefined occupations
                  Container(
                    height: 38,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: NeedlincColors.white,
                      border: Border.all(),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        value: selectedOccupation,
                        isExpanded: true,
                        hint: const Text('What do you do for a living?'),
                        items: occupations.map(occupationList).toList(),
                        onChanged: (value) {
                          setState(() => selectedOccupation = value);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  // Text field for 'Other' occupation
                  if (selectedOccupation == 'Other')
                    SizedBox(
                      height: 38,
                      child: TextFormField(
                        controller: _otherOccupationController,
                        decoration: const InputDecoration(
                            labelText: 'Enter Other Occupation',
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 8.0),
                            focusedBorder: Borders.FocusedBorder,
                            enabledBorder: Borders.EnabledBorder,
                            filled: true,
                            fillColor: NeedlincColors.white),
                        onFieldSubmitted: (value) {
                          setState(() => selectedOccupation = value);
                          // Add the entered occupation to the list
                          if (!occupations.contains(value)) {
                            occupations.insert(occupations.length - 1, value);
                          }
                        },
                      ),
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
                          if (selectedOccupation!.isNotEmpty ||
                              _otherOccupationController.text.isNotEmpty) {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>BusinessMainPages(currentPage: 0)),
                                        (route) => false);
                            selectedOccupation!.toLowerCase() != 'other'
                                ? addSkillSet(
                                    skillSet: selectedOccupation!.toLowerCase())
                                : addSkillSet(
                                    skillSet: _otherOccupationController.text
                                        .toLowerCase());
                          } else {
                            showSnackBar(context, 'Ooops!!!', "Enter a skill",
                                NeedlincColors.red);
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
                            color: Colors.white
                          ),
                        ),
                      ),
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

  DropdownMenuItem occupationList(String work) => DropdownMenuItem(
        value: work,
        child: Text(
          work,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
      );
}
