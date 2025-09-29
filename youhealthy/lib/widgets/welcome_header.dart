import 'package:flutter/material.dart';
// Removido: import 'package:google_fonts/google_fonts.dart';

class WelcomeHeader extends StatelessWidget {
  const WelcomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;
    final primaryHeaderBaseStyle = textTheme.headlineMedium;
    final double responsiveFontSize = 
        (primaryHeaderBaseStyle?.fontSize ?? 30.0) + size.width * 0.01;

    return Column(
      children: [
        Text(
          'youhealthy',
          style: textTheme.titleSmall,
        ),
        SizedBox(height: size.height * 0.02),
        Text(
          'Aprenda sobre saúde\n e musculação.',
          textAlign: TextAlign.center,
          style: primaryHeaderBaseStyle?.copyWith(
            fontSize: responsiveFontSize,
          ),
        ),
      ],
    );
  }
}
