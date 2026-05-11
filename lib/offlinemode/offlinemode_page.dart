import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';

class OfflineModePage extends StatelessWidget {
  const OfflineModePage({super.key});

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
          "Offline Mode",
          style: GoogleFonts.nunito(
            color: AppColors.profileHeaderRed,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          // Menu titik 3 (PopupMenuButton)
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: AppColors.profileHeaderRed),
            onSelected: (value) {
              if (value == 'checkin') {
                // Logika Check In Offline
              } else if (value == 'checkout') {
                // Logika Check Out Offline
              }
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(color: AppColors.profileHeaderRed.withOpacity(0.1)),
            ),
            elevation: 8,
            shadowColor: Colors.black.withOpacity(0.2),
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'checkin',
                child: Text(
                  "Check In",
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF5D3E3E),
                  ),
                ),
              ),
              PopupMenuItem<String>(
                value: 'checkout',
                child: Text(
                  "Check Out",
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF5D3E3E),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Teks "Data is empty" sesuai gambar
            Text(
              "Data is empty",
              style: GoogleFonts.nunito(
                fontSize: 16,
                color: const Color(0xFF5D3E3E),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}