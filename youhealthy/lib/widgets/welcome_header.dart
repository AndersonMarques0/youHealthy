import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeHeader extends StatelessWidget {
  const WelcomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        Text(
          'youhealthy',
          style: GoogleFonts.interTight(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: const Color.fromARGB(179, 136, 135, 135),
          ),
        ),
        SizedBox(height: size.height * 0.02),
        Text(
          'Aprenda sobre saúde\n e musculação.',
          textAlign: TextAlign.center,
          style: GoogleFonts.interTight(
            fontSize: 30 + size.width * 0.01,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
