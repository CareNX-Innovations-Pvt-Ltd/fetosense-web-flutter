import 'package:flutter/material.dart';
import 'package:fetosense_mis/core/models/models.dart';

class HoverStatCard extends StatefulWidget {
  final DashboardStat stat;

  const HoverStatCard({super.key, required this.stat});

  @override
  State<HoverStatCard> createState() => _HoverStatCardState();
}

class _HoverStatCardState extends State<HoverStatCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onEnter(PointerEvent _) {
    setState(() => _isHovered = true);
    _controller.repeat(reverse: true);
  }

  void _onExit(PointerEvent _) {
    setState(() => _isHovered = false);
    _controller.stop();
    _controller.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final angle =
                0.05 * (_controller.value - 0.5);
            return Transform.rotate(angle: angle, child: child);
          },
          child: Icon(
            widget.stat.icon,
            color: Colors.tealAccent,
            size: 40,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          widget.stat.title,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        const SizedBox(height: 6),
        Text(
          widget.stat.count,
          style: const TextStyle(
            color: Colors.tealAccent,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
