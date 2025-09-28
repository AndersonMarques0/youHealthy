import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double paddingHorizontal = size.width * 0.06;
    final double paddingVertical = size.height * 0.02;

    return Scaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: size.height, 
          ),
          child: Stack(
            children: [
              SizedBox(
                height: size.height,
                width: size.width,
                child: Image.asset(
                  'assets/images/treino.jpg', 
                  fit: BoxFit.cover,
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: paddingHorizontal,
                    vertical: paddingVertical,
                  ),
                  child: SizedBox(
                    height: size.height - paddingVertical * 2 - MediaQuery.of(context).padding.top,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
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
                        ),
                        Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(context, '/intro');
                                },
                                child: const Text(
                                  'Começar',
                                  style: TextStyle(
                                    fontSize: 18, 
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
