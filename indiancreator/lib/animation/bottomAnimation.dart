import 'dart:async';

import 'package:flutter/material.dart';

class Animator extends StatefulWidget {
  final Widget child;
  final Duration time;

  const Animator(this.child, this.time, {super.key});

  @override
  _AnimatorState createState() => _AnimatorState();
}

class _AnimatorState extends State<Animator>
    with SingleTickerProviderStateMixin {
  late Timer timer;
  late AnimationController animationController;
  late Animation animation;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    animation = CurvedAnimation(
        parent: animationController, curve: Curves.easeInOut);
    timer = Timer(widget.time, animationController.forward);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      child: widget.child,
      builder: (BuildContext context, Widget? child) {
        return Opacity(
          opacity: animation.value,
          child: Transform.translate(
            offset: Offset(0.0,
                double.parse((-50 + animation.value * 50).toString())),
            child: child,
          ),
        );
      },
    );
  }
}

Timer? timer;
Duration duration = const Duration();

wait() {
  if (timer == null || !timer!.isActive) {
    timer = Timer(const Duration(microseconds: 120), () {
      duration = const Duration();
    });
  }
  duration += const Duration(milliseconds: 300);
  return duration;
}

class WidgetAnimator extends StatelessWidget {
  final Widget? child;

  const WidgetAnimator({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Animator(child!, wait());
  }
}
