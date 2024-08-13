import 'package:flutter/material.dart';
import 'package:needlinc/needlinc/needlinc-variables/colors.dart';

class backGround extends StatelessWidget {
  const backGround({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 265,
          decoration: const BoxDecoration(
            color: NeedlincColors.blue3,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(45),
              bottomRight: Radius.circular(45),
            ),
          ),
        ),
        Container(
          height: 245,
          decoration: const BoxDecoration(
            color: NeedlincColors.blue2,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(45),
              bottomRight: Radius.circular(45),
            ),
          ),
        ),
        Container(
          height: 225,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: NeedlincColors.blue1,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(45),
              bottomRight: Radius.circular(45),
            ),
          ),
        )
      ],
    );
  }
}
