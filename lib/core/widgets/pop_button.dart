import 'package:flutter/material.dart';

class PopButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const PopButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  State<PopButton> createState() => _PopButtonState();
}

class _PopButtonState extends State<PopButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.93).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  void _handleTapDown(TapDownDetails details) => _controller.forward();
  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onPressed();
  }
  void _handleTapCancel() => _controller.reverse();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final foregroundColor = Theme.of(context).colorScheme.surface;

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: widget.backgroundColor ?? Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(30),
              ),
              child: DefaultTextStyle(
                style: TextStyle(
                  color: foregroundColor,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
                child: IconTheme(
                  data: IconThemeData(color: foregroundColor),
                  child: widget.child,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
} 