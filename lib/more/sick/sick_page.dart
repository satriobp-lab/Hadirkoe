import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../core/app_colors.dart';

class SickPage extends StatefulWidget {
  const SickPage({super.key});

  @override
  State<SickPage> createState() => _SickPageState();
}

class _SickPageState extends State<SickPage> {
  // Mock data pengajuan sakit sesuai desain mockup
  final List<Map<String, dynamic>> _sickRequests = [
    {
      "id": "1",
      "from": "2026-05-04 08:00:00",
      "to": "2026-05-05 17:00:00",
      "information":
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
      "reportedAt": "2026-05-04 10:50:19",
      "status": "Need Approval",
    },
    {
      "id": "2",
      "from": "2026-05-12 08:00:00",
      "to": "2026-05-13 17:00:00",
      "information":
      "Demam tinggi dan flu berat, memerlukan istirahat total berdasarkan surat rujukan dokter.",
      "reportedAt": "2026-05-12 07:30:00",
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
          "Sick",
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
              // Navigasi ke halaman tambah pengajuan sakit baru
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SafeArea(
        child: _sickRequests.isEmpty
            ? _buildEmptyState()
            : ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          itemCount: _sickRequests.length,
          itemBuilder: (context, index) {
            return _buildSickCard(_sickRequests[index]);
          },
        ),
      ),
    );
  }

  // UI Widget: Tampilan jika data sakit kosong
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.sick_outlined,
            size: 70,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 12),
          Text(
            "Belum ada pengajuan izin sakit",
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

  // UI Widget: Kartu Item Sick sesuai desain mockup
  Widget _buildSickCard(Map<String, dynamic> data) {
    final bool isNeedApproval = data["status"] == "Need Approval";
    final Color badgeColor = isNeedApproval
        ? const Color(0xFFFF8A80) // Soft salmon red untuk Need Approval
        : const Color(0xFF81C784); // Hijau soft untuk Approved

    // Pemisahan tanggal dan waktu
    final fromParts = data["from"].toString().split(' ');
    final toParts = data["to"].toString().split(' ');

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
            // Periode waktu (From & To) - Langsung di bagian atas kartu
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                        fromParts[0],
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF5D3E3E),
                        ),
                      ),
                      Text(
                        fromParts.length > 1 ? fromParts[1] : "",
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Colors.grey.shade600,
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
                        toParts[0],
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF5D3E3E),
                        ),
                      ),
                      Text(
                        toParts.length > 1 ? toParts[1] : "",
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Informasi / Deskripsi Alasan
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
              data["information"],
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
                    Icon(
                      Icons.calendar_month_outlined,
                      size: 20,
                      color: const Color(0xFF6B4C4C),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      data["reportedAt"],
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                // Status Badge (Need Approval / Approved)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    data["status"],
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