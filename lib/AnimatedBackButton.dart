import 'package:flutter/cupertino.dart';

class FadedIconButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Icon icon;

  const FadedIconButton({
    required this.onPressed,
    required this.icon,
    super.key,
  });

  @override
  State<FadedIconButton> createState() => _FadedIconButtonState();
}

class _FadedIconButtonState extends State<FadedIconButton> {
  double _opacity = 1.0;

  void _handleTapDown(TapDownDetails details) {
    setState(() => _opacity = 0.5);
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _opacity = 1.0);
  }

  void _handleTapCancel() {
    setState(() => _opacity = 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 100),
        opacity: _opacity,
        child: widget.icon,
      ),
    );
  }
}