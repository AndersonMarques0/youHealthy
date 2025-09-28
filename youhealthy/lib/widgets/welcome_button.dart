import 'package:flutter/material.dart';

class WelcomeButton extends StatelessWidget {
  const WelcomeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
    );
  }
}