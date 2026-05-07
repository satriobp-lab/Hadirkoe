import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../core/widgets/button_behaviour.dart';

class TimeZonePage extends StatefulWidget {
  const TimeZonePage({super.key});

  @override
  State<TimeZonePage> createState() => _TimeZonePageState();
}

class _TimeZonePageState extends State<TimeZonePage> {
  String selectedTimeZone = "WIB - Waktu Indonesia Barat";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.profileHeaderRed),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Time Zone",
          style: GoogleFonts.nunito(
            color: AppColors.profileHeaderRed,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Illustration Section
              Center(
                child: Image.asset(
                  'assets/icon_set_time_zone-removebg-preview.png', // Pastikan aset tersedia
                  height: MediaQuery.of(context).size.height * 0.25,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.public_rounded,
                    size: 150,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Instruction Text
              Text(
                "Set your time zone",
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF5D3E3E),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "Pick your location so your time and schedules stay accurate.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
              const SizedBox(height: 35),

              // Dropdown/Selector Field
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8F8),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: AppColors.profileHeaderRed.withOpacity(0.15)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedTimeZone,
                    isExpanded: true,
                    icon: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.profileHeaderRed.withOpacity(0.5)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                            )
                          ]
                      ),
                      child: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.profileHeaderRed, size: 18),
                    ),
                    items: [
                      "WIB - Waktu Indonesia Barat",
                      "WITA - Waktu Indonesia Tengah",
                      "WIT - Waktu Indonesia Timur",
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: GoogleFonts.nunito(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedTimeZone = newValue!;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Submit Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: ButtonBehaviour(
                  text: "Submit",
                  isProfileHeader: true, // Warna Maroon
                  onPressed: () {
                    // Logika submit nanti
                  },
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}