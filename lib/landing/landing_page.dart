import 'package:flutter/material.dart';
import 'dart:async';
import 'package:hadirkoe/welcome/welcome_page.dart'; // Jalur relatif ke file di folder yang sama
import '../core/app_colors.dart'; // Jalur relatif naik satu tingkat ke core

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  void initState() {
    super.initState();
    // Berpindah ke Welcome Page setelah 3 detik
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const WelcomePage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryRed,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Image.asset(
            'assets/Logo hadirkoe.png',
            fit: BoxFit.contain,
            // Fallback jika asset belum terbaca
            errorBuilder: (context, error, stackTrace) => const Icon(
              Icons.image_not_supported,
              color: Colors.white,
              size: 50,
            ),
          ),
        ),
      ),
    );
  }
}