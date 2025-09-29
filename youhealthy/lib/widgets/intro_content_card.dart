import 'package:flutter/material.dart';

class IntroContentCard extends StatelessWidget {
  final String imagePath;
  final String text;
  final double imageHeight;

  const IntroContentCard({
    super.key,
    required this.imagePath,
    required this.text,
    required this.imageHeight,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyLarge;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          imagePath,
          height: imageHeight, 
          fit: BoxFit.contain,
        ),
        SizedBox(height: imageHeight * 0.12),
        Text(
          text,
          textAlign: TextAlign.center,
          style: textStyle,
        ),
      ],
    );
  }
}
