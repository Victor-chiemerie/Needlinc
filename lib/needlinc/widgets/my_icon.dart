import 'package:flutter/material.dart';

class RoundIcon extends StatelessWidget {
  final IconData iconData;
  final Color backgroundColor;
  final Color? iconColor;
  final double size;

  const RoundIcon({
    super.key,
    required this.iconData,
    required this.backgroundColor,
    this.iconColor,
    this.size = 18,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(
          iconData,
          color: iconColor, // Set icon color (usually white for contrast)
          size: size,
        ),
      ),
    );
  }
}
