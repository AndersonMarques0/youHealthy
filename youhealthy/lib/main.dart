import 'package:flutter/material.dart';
import 'package:youhealthy/screens/welcome_page.dart';
import 'package:youhealthy/screens/home_page.dart';
import 'package:youhealthy/screens/login_page.dart';
import 'package:youhealthy/screens/signup_page.dart';
import 'package:youhealthy/screens/introdute_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:intl/date_symbol_data_local.dart';

const Color kPrimaryColor = Colors.deepPurple;
const Color kSecondaryColor = Colors.grey;

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('pt_BR', null);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const YouHealthyApp());
}

class YouHealthyApp extends StatelessWidget {
  const YouHealthyApp({super.key});

  @override
  Widget build(BuildContext context) {
  final baseTextTheme = ThemeData.light().textTheme;
  const Color primaryColor = kPrimaryColor;
  const Color secondaryTextColor = kSecondaryColor;

    return MaterialApp(
      title: 'youHealthy',
      theme: ThemeData(
        primaryColor: primaryColor,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: primaryColor,
          unselectedItemColor: secondaryTextColor,
        ),
        chipTheme: ChipThemeData(
          backgroundColor: Colors.grey[200],
          selectedColor: primaryColor,
          labelStyle: GoogleFonts.interTight(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
          secondaryLabelStyle: GoogleFonts.interTight(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
        textTheme: GoogleFonts.interTightTextTheme(
          baseTextTheme.copyWith(
            headlineSmall: baseTextTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            bodyMedium: baseTextTheme.bodyMedium?.copyWith(
              color: secondaryTextColor,
            ),
            titleMedium: baseTextTheme.titleMedium?.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            bodySmall: baseTextTheme.bodySmall?.copyWith(
              color: secondaryTextColor,
              fontSize: 13,
            ),
            titleSmall: baseTextTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black87,
            ),
            labelSmall: baseTextTheme.labelSmall?.copyWith(
              fontSize: 12,
              color: secondaryTextColor,
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
              color: primaryColor,
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
      ),
      initialRoute: '/welcome',
      routes: {
        '/welcome': (context) => const WelcomePage(),
        '/intro': (context) => const IntroPage(),
        '/login': (context) => const LoginPage(),
        '/sign': (context) => const SignUpEmailScreen(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}