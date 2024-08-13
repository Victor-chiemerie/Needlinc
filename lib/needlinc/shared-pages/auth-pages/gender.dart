import 'package:flutter/material.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:needlinc/needlinc/shared-pages/auth-pages/location.dart';
import '../../backend/user-account/functionality.dart';
import '../../needlinc-variables/colors.dart';
import '../../widgets/login-background.dart';
import '../../widgets/page-transition.dart';
import '../user-type.dart';

class Gender extends StatefulWidget {
  const Gender({super.key});

  @override
  State<Gender> createState() => _GenderState();
}

class _GenderState extends State<Gender> {
  bool addBirth = false;
  bool isMale = false, isFemale = false, showOnProfile = false;
  String genderValue = ''; // Initialize genderValue as an empty string
  List<DateTime?> _selectedDates = [DateTime.now()];
  List<DateTime?>? selectADate;

  void _handleDateSelection(List<DateTime?> selectedDates) {
    setState(() {
      selectADate = _selectedDates;
      _selectedDates = selectedDates;
    });
  }

  void _getSelectedDates() {
    final dateOfBirth = _selectedDates
        .map((date) => date?.toString().substring(0, 10) ?? 'null')
        .join(', ');
    getDateOfBirth(birthDay: dateOfBirth);
  }

  void maleCheck(bool? newValue) {
    setState(() {
      isMale = newValue ?? false;
      if (isMale) {
        isFemale = false; // Unselect female if male is selected
        genderValue = 'male'; // Set genderValue to 'male'
      } else {
        genderValue = ''; // Reset genderValue if male is unselected
      }
      getGender(gender: genderValue);
    });
  }

  void femaleCheck(bool? newValue) {
    setState(() {
      isFemale = newValue ?? false;
      if (isFemale) {
        isMale = false; // Unselect male if female is selected
        genderValue = 'female'; // Set genderValue to 'female'
      } else {
        genderValue = ''; // Reset genderValue if female is unselected
      }
      getGender(gender: genderValue);
    });
  }

  void _showAddBirth() {
    setState(() {
      addBirth = true;
    });
  }

  void _hideAddBirth() {
    setState(() {
      addBirth = false;
    });
  }

  void showOnProfileCheck(bool? newValue) {
    setState(() {
      showOnProfile = newValue ?? false;
      displayProfileOption(profileOption: showOnProfile);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: NeedlincColors.blue1,
        foregroundColor: NeedlincColors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            if (addBirth == false) {
              Navigator.pop(context);
            }
            _hideAddBirth();
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
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const UserType()));
            },
            child: const Text(
              '',
              style: TextStyle(
                fontSize: 16,
                color: NeedlincColors.white,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          child: Stack(
            children: [
              const backGround(),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
                child: Column(
                  children: [
                    const SizedBox(height: 55),
                    // main Card
                    Column(
                      children: [
                        // Card title
                        Text(
                          addBirth ? 'Add Date of Birth' : 'Choose Your Gender',
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w400,
                            color: NeedlincColors.white,
                          ),
                        ),
                        // body
                        const SizedBox(height: 15),
                        if (!addBirth)
                          Container(
                            width: double.infinity,
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
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(15.0, 28, 15, 30),
                              child: Column(
                                // choose Gender
                                children: [
                                  // Male
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: isMale ? true : false,
                                        onChanged: maleCheck,
                                        visualDensity: const VisualDensity(
                                            horizontal: -1, vertical: -1),
                                      ),
                                      const Text(
                                        'Male',
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ],
                                  ),
                                  // Female
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: isFemale ? true : false,
                                        onChanged: femaleCheck,
                                        visualDensity: const VisualDensity(
                                            horizontal: -1, vertical: -1),
                                      ),
                                      const Text(
                                        'Female',
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        // Add Date of Birth container
                        if (addBirth)
                          Column(
                            children: [
                              Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      20.0), // Adjust the border radius as needed
                                ),
                                elevation:
                                    4.0, // Add elevation for a shadow effect
                                child: Column(
                                  children: [
                                    CalendarDatePicker2(
                                      config: CalendarDatePicker2Config(),
                                      value: _selectedDates,
                                      onValueChanged: _handleDateSelection,
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  Checkbox(
                                    value: showOnProfile ? true : false,
                                    onChanged: showOnProfileCheck,
                                    visualDensity: const VisualDensity(
                                        horizontal: -1, vertical: -3),
                                  ),
                                  const Text('Show on profile'),
                                ],
                              ),
                            ],
                          )
                      ],
                    ),
                    if (!addBirth)
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.45),
                    if (addBirth)
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.113),
                    // Next button
                    Container(
                      alignment: Alignment.bottomRight,
                      padding: const EdgeInsets.only(right: 15),
                      child: ElevatedButton(
                        onPressed: () {
                          if (addBirth == true) {
                            _getSelectedDates();
                            Navigator.push(
                                context, SizeTransition5(const Location()));
                          }
                          _showAddBirth();
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
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
