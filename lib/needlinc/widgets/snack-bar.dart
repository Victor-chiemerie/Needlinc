import 'package:flutter/material.dart';
import 'package:needlinc/needlinc/needlinc-variables/colors.dart';

void showSnackBar(
    BuildContext context, String title, String message, Color colors) {
  if (message.contains('invalid-email')) {
    message = 'Invalid login details';
  } else if (message.contains('Unexpected null value')) {
    message = 'Some fields contain invalid details';
  } else {}

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: Duration(milliseconds: 2500),
      dismissDirection: DismissDirection.up,
      content: Container(
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.7),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
        decoration: BoxDecoration(
          color: colors,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: NeedlincColors.white,
                fontSize: 19,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
  );
}
