import 'package:flutter/material.dart';
import '../needlinc-variables/colors.dart';

class ClientBusinessPageRoute extends StatefulWidget {
  String userCategory;
  ClientBusinessPageRoute({super.key, required this.userCategory});

  @override
  State<ClientBusinessPageRoute> createState() =>
      _ClientBusinessPageRouteState();
}

class _ClientBusinessPageRouteState extends State<ClientBusinessPageRoute> {
  @override
  void initState() {
    // implement initState
    super.initState();
    // Set a delay to navigate to the second screen after 2.2 seconds
    Future.delayed(const Duration(milliseconds: 1), () {
      if (widget.userCategory == 'User' || widget.userCategory == 'Blogger') {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('client', (route) => false);
      }
      if (widget.userCategory == 'Business' ||
          widget.userCategory == 'Freelancer') {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('business', (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: NeedlincColors.white,
      body: SafeArea(
        child: Center(
          child: Text(
            'wait...',
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
