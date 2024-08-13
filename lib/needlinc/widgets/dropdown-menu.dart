import 'package:flutter/material.dart';
import 'package:needlinc/needlinc/needlinc-variables/colors.dart';

class DropdownMenuWidget extends StatefulWidget {
  const DropdownMenuWidget({super.key});

  @override
  _DropdownMenuWidgetState createState() => _DropdownMenuWidgetState();
}

class _DropdownMenuWidgetState extends State<DropdownMenuWidget> {
  String selectedOption = 'Post on marketplace';
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 155,
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: NeedlincColors.white,
        borderRadius: BorderRadius.circular(20.0),
            border: Border.all(color: NeedlincColors.black3)
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedOption,
          onChanged: (newValue) {
            setState(() {
              selectedOption = newValue!;
            });
          },
          items: <String>['Post on marketplace', 'Post on Home page', 'Post in both']
              .map<DropdownMenuItem<String>>(
                (String value) => DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: TextStyle(
                  color: value == selectedOption ? NeedlincColors.blue1 : NeedlincColors.black1, fontSize: 11
              ),),
            ),
          )
              .toList(),
          underline: Container(),
        ),
      ),
    );
  }
}