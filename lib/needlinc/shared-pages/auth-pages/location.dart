import 'package:flutter/material.dart';
import 'package:needlinc/needlinc/needlinc-variables/colors.dart';
import 'package:needlinc/needlinc/shared-pages/auth-pages/addNumber.dart';
import 'package:needlinc/needlinc/widgets/TextFieldBorder.dart';
import '../../backend/user-account/functionality.dart';
import '../../widgets/page-transition.dart';
import '../../widgets/snack-bar.dart';

class Location extends StatefulWidget {
  const Location({super.key});

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  final locationController = TextEditingController();
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
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
          child: Column(
            children: [
              const SizedBox(height: 35),
              // Add location
              const Text(
                'Add Location',
                style: TextStyle(
                  color: NeedlincColors.blue1,
                  fontSize: 26,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 40,
                child: TextFormField(
                  controller: locationController,
                  decoration: const InputDecoration(
                    hintText: 'Where do you stay?',
                    contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                    focusedBorder: Borders.FocusedBorder,
                    enabledBorder: Borders.EnabledBorder,
                  ),
                ),
              ),
              // Next button
              Expanded(
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.only(right: 15, bottom: 55),
                  child: ElevatedButton(
                    onPressed: () {
                      if (locationController.text.isNotEmpty) {
                        addLocation(location: locationController.text);
                        Navigator.push(
                            context, SizeTransition5(const PhoneNumber()));
                      }
                      showSnackBar(
                          context,
                          'Sorry!!',
                          'This information is very important',
                          NeedlincColors.red);
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
      ),
    );
  }
}
