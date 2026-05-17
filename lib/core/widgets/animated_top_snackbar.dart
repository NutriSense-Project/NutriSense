import 'package:flutter/material.dart';

class AnimatedTopSnackBar {
  static void show(
    BuildContext context,
    String message, {
    Color backgroundColor = Colors.green,
    IconData icon = Icons.check_circle,
    Duration duration = const Duration(seconds: 3),
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 60,                   
        left: 16,
        right: 16,
        child: _AnimatedSnackBarContent(
          message: message,
          backgroundColor: backgroundColor,
          icon: icon,
          onDismiss: () {
            if (overlayEntry.mounted) {
              overlayEntry.remove();
            }
          },
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(duration, () {
      if (overlayEntry.mounted) {
        // Auto dismiss
      }
    });
  }
}

class _AnimatedSnackBarContent extends StatefulWidget {
  final String message;
  final Color backgroundColor;
  final IconData icon;
  final VoidCallback onDismiss;

  const _AnimatedSnackBarContent({
    required this.message,
    required this.backgroundColor,
    required this.icon,
    required this.onDismiss,
  });

  @override
  State<_AnimatedSnackBarContent> createState() => _AnimatedSnackBarContentState();
}

class _AnimatedSnackBarContentState extends State<_AnimatedSnackBarContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));

    _controller.forward();

    Future.delayed(const Duration(seconds: 3), _dismiss);
  }

  void _dismiss() {
    _controller.reverse().then((_) {
      if (mounted) {
        widget.onDismiss();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(12),
        color: widget.backgroundColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(widget.icon, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 20),
                onPressed: _dismiss,
              ),
            ],
          ),
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