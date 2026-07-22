import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/app_colors.dart';

class OvertimePage extends StatefulWidget {
  const OvertimePage({super.key});

  @override
  State<OvertimePage> createState() => _OvertimePageState();
}

class _OvertimePageState extends State<OvertimePage> {
  // Mock data pengajuan overtime / lembur sesuai desain mockup image_8bd93a.png
  final List<Map<String, dynamic>> _overtimeRequests = [
    {
      "id": "1",
      "name": "Satrio Budi Pamungkas",
      "requestTo": "Idris Kusuma Bhakti",
      "from": "08:00",
      "to": "20:00",
      "information":
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
      "reportedAt": "27 April 2026",
      "status": "Submitted",
    },
    {
      "id": "2",
      "name": "Satrio Budi Pamungkas",
      "requestTo": "Idris Kusuma Bhakti",
      "from": "17:00",
      "to": "21:00",
      "information":
      "Penyelesaian laporan bulanan sistem dan migrasi basis data server utama.",
      "reportedAt": "15 Mei 2026",
      "status": "Approved",
    },
  ];

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
          "Overtime",
          style: GoogleFonts.nunito(
            color: AppColors.profileHeaderRed,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add_circle_outline,
              color: AppColors.profileHeaderRed,
              size: 28,
            ),
            onPressed: () {
              // Navigasi ke halaman tambah pengajuan lembur baru
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SafeArea(
        child: _overtimeRequests.isEmpty
            ? _buildEmptyState()
            : ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          itemCount: _overtimeRequests.length,
          itemBuilder: (context, index) {
            return _buildOvertimeCard(_overtimeRequests[index]);
          },
        ),
      ),
    );
  }

  // UI Widget: Tampilan jika data pengajuan lembur kosong
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.access_time_outlined,
            size: 70,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 12),
          Text(
            "Belum ada pengajuan lembur",
            style: GoogleFonts.nunito(
              color: Colors.grey,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // UI Widget: Kartu Item Overtime sesuai desain mockup image_8bd93a.png
  Widget _buildOvertimeCard(Map<String, dynamic> data) {
    Color getBadgeColor(String status) {
      switch (status) {
        case "Submitted":
          return const Color(0xFFF06292); // Bright pink/magenta sesuai gambar mockup
        case "Need Approval":
          return const Color(0xFFFF8A80); // Soft salmon red
        case "Approved":
          return const Color(0xFF81C784); // Soft green
        default:
          return const Color(0xFFF06292);
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.profileHeaderRed.withOpacity(0.2),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nama Karyawan
            Text(
              data["name"] ?? "",
              style: GoogleFonts.nunito(
                fontSize: 14.5,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF7A585C),
              ),
            ),
            const SizedBox(height: 2),

            // Request : Nama Atasan / Tujuan Pengajuan
            Text(
              "Request : ${data['requestTo'] ?? ''}",
              style: GoogleFonts.nunito(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF8B525B),
              ),
            ),

            const SizedBox(height: 12),

            // Periode waktu (From & To)
            Row(
              children: [
                // Kolom From
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "From",
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        data["from"] ?? "",
                        style: GoogleFonts.poppins(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF5D3E3E),
                        ),
                      ),
                    ],
                  ),
                ),

                // Kolom To
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "To",
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        data["to"] ?? "",
                        style: GoogleFonts.poppins(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF5D3E3E),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Informasi / Deskripsi Alasan Lembur
            Text(
              "Information*",
              style: GoogleFonts.nunito(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF8B525B),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              data["information"] ?? "",
              style: GoogleFonts.nunito(
                fontSize: 12.5,
                height: 1.5,
                color: Colors.grey.shade700,
              ),
              textAlign: TextAlign.justify,
            ),

            const SizedBox(height: 18),

            // Bottom Section: Tanggal lapor & Status Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_month_outlined,
                      size: 20,
                      color: Color(0xFF6B4C4C),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      data["reportedAt"] ?? "",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                // Status Badge (Submitted / Need Approval / Approved)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: getBadgeColor(data["status"] ?? ""),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    data["status"] ?? "",
                    style: GoogleFonts.nunito(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}