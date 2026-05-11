import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadirkoe/contact/contact_page.dart';
import 'package:hadirkoe/offlinemode/offlinemode_page.dart';
import '../profile/profile_page.dart';
import '../settings/settings_page.dart';

class BurgerMenuDrawer extends StatelessWidget {
  const BurgerMenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
      ),
      child: Column(
        children: [
          // Header Section
          _buildDrawerHeader(),

          const Divider(indent: 20, endIndent: 20, thickness: 1, height: 1),

          // Menu Items Section
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 10),
              children: [
                _buildMenuItem(Icons.person_outline, "Profile", () {
                  Navigator.pop(context); // Tutup drawer dulu
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfilePage()),
                  );
                }),
                _buildMenuItem(Icons.settings_outlined, "Settings", () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SettingsPage()),
                  );
                }),
                _buildMenuItem(Icons.wifi_off_outlined, "Offline Mode", () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const OfflineModePage()),
                  );
                }),
                _buildMenuItem(Icons.phone_outlined, "Contact Us", () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ContactPage()),
                  );
                }),
                _buildMenuItem(Icons.play_circle_outline, "Tutorials", () {}),
                _buildMenuItem(Icons.arrow_circle_left_outlined, "Back", () {
                  Navigator.pop(context);
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
      child: Row(
        children: [
          // Profile Image
          Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade200, width: 2),
              image: const DecorationImage(
                image: AssetImage("assets/person-image-removebg-preview.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 15),
          // Name & Email
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Satrio Budi Pamungkas",
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF5D3E3E),
                  ),
                ),
                Text(
                  "satrio@edi-indonesia.co.id",
                  style: GoogleFonts.nunito(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 2),
      leading: Icon(
        icon,
        color: const Color(0xFF5D3E3E),
        size: 24,
      ),
      title: Text(
        title,
        style: GoogleFonts.nunito(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF5D3E3E),
        ),
      ),
    );
  }
}