import 'package:flutter/material.dart';

class IntroDotIndicator extends StatelessWidget {
  final int index;
  final int currentPage;
  final Color activeColor;
  final Color inactiveColor;

  const IntroDotIndicator({
    super.key,
    required this.index,
    required this.currentPage,
    this.activeColor = Colors.deepPurple,
    this.inactiveColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    final bool isActive = currentPage == index;
    final double size = isActive ? 12 : 8;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? activeColor : inactiveColor,
      ),
    );
  }
}