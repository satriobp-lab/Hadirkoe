import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../core/widgets/button_behaviour.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class RequestDomicilePage extends StatefulWidget {
  const RequestDomicilePage({super.key});

  @override
  State<RequestDomicilePage> createState() => _RequestDomicilePageState();
}

class _RequestDomicilePageState extends State<RequestDomicilePage> {
  // Koordinat dummy sesuai gambar
  String longitude = "106.8880578";
  String latitude = "-6.1499814";

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
          "Request Domicile",
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Map Section (Peta Kotak di tengah seperti gambar)
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  width: MediaQuery.of(context).size.width * 0.85,
                  height: 220,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Stack(
                      children: [
                        FlutterMap(
                          options: MapOptions(
                            initialCenter: LatLng(-6.1499814, 106.8880578),
                            initialZoom: 15,
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName: 'com.example.hadirkoe',
                              maxZoom: 19,
                            ),

                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: LatLng(-6.1499814, 106.8880578),
                                  width: 40,
                                  height: 40,
                                  child: const Icon(
                                    Icons.location_pin,
                                    color: Colors.red,
                                    size: 40,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        Positioned(
                          bottom: 10,
                          right: 10,
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.my_location,
                                color: AppColors.profileHeaderRed,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // 2. Info Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Longitude & Latitude
                    _buildInfoRow("Longitude", longitude),
                    _buildInfoRow("Latitude", latitude),

                    const SizedBox(height: 5),
                    Text(
                      "Your Position",
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    Text(
                      "Please wait...",
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Last Status Request Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Last Status Request",
                          style: GoogleFonts.nunito(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE2FF8D), // Hijau muda kekuningan sesuai gambar
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            "Need Approve",
                            style: GoogleFonts.nunito(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFA2C617), // Warna teks hijau tua
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),
                    const Divider(color: AppColors.profileHeaderRed, thickness: 1),
                    const SizedBox(height: 15),

                    // Location Domicile Section
                    Text(
                      "Location Domicile",
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Jalan Mitra Sunter Boulevard, RW 11, Sunter Jaya, Tanjung Priok, Jakarta Utara, ...",
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Request New Domicile Button (Full Width maroon style)
                    Center(
                      child: SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ButtonBehaviour(
                          text: "Request New Domicile",
                          isProfileHeader: true, // Warna Maroon
                          onPressed: () {
                            // Logic request
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: GoogleFonts.nunito(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF5D3E3E),
              ),
            ),
          ),
          Text(
            ": $value",
            style: GoogleFonts.nunito(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF5D3E3E),
            ),
          ),
        ],
      ),
    );
  }
}