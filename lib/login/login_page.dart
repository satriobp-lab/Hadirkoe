import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../core/widgets/button_behaviour.dart';
import '../forgotpassword/forgotpassword_page.dart';
import '../dashboard/dashboard_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isClosePressed = false; // State untuk animasi tombol X

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.white,
        // 🔥 SafeArea biar aman dari notch / status bar
        body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            // Header Merah dengan Logo
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  width: double.infinity,
                  // 🔥 Responsive height untuk device kecil
                  height: MediaQuery.of(context).size.height < 700
                      ? 260
                      : MediaQuery.of(context).size.height * 0.35,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryRed,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.fingerprint,
                        size: 60,
                        color: AppColors.white,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Hadirkoe",
                        style: GoogleFonts.poppins(
                          color: AppColors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Comfort In Attendance",
                        style: GoogleFonts.lato(
                          color: AppColors.white.withOpacity(0.9),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          "Please login to using an account that is already registered or verified.",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.nunito(
                            color: AppColors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Tombol Close (X) dengan Behaviour Animasi
                Positioned(
                  bottom: -25,
                  child: GestureDetector(
                    onTapDown: (_) => setState(() => _isClosePressed = true),
                    onTapUp: (_) => setState(() => _isClosePressed = false),
                    onTapCancel: () => setState(() => _isClosePressed = false),
                    onTap: () => Navigator.pop(context),
                    child: AnimatedScale(
                      scale: _isClosePressed ? 0.9 : 1.0,
                      duration: const Duration(milliseconds: 100),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 100),
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: _isClosePressed ? AppColors.primaryRed : AppColors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _isClosePressed ? AppColors.white : Colors.transparent,
                            width: 2,
                          ),
                          boxShadow: _isClosePressed
                              ? []
                              : [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.close,
                          color: _isClosePressed ? AppColors.white : AppColors.primaryRed,
                          size: 24,
                          weight: 700,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60),
            // Form Login
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel("Username / Email"),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _usernameController,
                    hintText: "Input Username or Email",
                  ),
                  const SizedBox(height: 20),
                  _buildLabel("Password"),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _passwordController,
                    hintText: "Input Password",
                    isPassword: true,
                  ),
                  const SizedBox(height: 40),
                  // Tombol Login menggunakan ButtonBehaviour (Mode Inverted)
                  ButtonBehaviour(
                    text: "Login Now",
                    isDefaultRed: true,
                    onPressed: () {
                      // Navigasi ke DashboardPage
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const DashboardPage()),
                            (route) => false, // Bersihkan stack navigasi agar tidak bisa back ke login
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),
                        );
                      },
                      child: Text(
                        "Forgot Password ?",
                        style: GoogleFonts.nunito(
                          color: AppColors.primaryRed,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
        ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.nunito(
        color: AppColors.primaryRed,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.nunito(color: Colors.grey.shade400, fontSize: 14),
        filled: true,
        fillColor: const Color(0xFFFFF8F8),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primaryRed.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primaryRed.withOpacity(0.2)),
        ),
      ),
    );
  }
}