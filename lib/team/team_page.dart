import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../core/app_colors.dart';

class TeamPage extends StatefulWidget {
  const TeamPage({super.key});

  @override
  State<TeamPage> createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  String selectedMonth = "Apr";
  String selectedSort = "Newest";
  DateTime? filterSpecificDate;
  String searchQuery = ""; // Menambahkan state untuk pencarian nama

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

  // Data log tim dengan tambahan field image
  final List<Map<String, dynamic>> teamData = [
    {
      "type": "Check In",
      "name": "Dasha Taran",
      "role": "UI/UX Designer",
      "status": "WFO - Approved",
      "date": "Tuesday, 28-04-2026",
      "time": "08:30:15",
      "isCheckIn": true,
      "image": "assets/meme.jpeg",
      "timestamp": DateTime(2026, 4, 28, 8, 30),
    },
    {
      "type": "Check In",
      "name": "Jungkook",
      "role": "Mobile Developer",
      "status": "WFO - Approved",
      "date": "Tuesday, 28-04-2026",
      "time": "08:45:10",
      "isCheckIn": true,
      "image": "assets/meme.jpeg",
      "timestamp": DateTime(2026, 4, 28, 8, 45),
    },
    {
      "type": "Check In",
      "name": "Lalisa M.",
      "role": "Product Manager",
      "status": "WFH - Approved",
      "date": "Tuesday, 28-04-2026",
      "time": "09:00:05",
      "isCheckIn": true,
      "image": "assets/meme.jpeg",
      "timestamp": DateTime(2026, 4, 28, 9, 0),
    },
    {
      "type": "Check Out",
      "name": "Dasha Taran",
      "role": "UI/UX Designer",
      "status": "WFO - Approved",
      "date": "Tuesday, 28-04-2026",
      "time": "17:35:45",
      "isCheckIn": false,
      "image": "assets/meme.jpeg",
      "timestamp": DateTime(2026, 4, 28, 17, 35),
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
                    Text("Filter Team Presence", style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF5D3E3E))),
                    const SizedBox(height: 20),
                    _buildSortOptionItem("Newest", "Latest activities first", Icons.history, setModalState, onTap: () => filterSpecificDate = null),
                    _buildSortOptionItem("Oldest", "Oldest activities first", Icons.update, setModalState, onTap: () => filterSpecificDate = null),
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
    // Processing data: Filter Search + Filter Date + Sort
    List<Map<String, dynamic>> filteredList = teamData.where((element) {
      final nameLower = element['name'].toString().toLowerCase();
      final queryLower = searchQuery.toLowerCase();
      bool matchesSearch = nameLower.contains(queryLower);

      bool matchesDate = true;
      if (selectedSort == "Specific Date" && filterSpecificDate != null) {
        DateTime logDate = element['timestamp'];
        matchesDate = logDate.year == filterSpecificDate!.year &&
            logDate.month == filterSpecificDate!.month &&
            logDate.day == filterSpecificDate!.day;
      }
      return matchesSearch && matchesDate;
    }).toList();

    filteredList.sort((a, b) {
      DateTime dateA = a['timestamp'];
      DateTime dateB = b['timestamp'];
      return selectedSort == "Oldest" ? dateA.compareTo(dateB) : dateB.compareTo(dateA);
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
        title: Text("Team", style: GoogleFonts.nunito(color: AppColors.profileHeaderRed, fontSize: 20, fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextField(
                  onChanged: (value) => setState(() => searchQuery = value),
                  decoration: InputDecoration(
                    hintText: "Search team member name...",
                    hintStyle: GoogleFonts.nunito(color: Colors.grey, fontSize: 13),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),

            // Viewing Period Section
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: SizedBox(
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
            ),

            const SizedBox(height: 10),

            // Header Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Team Presence Today", style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF5D3E3E))),
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
              child: filteredList.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  final log = filteredList[index];
                  return _buildTeamLogCard(
                    type: log["type"],
                    name: log["name"],
                    role: log["role"],
                    status: log["status"],
                    date: log["date"],
                    time: log["time"],
                    isCheckIn: log["isCheckIn"],
                    imagePath: log["image"],
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
          Icon(Icons.people_outline, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text("No team activity found", style: GoogleFonts.nunito(color: Colors.grey, fontSize: 16)),
          TextButton(
            onPressed: () => setState(() { selectedSort = "Newest"; filterSpecificDate = null; searchQuery = ""; }),
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
        boxShadow: [if (isSelected) BoxShadow(color: AppColors.profileHeaderRed.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))],
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

  Widget _buildTeamLogCard({
    required String type,
    required String name,
    required String role,
    required String status,
    required String date,
    required String time,
    required bool isCheckIn,
    required String imagePath,
  }) {
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
            // USER PHOTO REPLACING ICON
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: mainColor.withOpacity(0.3), width: 2),
              ),
              child: CircleAvatar(
                radius: 26,
                backgroundColor: Colors.grey.shade200,
                backgroundImage: AssetImage(imagePath),
                // Fallback jika image error
                onBackgroundImageError: (_, __) {},
                child: null,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(name, style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF5D3E3E))),
                            Text(role, style: GoogleFonts.nunito(fontSize: 11, color: Colors.grey.shade500)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: mainColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(type, style: GoogleFonts.nunito(fontSize: 10, fontWeight: FontWeight.bold, color: mainColor)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        Icon(Icons.location_on_outlined, size: 12, color: Colors.grey.shade400),
                        const SizedBox(width: 4),
                        Text(status, style: GoogleFonts.nunito(fontSize: 11, color: Colors.grey.shade600)),
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