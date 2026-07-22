import 'dart:ui';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadirkoe/activity/activity_page.dart';
import 'package:hadirkoe/log/log_page.dart';
import 'package:hadirkoe/more/officialduty/officialduty_page.dart';
import 'package:hadirkoe/more/overtime/overtime_page.dart';
import 'package:hadirkoe/presence/presence_page.dart';
import 'package:hadirkoe/selfie/selfie_page.dart';
import 'package:hadirkoe/sitevisit/sitevisit_page.dart';
import 'package:hadirkoe/team/team_page.dart';
import 'package:hadirkoe/timesheet/timesheet_page.dart';
import '../core/app_colors.dart';
import '../menu/burger_menu_drawer.dart';
import '../checkin/checkin_page.dart';
import '../checkout/checkout_page.dart';
import 'package:hadirkoe/more/permit/permit_page.dart';
import 'package:hadirkoe/more/sick/sick_page.dart';
import 'package:hadirkoe/more/leave/leave_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final PageController _bannerController = PageController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // Untuk kontrol drawer
  int _currentBanner = 0;
  late Timer _timer;

  final List<String> _banners = [
    "assets/Mobile apps banner.png",
    "assets/dining banner.png",
    "assets/reporting banner.png",
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (_currentBanner < _banners.length - 1) {
        _currentBanner++;
      } else {
        _currentBanner = 0;
      }

      if (_bannerController.hasClients) {
        _bannerController.animateToPage(
          _currentBanner,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _bannerController.dispose();
    super.dispose();
  }

  // FUNGSIONAL: Menampilkan Bottom Sheet Menu "More" dengan tinggi pas sesuai jumlah item (fit content)
  void _showMoreMenuBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Mengaktifkan kontrol ukuran penuh jika dibutuhkan
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFFFCFCFD), // Off-white modern background
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min, // KUNCI UTAMA: Tinggi container menyesuaikan konten (tidak fix 75%)
              children: [
                // Drag Handle Indicator yang stylish
                const SizedBox(height: 12),
                Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 20),

                // Header Permissions dengan desain minimalis
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Permissions",
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF422F35), // Dark rose brown
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          shape: BoxShape.circle,
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 15),

                // Menu list yang dibungkus Flexible & SingleChildScrollView (aman untuk layar kecil agar tidak overflow)
                Flexible(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min, // Menghindari ruang kosong di bawah
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- Section: Permissions ---
                        _buildPermissionItem(
                          title: "Permit",
                          subtitle: "Submission for work permit.",
                          icon: Icons.contact_mail_outlined,
                          onTap: () {
                            Navigator.pop(context); // Menutup bottom sheet terlebih dahulu
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const PermitPage(), // Berpindah ke halaman PermitPage di Canvas
                              ),
                            );
                          },
                        ),
                        _buildPermissionItem(
                          title: "Sick",
                          subtitle: "Submission for work sick.",
                          icon: Icons.sick_outlined,
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SickPage(),
                              ),
                            );
                          },
                        ),
                        _buildPermissionItem(
                          title: "Leave",
                          subtitle: "Submission for work leave paid.",
                          icon: Icons.front_hand_outlined,
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LeavePage(),
                              ),
                            );
                          },
                        ),
                        _buildPermissionItem(
                          title: "Official Duty",
                          subtitle: "Submission for work official duty.",
                          icon: Icons.directions_car_outlined,
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const OfficialDutyPage(),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 20),

                        // --- Section: Others Services ---
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Text(
                            "Others services",
                            style: GoogleFonts.nunito(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF422F35),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),

                        _buildPermissionItem(
                          title: "Overtime",
                          subtitle: "Submission for work overtime.",
                          icon: Icons.more_time_rounded,
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const OvertimePage(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20), // Memberikan padding aman di bagian bawah
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // UI HELPER: Membuat Item Baris Menu di Bottom Sheet (Sangat Modern)
  Widget _buildPermissionItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.profileHeaderRed.withOpacity(0.06),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          splashColor: AppColors.profileHeaderRed.withOpacity(0.05),
          highlightColor: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Squircle Gradasi Modern untuk Wadah Ikon
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.profileHeaderRed.withOpacity(0.08),
                        AppColors.profileHeaderRed.withOpacity(0.01),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.profileHeaderRed.withOpacity(0.12),
                      width: 1.2,
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: AppColors.profileHeaderRed,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),

                // Deskripsi Menu Tengah
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF422F35),
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        style: GoogleFonts.nunito(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                // Trailing Chevron minimalis sebagai indikator klik
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.grey.shade400,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showFeatureUnderDevelopmentSnackbar(String featureName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("$featureName submission feature is under development."),
        backgroundColor: AppColors.profileHeaderRed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Pasang key
      endDrawer: const BurgerMenuDrawer(), // Panggil class drawer di sini
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Column(
                  children: [
                    _buildHeader(),
                    _buildBannerSlider(),
                    _buildSummarySection(),
                    _buildCheckInOutSection(),
                    _buildPresenceGrid(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      children: [
        // Background Image
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.28,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(0),
              bottomRight: Radius.circular(0),
            ),
            child: Image.asset(
              "assets/banner_hadirkoe.png",
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Overlay Gradient for readability
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.28,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.3),
                Colors.transparent,
              ],
            ),
          ),
          padding: const EdgeInsets.fromLTRB(25, 45, 25, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hello,",
                        style: GoogleFonts.nunito(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        "Satrio Budi Pamungkas",
                        style: GoogleFonts.nunito(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        "Business Development",
                        style: GoogleFonts.nunito(
                          fontSize: 11,
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  // ACTION: Buka drawer saat icon diklik
                  IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white, size: 30),
                    onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: _buildStatusBadge(
                      "Clouds 32°C",
                      icon: Icons.cloud_outlined,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    flex: 2,
                    child: _buildStatusBadge(
                      "prepare an umbrella or raincoat",
                      icon: Icons.info_outline,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  // UPDATED: Modern Glass Badge with Icon
  Widget _buildStatusBadge(String text, {IconData? icon}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2), // Semi-transparent white
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 0.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max, // 🔥 penting
              children: [
                if (icon != null) ...[
                  Icon(icon, color: Colors.white, size: 14),
                  const SizedBox(width: 6),
                ],
                Expanded( // 🔥 ini kunci
                  child: Text(
                    text,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis, // 🔥 biar ga nabrak
                    style: GoogleFonts.nunito(
                      color: Colors.white,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            )
        ),
      ),
    );
  }

  Widget _buildBannerSlider() {
    return Transform.translate(
      offset: Offset(0, -MediaQuery.of(context).size.height * 0.08),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.18,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            PageView.builder(
              controller: _bannerController,
              onPageChanged: (index) => setState(() => _currentBanner = index),
              itemCount: _banners.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(17),
                    child: Image.asset(
                      _banners[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _banners.asMap().entries.map((entry) {
                  return Container(
                    width: _currentBanner == entry.key ? 12.0 : 6.0,
                    height: 6.0,
                    margin: const EdgeInsets.symmetric(horizontal: 3.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: _currentBanner == entry.key
                          ? Colors.white
                          : Colors.white.withOpacity(0.5),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummarySection() {
    return Transform.translate(
      offset: Offset(0, -MediaQuery.of(context).size.height * 0.06),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: Text(
              "Summary",
              style: GoogleFonts.nunito(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.brown[600],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            height: MediaQuery.of(context).size.height * 0.18,
            child: Stack(
              children: [
                // Base Card
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFC73FA0),
                        Color(0xFFB43792),
                        Color(0xFF9F2F82),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                ),

                // Background Icons
                Positioned(
                  right: -10,
                  bottom: -10,
                  child: Transform.rotate(
                    angle: -0.2,
                    child: Icon(
                      Icons.analytics_rounded,
                      size: 100,
                      color: Colors.white.withOpacity(0.06),
                    ),
                  ),
                ),

                Positioned(
                  left: -20,
                  top: -20,
                  child: Icon(
                    Icons.bar_chart_rounded,
                    size: 80,
                    color: Colors.white.withOpacity(0.04),
                  ),
                ),

                // Glass overlay
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.03),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.10),
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ),

                // Content
                Padding(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    children: [
                      Text(
                        "Your summary in this month",
                        style: GoogleFonts.nunito(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 15.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        height: 2,
                        width: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.0),
                              Colors.white.withOpacity(0.5),
                              Colors.white.withOpacity(0.0),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildSummaryItem("15", "Check-In"),
                          _buildSummaryItem("15", "Check-Out"),
                          _buildSummaryItem("12", "Late"),
                          _buildSummaryItem("14", "Task"),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.nunito(
              color: Colors.white.withOpacity(0.9),
              fontSize: 12,
              fontWeight: FontWeight.w700
          ),
        ),
      ],
    );
  }

  Widget _buildCheckInOutSection() {
    return Transform.translate(
      offset: Offset(0, -MediaQuery.of(context).size.height * 0.045),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Expanded(child: _buildTimeCard(
              "Check-In Today",
              "08:13:28",
              const [Color(0xFFC8446A), Color(0xFFB1395A)],
              shouldFlip: true,
            )),
            const SizedBox(width: 15),
            Expanded(child: _buildTimeCard(
              "Check-Out Today",
              "18:13:28",
              const [Color(0xFFD694B3), Color(0xFFC582A2)],
              shouldFlip: false,
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeCard(String title, String time, List<Color> colors, {required bool shouldFlip}) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colors[0].withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          )
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            right: -10,
            bottom: -10,
            child: Icon(
              Icons.access_time_filled,
              size: 60,
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Transform(
                    alignment: Alignment.center,
                    transform: shouldFlip
                        ? Matrix4.diagonal3Values(-1, 1, 1)
                        : Matrix4.identity(),
                    child: const Icon(Icons.access_time, color: Colors.white, size: 20),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                    title,
                    style: GoogleFonts.nunito(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 11,
                        fontWeight: FontWeight.w600
                    )
                ),
                Text(
                    time,
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5
                    )
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPresenceGrid() {
    return Transform.translate(
      offset: const Offset(0, -25),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5, bottom: 15),
              child: Text(
                "Presence",
                style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown[600]
                ),
              ),
            ),
            _buildGridContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildGridContent() {
    final List<Map<String, dynamic>> menus = [
      {
        "icon": Icons.access_time,
        "label": "Check-In",
        "shouldFlip": true,
        "bgColor": const Color(0xFFFFF1F1),
        "onTap": () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CheckInPage(),
            ),
          );
        },
      },
      {
        "icon": Icons.access_time,
        "label": "Check-Out",
        "shouldFlip": false,
        "bgColor": const Color(0xFFFFF1F1),
        "onTap": () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CheckOutPage(),
            ),
          );
        },
      },
      {
        "icon": Icons.history,
        "label": "Log",
        "shouldFlip": false,
        "bgColor": const Color(0xFFF1F7FF),
        "onTap": () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const LogPage(),
            ),
          );
        },
      },
      {
        "icon": Icons.groups_outlined,
        "label": "Team",
        "shouldFlip": false,
        "bgColor": const Color(0xFFF1F7FF),
        "onTap": () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const TeamPage(),
            ),
          );
        },
      },
      {
        "icon": Icons.camera_front,
        "label": "Selfie",
        "shouldFlip": false,
        "bgColor": const Color(0xFFF1FFF4),
        "onTap": () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const SelfiePage(),
            ),
          );
        },
      },
      {
        "icon": Icons.calendar_month_outlined,
        "label": "Presence",
        "shouldFlip": false,
        "bgColor": const Color(0xFFF1FFF4),
        "onTap": () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const PresencePage(),
            ),
          );
        },
      },
      {
        "icon": Icons.task_outlined,
        "label": "Activity",
        "shouldFlip": false,
        "bgColor": const Color(0xFFFFF9F1),
        "onTap": () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ActivityPage(),
            ),
          );
        },
      },
      {
        "icon": Icons.assignment_outlined,
        "label": "Timesheet",
        "shouldFlip": false,
        "bgColor": const Color(0xFFFFF9F1),
        "onTap": () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const TimesheetPage(),
            ),
          );
        },
      },
      {
        "icon": Icons.location_on_outlined,
        "label": "Site Visit",
        "shouldFlip": false,
        "bgColor": const Color(0xFFF5F5F5),
        "onTap": () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const SiteVisitPage(),
            ),
          );
        },
      },
      {
        "icon": Icons.more_horiz,
        "label": "More",
        "shouldFlip": false,
        "bgColor": const Color(0xFFF5F5F5),
        "onTap": () {
          _showMoreMenuBottomSheet(context); // FUNGSIONAL: Membuka bottom sheet panel More
        },
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 15,
        crossAxisSpacing: 10,
        childAspectRatio: 0.85,
      ),
      itemCount: menus.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: menus[index]['onTap'],
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: menus[index]['bgColor'],
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    )
                  ],
                ),
                child: Transform(
                  alignment: Alignment.center,
                  transform: menus[index]['shouldFlip'] == true
                      ? Matrix4.diagonal3Values(-1, 1, 1)
                      : Matrix4.identity(),
                  child: Icon(
                      menus[index]['icon'],
                      color: AppColors.primaryRed,
                      size: 26
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                menus[index]['label'],
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.nunito(
                    fontSize: 10.5,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}