import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart'; // Membutuhkan package file_picker di pubspec.yaml
import '../../core/app_colors.dart';
import '../../core/widgets/button_behaviour.dart';

class EditSiteVisitPage extends StatefulWidget {
  final Map<String, dynamic>? siteVisitData; // Parameter data untuk di-edit

  const EditSiteVisitPage({super.key, this.siteVisitData});

  @override
  State<EditSiteVisitPage> createState() => _EditSiteVisitPageState();
}

class _EditSiteVisitPageState extends State<EditSiteVisitPage> {
  final TextEditingController _findSiteVisitController = TextEditingController();
  final TextEditingController _progressController = TextEditingController();
  final TextEditingController _infoController = TextEditingController();
  final TextEditingController _planningDateController = TextEditingController();

  String? _selectedJob;
  String? _selectedClient;

  // List untuk menyimpan file yang dipilih (baik dari kamera maupun storage)
  final List<PlatformFile> _selectedFiles = [];

  final List<String> _jobProjects = ["Hadirkoe", "Hadirkoe Mobile", "Internal Project"];
  final List<String> _clients = ["PT EDII", "PT Pelindo", "Kementerian BUMN"];

  @override
  void initState() {
    super.initState();
    _prepopulateData();
  }

  // Fungsi untuk mengisi otomatis field dari data yang dilempar
  void _prepopulateData() {
    if (widget.siteVisitData != null) {
      final data = widget.siteVisitData!;

      _findSiteVisitController.text = ""; // Pencarian default kosong

      // Pilih project yang cocok di list dropdown
      if (_jobProjects.contains(data['project'])) {
        _selectedJob = data['project'];
      }

      // Pilih client yang cocok di list dropdown
      if (_clients.contains(data['client'])) {
        _selectedClient = data['client'];
      }

      // Mengubah progress decimal (misal: 1.0) menjadi persentase bulat (100)
      if (data['progress'] != null) {
        _progressController.text = (data['progress'] * 100).toInt().toString();
      }

      _infoController.text = data['description'] ?? "";

      if (data['timestamp'] != null) {
        _planningDateController.text = DateFormat('EEEE, dd-MM-yyyy').format(data['timestamp']);
      }

      // Simulasi inisiasi file lama yang sudah di-upload sebelumnya jika ada
      if (data['images'] != null) {
        for (var imgPath in data['images']) {
          _selectedFiles.add(PlatformFile(
            name: imgPath.split('/').last,
            size: 1024 * 500, // Dummy size 500KB
            path: imgPath,
          ));
        }
      }
    }
  }

  @override
  void dispose() {
    _findSiteVisitController.dispose();
    _progressController.dispose();
    _infoController.dispose();
    _planningDateController.dispose();
    super.dispose();
  }

