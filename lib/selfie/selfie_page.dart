import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../core/app_colors.dart';

class SelfiePage extends StatefulWidget {
  const SelfiePage({super.key});

  @override
  State<SelfiePage> createState() => _SelfiePageState();
}

class _SelfiePageState extends State<SelfiePage> {
  DateTime selectedDate = DateTime(2026, 4, 28);
  String selectedSort = "Newest";
  String searchQuery = "";

  final ScrollController _dateScrollController = ScrollController();

  final List<DateTime> weekDates = List.generate(
    7,
        (index) => DateTime(2026, 4, 26 + index),
  );

  final List<Map<String, dynamic>> selfieData = [
    {
      "name": "Dasha Taran",
      "role": "UI/UX Designer",
      "type": "Check In",
      "isCheckIn": true,
      "location": "Jakarta Office, Lt. 4",
      "time": "08:30",
      "image": "assets/meme.jpeg",
      "timestamp": DateTime(2026, 4, 28, 8, 30),
    },
    {
      "name": "Dasha Taran",
      "role": "UI/UX Designer",
      "type": "Check Out",
      "isCheckIn": false,
      "location": "Jakarta Office, Lt. 4",
      "time": "17:35",
      "image": "assets/meme.jpeg",
      "timestamp": DateTime(2026, 4, 28, 17, 35),
    },
    {
      "name": "Jungkook",
      "role": "Mobile Developer",
      "type": "Check In",
      "isCheckIn": true,
      "location": "Surabaya Branch",
      "time": "08:45",
      "image": "assets/meme.jpeg",
      "timestamp": DateTime(2026, 4, 28, 8, 45),
    },
    {
      "name": "Lalisa M.",
      "role": "Product Manager",
      "type": "Check In",
      "isCheckIn": true,
      "location": "Home (WFH)",
      "time": "09:00",
      "image": "assets/meme.jpeg",
      "timestamp": DateTime(2026, 4, 28, 9, 0),
    },
  ];

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10))),
              const SizedBox(height: 20),
              Text("Sort Activities", style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF5D3E3E))),
              const SizedBox(height: 20),
              _buildSortOptionItem("Newest", "Latest first", Icons.history, setModalState),
              _buildSortOptionItem("Oldest", "Oldest first", Icons.update, setModalState),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.profileHeaderRed,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text("Apply", style: GoogleFonts.nunito(fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSortOptionItem(String title, String subtitle, IconData icon, StateSetter setModalState) {
    bool isSelected = selectedSort == title;
    return GestureDetector(
      onTap: () {
        setModalState(() => selectedSort = title);
        setState(() => selectedSort = title);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.profileHeaderRed.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: isSelected ? AppColors.profileHeaderRed : Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? AppColors.profileHeaderRed : Colors.grey),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.nunito(fontWeight: FontWeight.bold, color: isSelected ? AppColors.profileHeaderRed : const Color(0xFF5D3E3E))),
                  Text(subtitle, style: GoogleFonts.nunito(fontSize: 11, color: Colors.grey)),
                ],
              ),
            ),
            if (isSelected) const Icon(Icons.check_circle, color: AppColors.profileHeaderRed, size: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredList = selfieData.where((element) {
      final nameMatches = element['name'].toString().toLowerCase().contains(searchQuery.toLowerCase());
      final dateMatches = DateFormat('yyyy-MM-dd').format(element['timestamp']) == DateFormat('yyyy-MM-dd').format(selectedDate);
      return nameMatches && dateMatches;
    }).toList();

    filteredList.sort((a, b) => selectedSort == "Oldest" ? a['timestamp'].compareTo(b['timestamp']) : b['timestamp'].compareTo(a['timestamp']));

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.profileHeaderRed),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Selfie Attendance", style: GoogleFonts.nunito(color: AppColors.profileHeaderRed, fontSize: 20, fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Container(
                decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(15)),
                child: TextField(
                  onChanged: (value) => setState(() => searchQuery = value),
                  decoration: InputDecoration(
                    hintText: "Search team member...",
                    hintStyle: GoogleFonts.nunito(color: Colors.grey, fontSize: 13),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),

            // Horizontal Date Selector
            Container(
              height: 90,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: ListView.builder(
                controller: _dateScrollController,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: weekDates.length,
                itemBuilder: (context, index) {
                  final date = weekDates[index];
                  final bool isSelected = DateFormat('dd').format(date) == DateFormat('dd').format(selectedDate);
                  return GestureDetector(
                    onTap: () => setState(() => selectedDate = date),
                    child: _buildDateCard(date, isSelected: isSelected),
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Activity on ${DateFormat('dd MMM yyyy').format(selectedDate)}",
                      style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF5D3E3E))),
                  GestureDetector(
                    onTap: _showSortOptions,
                    child: Row(
                      children: [
                        Text("Sort: $selectedSort", style: GoogleFonts.nunito(fontSize: 11, color: Colors.grey.shade700, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 4),
                        const Icon(Icons.filter_list, size: 14, color: Colors.grey),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: filteredList.isEmpty
                  ? Center(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.no_photography_outlined, size: 60, color: Colors.grey.shade300),
                  const SizedBox(height: 10),
                  Text("No selfie logs for this date", style: GoogleFonts.nunito(color: Colors.grey)),
                ],
              ))
                  : ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                itemCount: filteredList.length,
                itemBuilder: (context, index) => _buildSelfieCard(filteredList[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateCard(DateTime date, {required bool isSelected}) {
    String dayName = DateFormat('E').format(date);
    String dayNum = DateFormat('dd').format(date);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 70,
      margin: const EdgeInsets.only(right: 12, bottom: 5),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.profileHeaderRed : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
            color: isSelected ? AppColors.profileHeaderRed : AppColors.profileHeaderRed.withOpacity(0.1),
            width: 1.5
        ),
        boxShadow: [
          if (isSelected) BoxShadow(color: AppColors.profileHeaderRed.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(dayName, style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.bold, color: isSelected ? Colors.white70 : Colors.grey.shade500)),
          const SizedBox(height: 4),
          Text(dayNum, style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : const Color(0xFF5D3E3E))),
        ],
      ),
    );
  }

  Widget _buildSelfieCard(Map<String, dynamic> data) {
    final bool isIn = data["isCheckIn"];
    final Color statusColor = isIn ? const Color(0xFF4CAF50) : const Color(0xFFF44336);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.profileHeaderRed.withOpacity(0.08)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 5))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center, // Sejajarkan foto dengan konten di tengah secara vertikal
          children: [
            // PHOTO
            Container(
              width: 75,
              height: 75,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: AssetImage(data["image"]),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 15),
            // INFO CONTENT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Baris 1: Nama dan Badge (Sejajar Kanan-Kiri)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(data["name"],
                          style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF5D3E3E)),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(data["type"],
                            style: GoogleFonts.nunito(fontSize: 10, fontWeight: FontWeight.w800, color: statusColor)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  // Baris 2: Role
                  Text(data["role"], style: GoogleFonts.nunito(fontSize: 11, color: Colors.grey.shade500, fontWeight: FontWeight.w500)),

                  const SizedBox(height: 12), // Jarak pemisah ke info detail

                  // Baris 3: Lokasi dan Waktu (Sejajar secara horizontal di bawah)
                  Row(
                    children: [
                      // Lokasi (WFO/WFH)
                      Expanded(
                        flex: 2,
                        child: Row(
                          children: [
                            Icon(Icons.location_on_outlined, size: 14, color: Colors.grey.shade400),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(data["location"],
                                  style: GoogleFonts.nunito(fontSize: 11, color: Colors.grey.shade600, fontWeight: FontWeight.w600),
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ],
                        ),
                      ),
                      // Waktu (Time) - Dibuat sejajar di kanan
                      Row(
                        children: [
                          Icon(Icons.access_time_rounded, size: 14, color: statusColor.withOpacity(0.7)),
                          const SizedBox(width: 4),
                          Text(data["time"], style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w800, color: statusColor)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}