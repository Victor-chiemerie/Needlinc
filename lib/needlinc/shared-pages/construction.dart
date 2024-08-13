import 'package:flutter/material.dart';
import 'package:needlinc/needlinc/needlinc-variables/colors.dart';

class Construction extends StatefulWidget {
  const Construction({super.key});

  @override
  State<Construction> createState() => _ConstructionState();
}

class _ConstructionState extends State<Construction>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _animation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -0.2), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -0.2, end: 0.2), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 0.2, end: 0.0), weight: 1),
    ]).animate(_controller);

    // Start the animation loop
    _controller.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(15),
      content: Container(
        decoration: BoxDecoration(
          color: NeedlincColors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Sorry...',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: NeedlincColors.blue1,
                    fontWeight: FontWeight.w500,
                    fontSize: 26,
                  ),
                ),
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _animation.value,
                      child: const Icon(
                        Icons.waving_hand,
                        color: Colors.yellow,
                        size: 40,
                      ),
                    );
                  },
                ),
              ],
            ),
            const Text(
              '501',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 95,
              ),
            ),
            const Text(
              'This feature is under construction!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: NeedlincColors.blue1,
                fontWeight: FontWeight.w500,
                fontSize: 26,
              ),
            ),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _animation.value,
                  child: const Icon(
                    Icons.build,
                    color: Colors.grey,
                    size: 40,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