  // Fungsi untuk memilih file menggunakan file_picker
  Future<void> _pickFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.any, // Bisa gambar, pdf, doc, dll
      );

      if (result != null) {
        setState(() {
          if (_selectedFiles.length + result.files.length <= 5) {
            _selectedFiles.addAll(result.files);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Max 5 files allowed")),
            );
          }
        });
      }
    } catch (e) {
      debugPrint("Error picking files: $e");
    }
  }

  // Fungsi untuk membuka halaman Kamera
  Future<void> _openCamera() async {
    final XFile? result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CameraCapturePage()),
    );

    if (result != null) {
      setState(() {
        if (_selectedFiles.length < 5) {
          _selectedFiles.add(PlatformFile(
            name: result.name,
            path: result.path,
            size: 0, // Size opsional untuk simulasi
          ));
        }
      });
    }
  }

  // Fungsi untuk memanggil DatePicker dengan format EEEE, dd-MM-yyyy
  Future<void> _selectPlanningDate() async {
    DateTime initial = DateTime.now();
    if (widget.siteVisitData != null && widget.siteVisitData!['timestamp'] != null) {
      initial = widget.siteVisitData!['timestamp'];
    }

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.profileHeaderRed,
            onPrimary: Colors.white,
            onSurface: Color(0xFF5D3E3E),
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        _planningDateController.text = DateFormat('EEEE, dd-MM-yyyy').format(picked);
      });
    }
  }

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
          "Edit Site Visit",
          style: GoogleFonts.nunito(
            color: AppColors.profileHeaderRed,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            _buildSearchField(),
            const SizedBox(height: 20),

            // Job / Project Dropdown
            _buildLabel("Job / Project*"),
            _buildDropdownField(
              hint: "Job / Project",
              value: _selectedJob,
              items: _jobProjects,
              onChanged: (newValue) => setState(() => _selectedJob = newValue),
            ),
            const SizedBox(height: 15),

            // Client Dropdown
            _buildLabel("Client*"),
            _buildDropdownField(
              hint: "Client",
              value: _selectedClient,
              items: _clients,
              onChanged: (newValue) => setState(() => _selectedClient = newValue),
            ),
            const SizedBox(height: 15),

            // Progress Field
            _buildLabel("Progress (%)*"),
            _buildInputField(
              controller: _progressController,
              hintText: "Progress",
              suffixText: "%",
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 15),

            // Information Field
            _buildLabel("Information*"),
            _buildInputField(
              controller: _infoController,
              hintText: "Information...",
              maxLines: 4,
            ),
            const SizedBox(height: 15),

            // Planning Date Field
            _buildLabel("Planning Date*"),
            _buildInputField(
              controller: _planningDateController,
              hintText: "Planning Date",
              readOnly: true,
              onTap: _selectPlanningDate,
            ),
            const SizedBox(height: 15),

            _buildLabel("Files"),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildFileUploadButton(Icons.note_add_outlined, onTap: _pickFiles),
                const SizedBox(width: 15),
                _buildFileUploadButton(Icons.camera_alt_outlined, onTap: _openCamera),
              ],
            ),

            // Preview File terpilih
            if (_selectedFiles.isNotEmpty) ...[
              const SizedBox(height: 15),
              ..._selectedFiles.map((file) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade200)
                ),
                child: Row(
                  children: [
                    const Icon(Icons.attach_file, size: 18, color: AppColors.profileHeaderRed),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(file.name, style: GoogleFonts.nunito(fontSize: 12, color: const Color(0xFF5D3E3E))),
                    ),
                    GestureDetector(
                      onTap: () => setState(() => _selectedFiles.remove(file)),
                      child: const Icon(Icons.close, size: 18, color: Colors.red),
                    )
                  ],
                ),
              )).toList(),
            ],

            const SizedBox(height: 12),
            Text("*Max file upload is 5 files.", style: GoogleFonts.nunito(fontSize: 11, color: Colors.grey.shade600, fontStyle: FontStyle.italic)),
            Text("*Max for each file upload is 5 MB.", style: GoogleFonts.nunito(fontSize: 11, color: Colors.grey.shade600, fontStyle: FontStyle.italic)),

            const SizedBox(height: 30),

            // Tombol Simpan Perubahan dengan ButtonBehaviour
            ButtonBehaviour(
              text: "Save Changes",
              isProfileHeader: true, // Menggunakan gaya Maroon/Red Profile
              onPressed: () {
                debugPrint("Site Visit Changes Saved Successfully");
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 2),
      child: Text(
        text,
        style: GoogleFonts.nunito(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF5D3E3E),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade300)),
      child: TextField(
        controller: _findSiteVisitController,
        decoration: InputDecoration(
          hintText: "Find Site Visit..",
          hintStyle: GoogleFonts.nunito(color: Colors.grey.shade400, fontSize: 14),
          suffixIcon: Icon(Icons.search, color: Colors.grey.shade600),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
    String? suffixText,
    bool readOnly = false,
    VoidCallback? onTap,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.profileHeaderRed.withOpacity(0.2)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        readOnly: readOnly,
        onTap: onTap,
        keyboardType: keyboardType,
        style: GoogleFonts.nunito(fontSize: 14, color: const Color(0xFF5D3E3E)),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.nunito(color: Colors.grey.shade400, fontSize: 13),
          suffixText: suffixText,
          suffixStyle: GoogleFonts.nunito(color: Colors.grey.shade500, fontWeight: FontWeight.bold),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.profileHeaderRed.withOpacity(0.2)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text(hint, style: GoogleFonts.nunito(color: Colors.grey.shade400, fontSize: 13)),
          value: value,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.profileHeaderRed),
          items: items.map((String val) => DropdownMenuItem<String>(value: val, child: Text(val, style: GoogleFonts.nunito(fontSize: 14)))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildFileUploadButton(IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppColors.profileHeaderRed.withOpacity(0.2)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 5, offset: const Offset(0, 2))],
        ),
        child: Icon(icon, color: AppColors.profileHeaderRed, size: 28),
      ),
    );
  }
}

class CameraCapturePage extends StatefulWidget {
  const CameraCapturePage({super.key});

  @override
  State<CameraCapturePage> createState() => _CameraCapturePageState();
}

class _CameraCapturePageState extends State<CameraCapturePage> {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  int _cameraIndex = 1;
  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _initCamera();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _initCamera() async {
    final status = await Permission.camera.request();
    if (!status.isGranted) return;

    _cameras = await availableCameras();
    if (_cameras.isEmpty) return;

    int frontIndex = _cameras.indexWhere((camera) => camera.lensDirection == CameraLensDirection.front);
    _cameraIndex = frontIndex != -1 ? frontIndex : 0;
    await _startCamera(_cameraIndex);
  }

  Future<void> _startCamera(int index) async {
    final oldController = _controller;
    if (oldController != null) await oldController.dispose();

    final controller = CameraController(_cameras[index], ResolutionPreset.high, enableAudio: false);
    _controller = controller;
    await controller.initialize();
    if (!mounted) return;
    setState(() => _isReady = true);
  }

  Future<void> _switchCamera() async {
    if (_cameras.length < 2) return;
    _cameraIndex = (_cameraIndex + 1) % _cameras.length;
    await _startCamera(_cameraIndex);
  }

  Future<void> _takePicture() async {
    if (_controller == null) return;
    final image = await _controller!.takePicture();
    if (!mounted) return;
    Navigator.pop(context, image);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isReady && _controller != null
          ? Stack(
        children: [
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller!.value.previewSize!.height,
                height: _controller!.value.previewSize!.width,
                child: CameraPreview(_controller!),
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: 20,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close, color: Colors.white, size: 30),
            ),
          ),
          Positioned(
            top: 50,
            right: 20,
            child: IconButton(
              onPressed: _switchCamera,
              icon: const Icon(Icons.flip_camera_ios, color: Colors.white, size: 30),
            ),
          ),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: _takePicture,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 5)),
                ),
              ),
            ),
          ),
        ],
      )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}