import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../core/app_colors.dart';

class PermitPage extends StatefulWidget {
  const PermitPage({super.key});

  @override
  State<PermitPage> createState() => _PermitPageState();
}

class _PermitPageState extends State<PermitPage> {
  // Mock data pengajuan izin sesuai desain mockup image_071ea6.png
  final List<Map<String, dynamic>> _permits = [
    {
      "id": "1",
      "title": "Izin Terlambat Datang",
      "from": "04-05-2026 08:00:00",
      "to": "05-05-2026 17:00:00",
      "information": "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
      "reportedAt": "04-05-2026 10:50:19",
      "status": "Need Approval",
    },
    {
      "id": "2",
      "title": "Izin Pulang Cepat",
      "from": "10-05-2026 13:00:00",
      "to": "10-05-2026 17:00:00",
      "information": "Ada keperluan keluarga mendesak yang harus diselesaikan pada sore hari.",
      "reportedAt": "10-05-2026 11:15:22",
      "status": "Approved",
    }
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
          "Permit",
          style: GoogleFonts.nunito(
            color: AppColors.profileHeaderRed,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: AppColors.profileHeaderRed, size: 28),
            onPressed: () {
              // Navigasi ke halaman tambah permit baru
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SafeArea(
        child: _permits.isEmpty
            ? _buildEmptyState()
            : ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          itemCount: _permits.length,
          itemBuilder: (context, index) {
            return _buildPermitCard(_permits[index]);
          },
        ),
      ),
    );
  }

  // UI Widget: Tampilan jika data kosong
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assignment_turned_in_outlined, size: 70, color: Colors.grey.shade300),
          const SizedBox(height: 12),
          Text(
            "Belum ada pengajuan izin",
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

  // UI Widget: Kartu Item Permit sesuai gambar mockup
  Widget _buildPermitCard(Map<String, dynamic> data) {
    final bool isNeedApproval = data["status"] == "Need Approval";
    final Color badgeColor = isNeedApproval
        ? const Color(0xFFFF8A80) // Warna soft peach/red untuk Need Approval
        : const Color(0xFF81C784); // Warna hijau untuk Approved

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.profileHeaderRed.withOpacity(0.15),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Izin
            Text(
              data["title"],
              style: GoogleFonts.nunito(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF8B525B), // Soft maroon sesuai gambar
              ),
            ),
            const SizedBox(height: 12),

            // Periode waktu (From & To)
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "From",
                        style: GoogleFonts.nunito(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        data["from"].toString().split(' ')[0],
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF5D3E3E),
                        ),
                      ),
                      Text(
                        data["from"].toString().split(' ')[1],
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "To",
                        style: GoogleFonts.nunito(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        data["to"].toString().split(' ')[0],
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF5D3E3E),
                        ),
                      ),
                      Text(
                        data["to"].toString().split(' ')[1],
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

            // Informasi / Deskripsi
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

            // Divider tipis pembatas bottom row
            Container(
              height: 0.5,
              color: Colors.grey.shade200,
            ),
            const SizedBox(height: 14),

            // Bottom Section: Tanggal lapor & Status Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_month_outlined, size: 20, color: Colors.grey.shade600),
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