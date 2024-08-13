import 'package:flutter/material.dart';
import 'package:needlinc/needlinc/backend/user-account/functionality.dart';
import 'package:needlinc/needlinc/needlinc-variables/colors.dart';
import 'package:needlinc/needlinc/widgets/login-background.dart';
import 'package:phone_form_field/phone_form_field.dart';
import '../../widgets/TextFieldBorder.dart';
import '../../widgets/page-transition.dart';
import '../../widgets/snack-bar.dart';
import 'authSuccess.dart';

class PhoneNumber extends StatefulWidget {
  const PhoneNumber({Key? key}) : super(key: key);

  @override
  State<PhoneNumber> createState() => _PhoneNumberState();
}

class _PhoneNumberState extends State<PhoneNumber> {
  late PhoneController phoneNumberController;

  @override
  void initState() {
    super.initState();
    phoneNumberController = PhoneController();
    phoneNumberController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  // main Card
                  Column(
                    children: [
                      // Card title
                      const Text(
                        'Add Phone Number',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w400,
                          color: NeedlincColors.white,
                        ),
                      ),
                      // body
                      const SizedBox(height: 15),
                      Container(
                        padding: const EdgeInsets.fromLTRB(15, 27, 15, 30),
                        decoration: BoxDecoration(
                          color: NeedlincColors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: NeedlincColors.grey,
                              offset: Offset(0, 3),
                              blurRadius: 3.0,
                              spreadRadius: 1.0,
                            )
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Select Country',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 19),
                            PhoneFormField(
                              //  initialValue: PhoneNumber(isoCode: 'US'),
                              controller: phoneNumberController,
                              defaultCountry: IsoCode.NG,
                              onChanged: (number) {
                                if (number != null) {
                                  addPhoneNumber(
                                      phoneNumber:
                                          "+${number.countryCode}${number.nsn}");
                                }
                              },
                              onSaved: (number) {
                                if (number != null) {
                                  addPhoneNumber(phoneNumber: "$number");

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const Success(),
                                    ),
                                  );
                                }
                              },
                              decoration: const InputDecoration(
                                labelText: 'Phone Number',
                                focusedBorder: Borders.FocusedBorder,
                                enabledBorder: Borders.EnabledBorder,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.bottomRight,
                      padding: const EdgeInsets.only(right: 15, bottom: 55),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context, SizeTransition5(const Success()));
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
}
