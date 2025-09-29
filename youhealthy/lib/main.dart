import 'package:flutter/material.dart';
import 'package:youhealthy/screens/welcome_page.dart';
import 'package:youhealthy/screens/home_page.dart';
import 'package:youhealthy/screens/login_page.dart';
import 'package:youhealthy/screens/signup_page.dart';
import 'package:youhealthy/screens/introdute_page.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const YouHealthyApp());
}

class YouHealthyApp extends StatelessWidget {
  const YouHealthyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final baseTextTheme = ThemeData.light().textTheme;
    
    return MaterialApp(
      title: 'youHealthy',
      theme: ThemeData(
        primarySwatch: Colors.green,
        textTheme: GoogleFonts.interTightTextTheme(
          baseTextTheme.copyWith(
            titleSmall: baseTextTheme.titleSmall?.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: const Color.fromARGB(179, 136, 135, 135),
            ),
            headlineMedium: baseTextTheme.headlineMedium?.copyWith(
              fontSize: 30, 
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
            bodyLarge: baseTextTheme.bodyLarge?.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            titleLarge: baseTextTheme.titleLarge?.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black, 
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            textStyle: GoogleFonts.interTight(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: Colors.deepPurple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25)),
          ),
        )
      ),
      
      initialRoute: '/welcome',
      
      routes: {
        '/welcome': (context) => const WelcomePage(),
        '/intro': (context) => const IntroPage(), 
        '/login': (context) => const LoginPage(),
        '/sign': (context) => const SignPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}
