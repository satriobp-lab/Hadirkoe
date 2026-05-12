import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:camera/camera.dart';
import '../../core/app_colors.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import '../../cameracapture/camera_capture_page.dart';
import 'package:permission_handler/permission_handler.dart';

class ConfirmCheckOutPage extends StatefulWidget {
  const ConfirmCheckOutPage({super.key});

  @override
  State<ConfirmCheckOutPage> createState() => _ConfirmCheckOutPageState();
}

class _ConfirmCheckOutPageState extends State<ConfirmCheckOutPage> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  int _selectedCameraIndex = 1; // Default kamera depan
  bool _isCameraActive = false;
  bool _isCameraInitialized = false;

  XFile? _capturedImage;

  String _selectedAbsenceType = 'Work From Office - WFO';
  final TextEditingController _infoController = TextEditingController();

  // Fungsi untuk mengaktifkan kamera saat icon diklik
  Future<void> _activateCamera() async {
    try {
      // Request camera permission
      final status = await Permission.camera.request();

      if (!status.isGranted) {
        _showErrorSnackBar("Camera permission denied");
        return;
      }

      // Get available cameras
      _cameras = await availableCameras();

      if (_cameras == null || _cameras!.isEmpty) {
        _showErrorSnackBar("No camera found");
        return;
      }

      // Cari kamera depan
      int frontCamIndex = _cameras!.indexWhere(
            (cam) => cam.lensDirection == CameraLensDirection.front,
      );

      // Fallback kalau tidak ada kamera depan
      _selectedCameraIndex =
      frontCamIndex != -1 ? frontCamIndex : 0;

      await _onNewCameraSelected(
        _cameras![_selectedCameraIndex],
      );

      if (mounted) {
        setState(() {
          _isCameraActive = true;
        });
      }
    } catch (e) {
      debugPrint("Error activating camera: $e");

      _showErrorSnackBar(
        "Failed to open camera on this device",
      );
    }
  }

  Future<void> _onNewCameraSelected(CameraDescription cameraDescription) async {
    // Hapus controller lama jika ada
    final oldController = _controller;
    if (oldController != null) {
      _controller = null;
      await oldController.dispose();
    }

    final CameraController cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    _controller = cameraController;

    try {
      await cameraController.initialize();
      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      debugPrint("Camera initialization error: $e");
      _showErrorSnackBar("Error: $e");
    }
  }

  void _toggleCamera() {
    if (_cameras == null || _cameras!.length < 2) return;
    _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras!.length;
    _onNewCameraSelected(_cameras![_selectedCameraIndex]);
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
    );
  }

  @override
  void dispose() {

    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
    );

    _controller?.dispose();
    _infoController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.profileHeaderRed,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Confirm Check Out",
          style: GoogleFonts.nunito(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 30),
        child: Column(
          children: [
            // Profile / Camera Section
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Circular View
                  SizedBox(
                    width: double.infinity,
                    height: 320,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [

                        /// FULL WIDTH BLUR BACKGROUND
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 220,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F5F5),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 15,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: _capturedImage != null
                                ? ClipRRect(
                              child: Stack(
                                fit: StackFit.expand,
                                children: [

                                  /// IMAGE
                                  Image.file(
                                    File(_capturedImage!.path),
                                    fit: BoxFit.cover,
                                  ),

                                  /// BLUR
                                  BackdropFilter(
                                    filter: ImageFilter.blur(
                                      sigmaX: 18,
                                      sigmaY: 18,
                                    ),
                                    child: Container(
                                      color: Colors.black.withOpacity(0.25),
                                    ),
                                  ),

                                  /// DARK OVERLAY
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black.withOpacity(0.35),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                                : Container(
                              color: const Color(0xFFF5F5F5),
                            ),
                          ),
                        ),

                        /// PROFILE IMAGE CENTER
                        Positioned(
                          top: 70,
                          child: Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: _capturedImage != null
                                  ? Image.file(
                                File(_capturedImage!.path),
                                fit: BoxFit.cover,
                              )
                                  : Container(
                                color: Colors.grey.shade200,
                                child: Icon(
                                  Icons.person,
                                  size: 100,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Face Guide Overlay
                  if (_isCameraActive)
                    IgnorePointer(
                      child: Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.5),
                            width: 2,
                            style: BorderStyle.solid,
                          ),
                        ),
                      ),
                    ),

                  /// CAMERA ICON BUTTON
                  Positioned(
                    top: 215,
                    right: MediaQuery.of(context).size.width / 2 - 85,
                    child: GestureDetector(
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CameraCapturePage(),
                          ),
                        );

                        if (result != null && result is XFile) {
                          setState(() {
                            _capturedImage = result;
                          });
                        }
                      },
                      child: Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: AppColors.profileHeaderRed,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel("Type Absence"),
                  const SizedBox(height: 8),
                  _buildDropdownField(),

                  const SizedBox(height: 20),

                  _buildLabel("Information"),
                  const SizedBox(height: 8),
                  _buildInputField(
                    controller: _infoController,
                    hint: "Add notes (e.g. Visiting client, Meeting)",
                    icon: Icons.info_outline,
                  ),

                  const SizedBox(height: 20),

                  _buildLabel("Location"),
                  const SizedBox(height: 8),
                  _buildStaticInfoTile(
                    icon: Icons.map_outlined,
                    value: "Sahid Sudirman Center, Lantai 15, Jl. Jend Sudirman No. 86",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Final Confirm Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    // Logic: Validate and Submit
                    if (!_isCameraActive) {
                      _showErrorSnackBar("Please take a photo first");
                      return;
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.profileHeaderRed,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    "Check Out Now",
                    style: GoogleFonts.nunito(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF5D3E3E),
      ),
    );
  }

  Widget _buildDropdownField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8F8),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.profileHeaderRed.withOpacity(0.1)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedAbsenceType,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.profileHeaderRed),
          onChanged: (String? newValue) {
            setState(() {
              _selectedAbsenceType = newValue!;
            });
          },
          items: <String>['Work From Office - WFO', 'Work From Client - WFC', 'Work From Home - WFH']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF5D3E3E),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8F8),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.profileHeaderRed.withOpacity(0.1)),
      ),
      child: TextField(
        controller: controller,
        style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.nunito(color: Colors.grey.shade400, fontSize: 13),
          prefixIcon: Icon(icon, color: AppColors.profileHeaderRed, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        ),
      ),
    );
  }

  Widget _buildStaticInfoTile({required IconData icon, required String value}) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey, size: 20),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.nunito(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}