import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_colors.dart';

class ButtonBehaviour extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isDefaultRed;
  final bool isProfileHeader; // Parameter baru untuk gaya tombol Profile

  const ButtonBehaviour({
    super.key,
    required this.text,
    required this.onPressed,
    this.isDefaultRed = false,
    this.isProfileHeader = false, // Default false
  });

  @override
  State<ButtonBehaviour> createState() => _ButtonBehaviourState();
}

class _ButtonBehaviourState extends State<ButtonBehaviour> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    Color borderColor;

    // Logika pemilihan warna
    if (widget.isProfileHeader) {
      // Gaya Tombol Profile (Profile Header Red / Maroon)
      bgColor = _isPressed ? AppColors.white : AppColors.profileHeaderRed;
      textColor = _isPressed ? AppColors.profileHeaderRed : AppColors.white;
      borderColor = _isPressed ? AppColors.profileHeaderRed : Colors.transparent;
    } else if (widget.isDefaultRed) {
      // Gaya Tombol Login (Primary Red)
      bgColor = _isPressed ? AppColors.white : AppColors.primaryRed;
      textColor = _isPressed ? AppColors.primaryRed : AppColors.white;
      borderColor = _isPressed ? AppColors.primaryRed : Colors.transparent;
    } else {
      // Gaya Tombol Welcome (Background Putih)
      bgColor = _isPressed ? AppColors.primaryRed : AppColors.white;
      textColor = _isPressed ? AppColors.white : AppColors.primaryRed;
      borderColor = _isPressed ? AppColors.white : Colors.transparent;
    }

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: double.infinity,
        height: 55,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: borderColor, width: 1.5),
          boxShadow: _isPressed
              ? []
              : [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          widget.text,
          style: GoogleFonts.nunito( // Menggunakan Nunito agar konsisten dengan profil
            color: textColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}