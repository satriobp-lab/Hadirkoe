import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../settings/settings_page.dart';
import '../core/widgets/button_behaviour.dart';
import '../login/login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // State untuk mengontrol apakah sedang menampilkan data personal (dropdown aktif)
  bool _isPersonalDataVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.white,
        body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section yang dinamis
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomCenter,
              children: [
                _buildDynamicHeader(),
                // Tombol Toggle Dropdown
                Positioned(
                  bottom: -25,
                  child: _buildToggleButton(),
                ),
              ],
            ),

            const SizedBox(height: 50),

            // Content Section: Data Perusahaan (Hanya muncul jika personal data tertutup)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: AnimatedCrossFade(
                firstChild: _buildCompanySection(),
                secondChild: const SizedBox(width: double.infinity),
                crossFadeState: _isPersonalDataVisible
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 400),
              ),
            ),

            // Divider dan Version Info (Selalu Ada)
            const SizedBox(height: 10),
            const Divider(indent: 25, endIndent: 25, thickness: 1),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: _buildInfoField("Version Mobile Apps", "1.0.0"),
            ),

            const SizedBox(height: 20),

            // Logout Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: ButtonBehaviour(
                text: "Logout",
                isProfileHeader: true, // Warna maroon/marun
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                        (route) => false,
                  );
                },
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
        ),
    );
  }

  Widget _buildDynamicHeader() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        20,
        MediaQuery.of(context).size.height < 700 ? 30 : 50,
        20,
        45,
      ),
      decoration: const BoxDecoration(
        color: AppColors.profileHeaderRed,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
      ),
      child: Column(
        children: [
          // Nav Bar
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),

              Expanded(
                child: Text(
                  "Profile",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              IconButton(
                icon: const Icon(Icons.settings, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SettingsPage()),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          // User Info
          const CircleAvatar(
            radius: 45,
            backgroundColor: Colors.white24,
            child: CircleAvatar(
              radius: 42,
              backgroundImage: AssetImage("assets/person-image-removebg-preview.png"),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Satrio Budi Pamungkas",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "Business Development",
            style: GoogleFonts.nunito(
              color: Colors.white.withOpacity(0.9),
              fontSize: 13,
            ),
          ),

          // Data Personal dengan transisi CrossFade agar lebih smooth
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: Column(
              children: [
                const SizedBox(height: 20),
                Divider(color: Colors.white.withOpacity(0.3), indent: 10, endIndent: 10),
                const SizedBox(height: 10),
                _buildInfoField("NIK", "20250143", isDarkMode: true),
                _buildInfoField("Email", "satrio.pamungkas@edi-indonesia.co.id", isDarkMode: true),
                _buildInfoField("Job Level", "-", isDarkMode: true),
                _buildInfoField("Phone", "85179564346", isDarkMode: true),
              ],
            ),
            crossFadeState: _isPersonalDataVisible
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 400),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isPersonalDataVisible = !_isPersonalDataVisible;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: AnimatedRotation(
          turns: _isPersonalDataVisible ? 0.5 : 0,
          duration: const Duration(milliseconds: 400),
          child: Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.profileHeaderRed,
            size: 30,
          ),
        ),
      ),
    );
  }

  Widget _buildCompanySection() {
    return Column(
      children: [
        _buildInfoField("Company", "PT ELECTRONIC DATA INTERCHANGE INDONESIA"),
        _buildInfoField("Division", "Business Development & Operation"),
        _buildInfoField("Department", "Product & Development"),
        _buildInfoField("Leader 1", "8207173 - Idris Kusuma Bhakti"),
        _buildInfoField("Leader 2", "7697054 - Budi Setiawan"),
      ],
    );
  }

  Widget _buildInfoField(String label, String value, {bool isHighlighted = false, bool isDarkMode = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.nunito(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: isDarkMode ? Colors.white : const Color(0xFF5D3E3E),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isHighlighted
                    ? AppColors.profileHeaderRed.withOpacity(0.5)
                    : isDarkMode
                    ? Colors.white.withOpacity(0.3)
                    : AppColors.profileHeaderRed.withOpacity(0.1),
                width: isHighlighted ? 1.5 : 1,
              ),
            ),
            child: Text(
              value,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.nunito(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}