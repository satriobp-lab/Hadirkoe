import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../core/app_colors.dart';

class LocationTimesheetPage extends StatefulWidget {
  final Map<String, dynamic>? activityData;
  const LocationTimesheetPage({super.key, this.activityData});

  @override
  State<LocationTimesheetPage> createState() => _LocationTimesheetPageState();
}

class _LocationTimesheetPageState extends State<LocationTimesheetPage> {
  late LatLng _currentLocation;
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    // Gunakan koordinat dari data jika ada, jika tidak gunakan default Jakarta
    _currentLocation = LatLng(
      widget.activityData?['lat'] ?? -6.175392,
      widget.activityData?['lng'] ?? 106.827153,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.profileHeaderRed,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Activity Location",
          style: GoogleFonts.nunito(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // 1. Map Layer (OpenStreetMap)
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentLocation,
              initialZoom: 16.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.hadirkoe.app',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _currentLocation,
                    width: 80,
                    height: 80,
                    child: const Icon(
                      Icons.location_on,
                      color: AppColors.primaryRed,
                      size: 45,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // 2. Info Panel (Bottom) - Tanpa Button
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.fromLTRB(25, 15, 25, 40),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 15,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Indicator line
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 25),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  // Address Info
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.profileHeaderRed.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.location_history_rounded,
                          color: AppColors.profileHeaderRed,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Reported Location",
                              style: GoogleFonts.nunito(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.activityData?['location_name'] ?? "Sahid Sudirman Center, Lantai 15, Jl. Jend Sudirman No. 86, Jakarta Pusat",
                              style: GoogleFonts.nunito(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF5D3E3E),
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 18),
                            // Latitude & Longitude Section
                            Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade100),
                              ),
                              child: Row(
                                children: [
                                  Expanded(child: _buildCoordItem("Latitude", _currentLocation.latitude.toStringAsFixed(8))),
                                  Container(width: 1, height: 30, color: Colors.grey.shade300),
                                  const SizedBox(width: 20),
                                  Expanded(child: _buildCoordItem("Longitude", _currentLocation.longitude.toStringAsFixed(8))),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Floating GPS Reset Button
          // Positioned(
          //   right: 20,
          //   bottom: 220, // Disesuaikan agar berada di atas panel info
          //   child: FloatingActionButton(
          //     mini: true,
          //     backgroundColor: Colors.white,
          //     elevation: 4,
          //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          //     onPressed: () {
          //       _mapController.move(_currentLocation, 16.0);
          //     },
          //     //child: const Icon(Icons.my_location, color: AppColors.profileHeaderRed, size: 20),
          //   ),
          // ),
        ],
      ),
    );
  }

  // Helper widget untuk Latitude/Longitude agar tampilan rapi
  Widget _buildCoordItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.nunito(
            fontSize: 10,
            color: Colors.grey.shade500,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.profileHeaderRed,
          ),
        ),
      ],
    );
  }
}