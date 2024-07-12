import 'package:flutter/material.dart';

import '../theme/colors.dart';

class LoadingDot extends StatefulWidget {
  const LoadingDot({super.key});

  @override
  State<LoadingDot> createState() => _AnimatedLoginTextState();
}

class _AnimatedLoginTextState extends State<LoadingDot> with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedDot(controller: _controller, delay: 0),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class AnimatedDot extends StatelessWidget {
  final AnimationController controller;
  final double delay;

  const AnimatedDot({super.key, required this.controller, required this.delay});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(60 * (.5 - controller.value.abs()), 0),
          child: const Dot(),
        );
      },
    );
  }
}

class Dot extends StatelessWidget {
  const Dot({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: const BoxDecoration(
        color: AppColors.loadingDotColor,
        shape: BoxShape.circle,
      ),
    );
  }
}