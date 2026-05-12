import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart'; // Tambahkan package intl di pubspec.yaml untuk formatting tanggal
import '../core/app_colors.dart';

class LogPage extends StatefulWidget {
  const LogPage({super.key});

  @override
  State<LogPage> createState() => _LogPageState();
}

class _LogPageState extends State<LogPage> {
  String selectedMonth = "Apr";
  String selectedSort = "Newest";
  DateTime? filterSpecificDate; // State untuk menyimpan tanggal filter spesifik

  final ScrollController _periodScrollController = ScrollController();

  final List<Map<String, String>> periods = [
    {"month": "Jan", "year": "2026"},
    {"month": "Feb", "year": "2026"},
    {"month": "Mar", "year": "2026"},
    {"month": "Apr", "year": "2026"},
    {"month": "May", "year": "2026"},
    {"month": "Jun", "year": "2026"},
    {"month": "Jul", "year": "2026"},
    {"month": "Aug", "year": "2026"},
    {"month": "Sep", "year": "2026"},
    {"month": "Oct", "year": "2026"},
    {"month": "Nov", "year": "2026"},
    {"month": "Dec", "year": "2026"},
  ];

  final List<Map<String, dynamic>> logData = [
    {
      "type": "Check In",
      "name": "Dasha Taran",
      "status": "WFO - Approved",
      "date": "Tuesday, 28-04-2026",
      "time": "09:26:29",
      "isCheckIn": true,
      "timestamp": DateTime(2026, 4, 28, 9, 26),
    },
    {
      "type": "Check Out",
      "name": "Dasha Taran",
      "status": "WFO - Approved",
      "date": "Tuesday, 28-04-2026",
      "time": "18:26:29",
      "isCheckIn": false,
      "timestamp": DateTime(2026, 4, 28, 18, 26),
    },
    {
      "type": "Check In",
      "name": "Dasha Taran",
      "status": "WFO - Approved",
      "date": "Monday, 27-04-2026",
      "time": "09:15:10",
      "isCheckIn": true,
      "timestamp": DateTime(2026, 4, 27, 9, 15),
    },
    {
      "type": "Check Out",
      "name": "Dasha Taran",
      "status": "WFO - Approved",
      "date": "Monday, 27-04-2026",
      "time": "18:05:45",
      "isCheckIn": false,
      "timestamp": DateTime(2026, 4, 27, 18, 05),
    },
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedMonth();
    });
  }

  void _scrollToSelectedMonth() {
    int index = periods.indexWhere((p) => p["month"] == selectedMonth);
    if (index != -1) {
      double screenWidth = MediaQuery.of(context).size.width;
      double itemWidth = 90.0 + 12.0;
      double targetScroll = (index * itemWidth) - (screenWidth / 2) + (itemWidth / 2) + 20;

      _periodScrollController.animateTo(
        targetScroll.clamp(0, _periodScrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  // Fungsi memanggil DatePicker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: filterSpecificDate ?? DateTime(2026, 4, 28),
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return StatefulBuilder( // Gunakan StatefulBuilder agar UI di dalam modal update saat pilih item
            builder: (context, setModalState) {
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
                    ),
                    const SizedBox(height: 20),
                    Text("Sort & Filter Logs", style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF5D3E3E))),
                    const SizedBox(height: 20),

                    _buildSortOptionItem(
                      "Newest",
                      "Latest entries first",
                      Icons.history,
                      setModalState,
                      onTap: () => filterSpecificDate = null,
                    ),
                    _buildSortOptionItem(
                      "Oldest",
                      "Oldest entries first",
                      Icons.update,
                      setModalState,
                      onTap: () => filterSpecificDate = null,
                    ),
                    _buildSortOptionItem(
                      "Specific Date",
                      filterSpecificDate == null
                          ? "Choose a specific date"
                          : "Date: ${DateFormat('dd MMM yyyy').format(filterSpecificDate!)}",
                      Icons.calendar_month,
                      setModalState,
                      onTap: () async {
                        Navigator.pop(context); // Tutup dulu modalnya
                        await _selectDate(context); // Pilih tanggal
                        _showSortOptions(); // Buka lagi untuk submit
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
              );
            }
        );
      },
    );
  }

  Widget _buildSortOptionItem(String title, String subtitle, IconData icon, StateSetter setModalState, {VoidCallback? onTap}) {
    bool isSelected = selectedSort == title;
    return GestureDetector(
      onTap: () {
        setModalState(() {
          selectedSort = title;
        });
        setState(() {
          selectedSort = title;
        });
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
    // 1. Filter data berdasarkan tanggal jika opsi "Specific Date" dipilih
    List<Map<String, dynamic>> processedLogs = List.from(logData);

    if (selectedSort == "Specific Date" && filterSpecificDate != null) {
      processedLogs = processedLogs.where((log) {
        DateTime logDate = log['timestamp'];
        return logDate.year == filterSpecificDate!.year &&
            logDate.month == filterSpecificDate!.month &&
            logDate.day == filterSpecificDate!.day;
      }).toList();
    }

    // 2. Sort data
    processedLogs.sort((a, b) {
      DateTime dateA = a['timestamp'];
      DateTime dateB = b['timestamp'];
      if (selectedSort == "Oldest") {
        return dateA.compareTo(dateB);
      } else {
        // Default Newest atau saat Specific Date (tampilkan jam terbaru di atas)
        return dateB.compareTo(dateA);
      }
    });

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.profileHeaderRed),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Log", style: GoogleFonts.nunito(color: AppColors.profileHeaderRed, fontSize: 20, fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Viewing Period Section
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text("Viewing Period", style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF5D3E3E))),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 80,
                    child: ListView.builder(
                      controller: _periodScrollController,
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: periods.length,
                      itemBuilder: (context, index) {
                        final period = periods[index];
                        final bool isSelected = selectedMonth == period["month"];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedMonth = period["month"]!;
                              // Reset filter tanggal saat pindah bulan (opsional)
                              selectedSort = "Newest";
                              filterSpecificDate = null;
                            });
                            _scrollToSelectedMonth();
                          },
                          child: _buildPeriodCard(period["month"]!, period["year"]!, isSelected: isSelected),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // Header Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Your Presence Logs", style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF5D3E3E))),
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

            // Log List
            Expanded(
              child: processedLogs.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                itemCount: processedLogs.length,
                itemBuilder: (context, index) {
                  final log = processedLogs[index];
                  return _buildLogCard(
                    type: log["type"],
                    name: log["name"],
                    status: log["status"],
                    date: log["date"],
                    time: log["time"],
                    isCheckIn: log["isCheckIn"],
                  );
                },
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
          Icon(Icons. find_in_page_outlined, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text("No logs found for this date", style: GoogleFonts.nunito(color: Colors.grey, fontSize: 16)),
          TextButton(
            onPressed: () => setState(() { selectedSort = "Newest"; filterSpecificDate = null; }),
            child: const Text("Reset Filter", style: TextStyle(color: AppColors.profileHeaderRed)),
          )
        ],
      ),
    );
  }

  Widget _buildPeriodCard(String month, String year, {required bool isSelected}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 90,
      margin: const EdgeInsets.only(right: 12, bottom: 5),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.profileHeaderRed : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: isSelected ? AppColors.profileHeaderRed : AppColors.profileHeaderRed.withOpacity(0.1), width: 1.5),
        boxShadow: [
          if (isSelected) BoxShadow(color: AppColors.profileHeaderRed.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(month, style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.grey.shade500)),
          Text(year, style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w600, color: isSelected ? Colors.white : const Color(0xFF5D3E3E))),
        ],
      ),
    );
  }

  Widget _buildLogCard({required String type, required String name, required String status, required String date, required String time, required bool isCheckIn}) {
    final Color mainColor = isCheckIn ? const Color(0xFF4CAF50) : const Color(0xFFF44336);
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.profileHeaderRed.withOpacity(0.08)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 5))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 52, height: 52,
              decoration: BoxDecoration(color: mainColor.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(Icons.access_time_filled_rounded, color: mainColor, size: 26),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(type , style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF5D3E3E))),
                      Text(status, style: GoogleFonts.nunito(fontSize: 10, fontWeight: FontWeight.w600, color: const Color(0xFF4CAF50))),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        Icon(Icons.calendar_today_outlined, size: 12, color: Colors.grey.shade400),
                        const SizedBox(width: 4),
                        Text(date, style: GoogleFonts.nunito(fontSize: 11, color: Colors.grey.shade600)),
                      ]),
                      Text(time, style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w600, color: mainColor)),
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