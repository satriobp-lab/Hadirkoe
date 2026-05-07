import 'package:flutter/material.dart';
import 'package:hadirkoe/landing/landing_page.dart';
import 'package:hadirkoe/core/app_colors.dart';

void main() {
  runApp(const HadirkoeApp());
}

class HadirkoeApp extends StatelessWidget {
  const HadirkoeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hadirkoe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryRed),
      ),
      home: const LandingPage(),
    );
  }
}