import 'package:flutter/material.dart';

class AnimatedLogo extends StatefulWidget {
  const AnimatedLogo({super.key});

  @override
  State<AnimatedLogo> createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<AnimatedLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // The controller defines the duration and behavior of the animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500), // 1 beat per second
    )..repeat(reverse: true); // Pulses in and out

    // The animation defines the scale between 0.95x and 1.05x
    _animation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutCubic, // Smooth pulsing
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // Clean up when widget is removed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: Image.asset(
        'assets/images/login/fetosense.png',
        width: 350,
        height: 150,
        fit: BoxFit.contain,
        errorBuilder:
            (context, error, stackTrace) => const Icon(
              Icons.image_not_supported,
              color: Colors.white70,
              size: 80,
            ),
      ),
    );
  }
}
