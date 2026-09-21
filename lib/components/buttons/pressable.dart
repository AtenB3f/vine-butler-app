import 'package:flutter/material.dart';

class Pressable extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final double hoverOpacity;
  final double pressedScale;

  const Pressable({
    super.key,
    required this.child,
    required this.onTap,
    this.hoverOpacity = 0.7,
    this.pressedScale = 0.95,
  });

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 120),
          opacity: _isHovered ? widget.hoverOpacity : 1.0,
          child: AnimatedScale(
            duration: const Duration(milliseconds: 100),
            scale: _isPressed ? widget.pressedScale : 1.0,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
