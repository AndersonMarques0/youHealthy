import 'package:flutter/material.dart';
import 'package:youhealthy/screens/welcome_page.dart';
import 'package:youhealthy/screens/home_page.dart';
import 'package:youhealthy/screens/login_page.dart';
import 'package:youhealthy/screens/signup_page.dart';
import 'package:youhealthy/screens/introdute_page.dart';


void main() {
  runApp(const YouHealthyApp());
}

class YouHealthyApp extends StatelessWidget {
  const YouHealthyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'youHealthy',
      theme: ThemeData(primarySwatch: Colors.green),
      
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
