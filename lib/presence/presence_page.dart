import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../core/app_colors.dart';

class PresencePage extends StatefulWidget {
  const PresencePage({super.key});

  @override
  State<PresencePage> createState() => _PresencePageState();
}

class _PresencePageState extends State<PresencePage> {
  // --- Logic State yang disamakan dengan LogPage ---
  String selectedMonth = "Apr";
  String selectedSort = "Newest";
  DateTime? filterSpecificDate;
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

  // Mock data absensi (Ditambahkan field timestamp untuk fungsi sorting)
  final List<Map<String, dynamic>> presenceLogs = [
    {
      "day": "Wed",
      "date": "01",
      "fullDate": "2026-04-01",
      "checkIn": "08:26:29",
      "checkOut": "17:01:16",
      "duration": "8 Jam 21 Menit",
      "status": "Telat Datang",
      "isLate": true,
      "timestamp": DateTime(2026, 4, 1),
    },
    {
      "day": "Thu",
      "date": "02",
      "fullDate": "2026-04-02",
      "checkIn": "07:26:29",
      "checkOut": "17:01:16",
      "duration": "8 Jam 35 Menit",
      "status": "Tepat Waktu",
      "isLate": false,
      "timestamp": DateTime(2026, 4, 2),
    },
    // ... data lainnya
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
      double itemWidth = 90.0 + 12.0; // width + margin
      double targetScroll = (index * itemWidth) - (screenWidth / 2) + (itemWidth / 2) + 20;

      _periodScrollController.animateTo(
        targetScroll.clamp(0, _periodScrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: filterSpecificDate ?? DateTime(2026, 4, 1),
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
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40, height: 4,
                    decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
                  ),
                  const SizedBox(height: 20),
                  Text("Sort & Filter Presence", style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF5D3E3E))),
                  const SizedBox(height: 20),
                  _buildSortOptionItem("Newest", "Latest logs first", Icons.history, setModalState, onTap: () => filterSpecificDate = null),
                  _buildSortOptionItem("Oldest", "Oldest logs first", Icons.update, setModalState, onTap: () => filterSpecificDate = null),
                  _buildSortOptionItem(
                    "Specific Date",
                    filterSpecificDate == null ? "Choose a specific date" : DateFormat('dd MMM yyyy').format(filterSpecificDate!),
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
            );
          },
        );
      },
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
    // Logic Filtering & Sorting
    List<Map<String, dynamic>> processedLogs = List.from(presenceLogs);

    if (selectedSort == "Specific Date" && filterSpecificDate != null) {
      processedLogs = processedLogs.where((log) {
        DateTime logDate = log['timestamp'];
        return logDate.year == filterSpecificDate!.year &&
            logDate.month == filterSpecificDate!.month &&
            logDate.day == filterSpecificDate!.day;
      }).toList();
    }

    processedLogs.sort((a, b) {
      if (selectedSort == "Oldest") return a['timestamp'].compareTo(b['timestamp']);
      return b['timestamp'].compareTo(a['timestamp']);
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
        title: Text("Presence", style: GoogleFonts.nunito(color: AppColors.profileHeaderRed, fontSize: 20, fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Viewing Period
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Text("Viewing Period", style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF5D3E3E))),
          ),
          SizedBox(
            height: 80,
            child: ListView.builder(
              controller: _periodScrollController,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: periods.length,
              itemBuilder: (context, index) {
                final bool isSelected = selectedMonth == periods[index]["month"];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedMonth = periods[index]["month"]!;
                      selectedSort = "Newest";
                      filterSpecificDate = null;
                    });
                    _scrollToSelectedMonth();
                  },
                  child: _buildPeriodCard(periods[index]["month"]!, periods[index]["year"]!, isSelected),
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          // Header List & Filter Button
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

          // Logs List
          Expanded(
            child: processedLogs.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              itemCount: processedLogs.length,
              itemBuilder: (context, index) => _buildPresenceCard(processedLogs[index]),
            ),
          ),
        ],
      ),
    );
  }

  // --- Widget Components ---

  Widget _buildPeriodCard(String month, String year, bool isSelected) {
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.find_in_page_outlined, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text("No records found", style: GoogleFonts.nunito(color: Colors.grey, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildPresenceCard(Map<String, dynamic> log) {
    final statusColor = log["isLate"] ? const Color(0xFFF44336) : const Color(0xFF4CAF50);
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
        border: Border.all(color: AppColors.profileHeaderRed.withOpacity(0.1)),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 60,
              decoration: BoxDecoration(
                color: AppColors.profileHeaderRed.withOpacity(0.03),
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), bottomLeft: Radius.circular(15)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(log["day"], style: GoogleFonts.nunito(fontSize: 12, color: Colors.grey.shade600)),
                  Text(log["date"], style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w800, color: const Color(0xFF5D3E3E))),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildTimeLabel("Check In:", const Color(0xFF4CAF50)),
                        _buildTimeLabel("Check Out:", const Color(0xFFF44336)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(log["checkIn"], style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.bold)),
                        Text(log["checkOut"], style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const Divider(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(log["duration"], style: GoogleFonts.nunito(fontSize: 11, color: Colors.grey)),
                        Text(log["status"], style: GoogleFonts.nunito(fontSize: 11, color: statusColor, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeLabel(String label, Color color) {
    return Text(label, style: GoogleFonts.nunito(fontSize: 11, fontWeight: FontWeight.bold, color: color));
  }
}