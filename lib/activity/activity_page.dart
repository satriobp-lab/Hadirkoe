import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadirkoe/activity/locationactivity/locationactivity_page.dart';
import 'package:intl/intl.dart';
import '../core/app_colors.dart';
import 'submitactivity/submitactivity_page.dart';
import 'editactivity/editactivity_page.dart';
import 'locationactivity/locationactivity_page.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  DateTime selectedDate = DateTime(2026, 4, 28);
  String selectedSort = "Newest";
  DateTime? filterSpecificDate; // Tambahkan state untuk filter tanggal spesifik
  String searchQuery = "";

  final ScrollController _dateScrollController = ScrollController();

  // Mock data tanggal satu minggu
  final List<DateTime> weekDates = List.generate(
    7,
        (index) => DateTime(2026, 4, 26 + index),
  );

  // Mock data aktivitas berdasarkan gambar image_70d67e.png
  final List<Map<String, dynamic>> activities = [
    {
      "id": "1",
      "userName": "Satrio Budi Pamungkas",
      "project": "Hadirkoe",
      "description": "Hari ini saya melanjutkan pengerjaan UI/UX Design pada aplikasi Hadirkoe, khususnya pada halaman log dan menu more agar tampilan semakin rapi, konsisten, dan mudah digunakan pengguna. Selain itu, saya juga meneruskan implementasi API data TPB untuk dokumen BC25, BC261, BC262, BC271, BC40, dan BC42.",
      "images": ["assets/code1.png", "assets/code2.png", "assets/code3.png"],
      "progress": 1.0, // 100%
      "timestamp": DateTime(2026, 4, 28, 17, 0),
      "location": "Jakarta"
    },
    {
      "id": "2",
      "userName": "Satrio Budi Pamungkas",
      "project": "Hadirkoe Mobile",
      "description": "Memperbaiki bug pada fitur presensi selfie dan menyamakan logic filter pada halaman activity.",
      "images": ["assets/code1.png"],
      "progress": 0.75, // 75%
      "timestamp": DateTime(2026, 4, 27, 16, 0),
      "location": "Jakarta"
    },
  ];


  // Fungsi Pop up Delete
  void _showDeleteConfirmation(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("Delete Activity?", style: GoogleFonts.nunito(fontWeight: FontWeight.bold, color: const Color(0xFF5D3E3E))),
        content: Text("Are you sure you want to delete this activity report? This action cannot be undone.",
            style: GoogleFonts.nunito(fontSize: 14)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: GoogleFonts.nunito(color: Colors.grey, fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            onPressed: () {
              // Logika hapus data di sini
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Activity deleted successfully"), backgroundColor: Colors.redAccent),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.profileHeaderRed,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text("Delete", style: GoogleFonts.nunito(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: filterSpecificDate ?? selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.profileHeaderRed,
              onPrimary: Colors.white,
              onSurface: Color(0xFF5D3E3E),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        filterSpecificDate = picked;
        selectedSort = "Specific Date";
      });
    }
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10))),
              const SizedBox(height: 20),
              Text("Sort & Filter Activities", style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF5D3E3E))),
              const SizedBox(height: 20),
              _buildSortOptionItem("Newest", "Latest entries first", Icons.history, setModalState, onTap: () => filterSpecificDate = null),
              _buildSortOptionItem("Oldest", "Oldest entries first", Icons.update, setModalState, onTap: () => filterSpecificDate = null),
              _buildSortOptionItem(
                "Specific Date",
                filterSpecificDate == null ? "Choose a specific date" : "Date: ${DateFormat('dd MMM yyyy').format(filterSpecificDate!)}",
                Icons.calendar_month,
                setModalState,
                onTap: () async {
                  Navigator.pop(context);
                  await _selectDate(context);
                  _showSortOptions();
                },
              ),
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
                  child: Text("Apply Filter", style: GoogleFonts.nunito(fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSortOptionItem(String title, String subtitle, IconData icon, StateSetter setModalState, {VoidCallback? onTap}) {
    bool isSelected = selectedSort == title;
    return GestureDetector(
      onTap: () {
        setModalState(() => selectedSort = title);
        setState(() => selectedSort = title);
        if (onTap != null) onTap();
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
    List<Map<String, dynamic>> filteredList = activities.where((element) {
      final projectMatches = element['project'].toString().toLowerCase().contains(searchQuery.toLowerCase());

      // Logika: Jika Sort adalah Specific Date, pakai filterSpecificDate. Jika tidak, pakai selectedDate (horizontal picker)
      DateTime targetDate = (selectedSort == "Specific Date" && filterSpecificDate != null)
          ? filterSpecificDate!
          : selectedDate;

      final dateMatches = DateFormat('yyyy-MM-dd').format(element['timestamp']) == DateFormat('yyyy-MM-dd').format(targetDate);
      return projectMatches && dateMatches;
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
        title: Text("Activity", style: GoogleFonts.nunito(color: AppColors.profileHeaderRed, fontSize: 20, fontWeight: FontWeight.w600)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: AppColors.profileHeaderRed, size: 28),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SubmitActivityPage(),
                ),
              );
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Month Display
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
              child: Text(DateFormat('MMM yyyy').format(selectedDate).toUpperCase(),
                  style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.grey.shade700)),
            ),

            // Horizontal Date Selector
            Container(
              height: 100,
              margin: const EdgeInsets.symmetric(vertical: 5),
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
              padding: const EdgeInsets.fromLTRB(25, 15, 25, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Your Reported Daily Activity", style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF5D3E3E))),
                  GestureDetector(
                    onTap: _showSortOptions,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          Text(
                            selectedSort == "Specific Date" && filterSpecificDate != null
                                ? DateFormat('dd/MM/yy').format(filterSpecificDate!)
                                : "Sort: $selectedSort",
                            style: GoogleFonts.nunito(fontSize: 11, color: Colors.grey.shade700, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 4),
                          Icon(Icons.filter_list, size: 14, color: Colors.grey.shade600),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: filteredList.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                itemCount: filteredList.length,
                itemBuilder: (context, index) => _buildActivityCard(filteredList[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assignment_outlined, size: 60, color: Colors.grey.shade300),
          const SizedBox(height: 10),
          Text("No activity reported for this date", style: GoogleFonts.nunito(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildDateCard(DateTime date, {required bool isSelected}) {
    String dayName = DateFormat('E').format(date);
    String dayNum = DateFormat('dd').format(date);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 75,
      margin: const EdgeInsets.only(right: 12, bottom: 8, top: 5, left: 5),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.profileHeaderRed : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: isSelected ? AppColors.profileHeaderRed : AppColors.profileHeaderRed.withOpacity(0.1), width: 1.5),
        boxShadow: [
          BoxShadow(color: isSelected ? AppColors.profileHeaderRed.withOpacity(0.3) : Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 4))
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

  Widget _buildActivityCard(Map<String, dynamic> data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.profileHeaderRed.withOpacity(0.15)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User & Project Info
            Text(data["userName"], style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey.shade600)),
            const SizedBox(height: 4),
            Text("Job/Project : ${data["project"]}", style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFF5D3E3E))),

            const SizedBox(height: 12),

            // Description
            Text("Information / Description :", style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w800, color: const Color(0xFF8B424D))),
            const SizedBox(height: 6),
            Text(data["description"],
              style: GoogleFonts.nunito(fontSize: 13, height: 1.5, color: Colors.grey.shade700),
              textAlign: TextAlign.justify,
            ),

            const SizedBox(height: 15),

            // Files Section (Horizontal Images)
            Text("Files :", style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w800, color: const Color(0xFF8B424D))),
            const SizedBox(height: 8),
            SizedBox(
              height: 70,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 3, // Dummy image count
                itemBuilder: (context, index) => Container(
                  width: 100,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey.shade200,
                    image: const DecorationImage(
                        image: NetworkImage("https://via.placeholder.com/100"), // Ganti ke asset jika ada
                        fit: BoxFit.cover
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Progress Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Progress :", style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w800, color: const Color(0xFF8B424D))),
                Text("${(data["progress"] * 100).toInt()} %", style: GoogleFonts.nunito(fontSize: 12, color: Colors.grey.shade700, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: data["progress"],
                minHeight: 12,
                backgroundColor: Colors.grey.shade200,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.profileHeaderRed),
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Divider(height: 1, thickness: 0.5),
            ),

            // Bottom Actions: Date, Location, Edit, Delete
            Row(
              children: [
                const Icon(
                  Icons.calendar_month_outlined,
                  size: 20,
                  color: Colors.grey,
                ),

                const SizedBox(width: 6),

                Text(
                  DateFormat('dd MMMM yyyy').format(data["timestamp"]),
                  style: GoogleFonts.nunito(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const Spacer(),

                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      splashRadius: 18,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 28,
                        minHeight: 28,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LocationActivityPage(
                              activityData: data,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.location_on_outlined,
                        size: 22,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(width: 2),

                    IconButton(
                      visualDensity: VisualDensity.compact,
                      splashRadius: 18,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 28,
                        minHeight: 28,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditActivityPage(
                              activityData: data,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.edit_outlined,
                        size: 22,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(width: 2),

                    IconButton(
                      visualDensity: VisualDensity.compact,
                      splashRadius: 18,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 28,
                        minHeight: 28,
                      ),
                      onPressed: () => _showDeleteConfirmation(data["id"]),
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        size: 22,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}