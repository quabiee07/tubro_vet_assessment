import 'package:flutter/material.dart';

class Clickable extends StatelessWidget {
  const Clickable({super.key, required this.onPressed, this.isEnabled = true, required this.child});

  final VoidCallback onPressed;
  final bool isEnabled;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () => isEnabled ? onPressed() : null,
      child: child,
    );
  }
}
