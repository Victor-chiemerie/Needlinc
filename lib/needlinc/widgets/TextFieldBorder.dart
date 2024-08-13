import 'package:flutter/material.dart';
import '../needlinc-variables/colors.dart';

class Borders {
  static const EnabledBorder = OutlineInputBorder(
    borderSide: BorderSide(
      color: NeedlincColors.black1,
    ),
    borderRadius: BorderRadius.zero,
  );
  static const FocusedBorder = OutlineInputBorder(
    borderSide: BorderSide(
      color: NeedlincColors.blue1,
    ),
    borderRadius: BorderRadius.zero,
  );
}
