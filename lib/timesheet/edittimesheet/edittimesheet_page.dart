import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../cameracapture/camera_capture_page.dart';
import '../../core/app_colors.dart';
import '../../core/widgets/button_behaviour.dart';

class EditTimesheetPage extends StatefulWidget {
  final Map<String, dynamic> timesheetData;

  const EditTimesheetPage({
    super.key,
    required this.timesheetData,
  });

  @override
  State<EditTimesheetPage> createState() =>
      _EditTimesheetPageState();
}

class _EditTimesheetPageState
    extends State<EditTimesheetPage> {
  final TextEditingController _findActivityController =
  TextEditingController();

  final TextEditingController _progressController =
  TextEditingController();

  final TextEditingController _infoController =
  TextEditingController();

  final TextEditingController _dateController =
  TextEditingController();

  final TextEditingController _timeController =
  TextEditingController();

  final TextEditingController _hoursController =
  TextEditingController();

  final TextEditingController _minutesController =
  TextEditingController();

  final TextEditingController _countOutputController =
  TextEditingController();

  final TextEditingController
  _totalCompletionTimeController =
  TextEditingController(text: "0 Minutes");

  bool _isSetDateChecked = true;

  String? _selectedJob;
  String? _selectedCategory;
  String? _selectedProcess;
  String? _selectedTransport;
  String? _selectedLocation;

  final List<PlatformFile> _selectedFiles = [];

  final List<String> _jobProjects = [
    "Hadirkoe",
    "Hadirkoe Mobile",
    "Internal Project"
  ];

  final List<String> _jobCategories = [
    "Development",
    "Design UI/UX",
    "Testing/QA",
    "Meeting"
  ];

  final List<String> _jobProcesses = [
    "Coding",
    "Slicing",
    "Wireframing",
    "Bug Fixing",
    "Deployment"
  ];

  final List<String> _transports = [
    "None",
    "Car",
    "Motorcycle",
    "Public Transport"
  ];

  final List<String> _jobLocations = [
    "Jakarta Office",
    "Surabaya Branch",
    "Home (WFH)",
    "Client Site"
  ];

  @override
  void initState() {
    super.initState();

    _hoursController.addListener(_calculateTotalTime);
    _minutesController.addListener(_calculateTotalTime);

    final data = widget.timesheetData;

    _findActivityController.text =
        data["project"] ?? "";

    _selectedJob = _jobProjects.contains(data["project"])
        ? data["project"]
        : _jobProjects.first;

    _selectedCategory =
    _jobCategories.contains(data["category"])
        ? data["category"]
        : _jobCategories.first;

    _selectedProcess =
    _jobProcesses.contains(data["process"])
        ? data["process"]
        : _jobProcesses.first;

    _selectedTransport =
    _transports.contains(data["transport"])
        ? data["transport"]
        : _transports.first;

    _selectedLocation =
    _jobLocations.contains(data["location"])
        ? data["location"]
        : _jobLocations.first;

    _progressController.text =
        ((data["progress"] ?? 0.0) * 100)
            .toInt()
            .toString();

    _infoController.text =
        data["description"] ?? "";

    _hoursController.text = "8";
    _minutesController.text = "0";

    _countOutputController.text = "1";

    _calculateTotalTime();

    DateTime timestamp =
        data["timestamp"] ?? DateTime.now();

    _dateController.text =
        DateFormat('dd MMMM yyyy')
            .format(timestamp);

    _timeController.text =
        DateFormat('hh:mm a')
            .format(timestamp);

    if (data["images"] != null) {
      for (var image in data["images"]) {
        _selectedFiles.add(
          PlatformFile(
            name:
            image.toString().split('/').last,
            path: image,
            size: 0,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _findActivityController.dispose();
    _progressController.dispose();
    _infoController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _hoursController.dispose();
    _minutesController.dispose();
    _countOutputController.dispose();
    _totalCompletionTimeController.dispose();
    super.dispose();
  }

  void _calculateTotalTime() {
    final int hours =
        int.tryParse(_hoursController.text) ?? 0;

    final int minutes =
        int.tryParse(_minutesController.text) ?? 0;

    final int totalMinutes =
        (hours * 60) + minutes;

    setState(() {
      _totalCompletionTimeController.text =
      "$totalMinutes Minutes";
    });
  }

  Future<void> _pickFiles() async {
    try {
      FilePickerResult? result =
      await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.any,
      );

      if (result != null) {
        setState(() {
          if (_selectedFiles.length +
              result.files.length <=
              5) {
            _selectedFiles.addAll(result.files);
          } else {
            ScaffoldMessenger.of(context)
                .showSnackBar(
              const SnackBar(
                content:
                Text("Max 5 files allowed"),
              ),
            );
          }
        });
      }
    } catch (e) {
      debugPrint("Error picking files: $e");
    }
  }

  Future<void> _openCamera() async {
    final XFile? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CameraCapturePage(),
      ),
    );

    if (result != null) {
      setState(() {
        if (_selectedFiles.length < 5) {
          _selectedFiles.add(
            PlatformFile(
              name: result.name,
              path: result.path,
              size: 0,
            ),
          );
        }
      });
    }
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary:
            AppColors.profileHeaderRed,
            onPrimary: Colors.white,
            onSurface: Color(0xFF5D3E3E),
          ),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      setState(() {
        _dateController.text =
            DateFormat('dd MMMM yyyy')
                .format(picked);
      });
    }
  }

  Future<void> _selectTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary:
            AppColors.profileHeaderRed,
            onPrimary: Colors.white,
            onSurface: Color(0xFF5D3E3E),
          ),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      setState(() {
        _timeController.text =
            picked.format(context);
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
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.profileHeaderRed,
          ),
          onPressed: () =>
              Navigator.pop(context),
        ),
        title: Text(
          "Edit Timesheet",
          style: GoogleFonts.nunito(
            color:
            AppColors.profileHeaderRed,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            _buildSearchField(),

            const SizedBox(height: 20),

            _buildLabel("Job / Project*"),

            _buildDropdownField(
              hint: "Job / Project",
              value: _selectedJob,
              items: _jobProjects,
              onChanged: (val) {
                setState(() {
                  _selectedJob = val;
                });
              },
            ),

            const SizedBox(height: 15),

            _buildLabel("Job Category*"),

            _buildDropdownField(
              hint: "Job Category",
              value: _selectedCategory,
              items: _jobCategories,
              onChanged: (val) {
                setState(() {
                  _selectedCategory = val;
                });
              },
            ),

            const SizedBox(height: 15),

            _buildLabel("Job Process*"),

            _buildDropdownField(
              hint: "Job Process",
              value: _selectedProcess,
              items: _jobProcesses,
              onChanged: (val) {
                setState(() {
                  _selectedProcess = val;
                });
              },
            ),

            const SizedBox(height: 15),

            _buildLabel("Transport*"),

            _buildDropdownField(
              hint: "Transport",
              value: _selectedTransport,
              items: _transports,
              onChanged: (val) {
                setState(() {
                  _selectedTransport = val;
                });
              },
            ),

            const SizedBox(height: 15),

            _buildLabel("Job Location*"),

            _buildDropdownField(
              hint: "Job Location",
              value: _selectedLocation,
              items: _jobLocations,
              onChanged: (val) {
                setState(() {
                  _selectedLocation = val;
                });
              },
            ),

            const SizedBox(height: 15),

            _buildLabel(
                "Output Completion Time"),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                    children: [
                      Text(
                        "Hours*",
                        style:
                        GoogleFonts.nunito(
                          fontSize: 11,
                          fontWeight:
                          FontWeight
                              .w600,
                          color: Colors.grey
                              .shade600,
                        ),
                      ),

                      const SizedBox(
                          height: 4),

                      _buildInputField(
                        controller:
                        _hoursController,
                        hintText:
                        "Hours",
                        keyboardType:
                        TextInputType
                            .number,
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                    children: [
                      Text(
                        "Minutes*",
                        style:
                        GoogleFonts.nunito(
                          fontSize: 11,
                          fontWeight:
                          FontWeight
                              .w600,
                          color: Colors.grey
                              .shade600,
                        ),
                      ),

                      const SizedBox(
                          height: 4),

                      _buildInputField(
                        controller:
                        _minutesController,
                        hintText:
                        "Minutes",
                        keyboardType:
                        TextInputType
                            .number,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            _buildLabel("Count Output*"),

            _buildInputField(
              controller:
              _countOutputController,
              hintText: "Count Output",
              keyboardType:
              TextInputType.number,
            ),

            const SizedBox(height: 15),

            _buildLabel(
                "Total Completion Time Output*"),

            _buildInputField(
              controller:
              _totalCompletionTimeController,
              hintText: "0 Minutes",
              readOnly: true,
            ),

            const SizedBox(height: 15),

            _buildLabel("Progress (%)*"),

            _buildInputField(
              controller: _progressController,
              hintText: "Progress",
              suffixText: "%",
              keyboardType:
              TextInputType.number,
            ),

            const SizedBox(height: 15),

            _buildLabel("Information*"),

            _buildInputField(
              controller: _infoController,
              hintText: "Information..",
              maxLines: 4,
            ),

            const SizedBox(height: 15),

            _buildSetDateToggle(),

            if (_isSetDateChecked) ...[
              _buildLabel("Date*"),

              _buildInputField(
                controller: _dateController,
                hintText: "Date",
                readOnly: true,
                onTap: _selectDate,
              ),

              const SizedBox(height: 15),

              _buildLabel("Time*"),

              _buildInputField(
                controller: _timeController,
                hintText: "Time",
                readOnly: true,
                onTap: _selectTime,
              ),

              const SizedBox(height: 15),
            ],

            _buildLabel("Files"),

            const SizedBox(height: 8),

            Row(
              children: [
                _buildFileUploadButton(
                  Icons.note_add_outlined,
                  onTap: _pickFiles,
                ),

                const SizedBox(width: 15),

                _buildFileUploadButton(
                  Icons.camera_alt_outlined,
                  onTap: _openCamera,
                ),
              ],
            ),

            if (_selectedFiles.isNotEmpty) ...[
              const SizedBox(height: 15),

              ..._selectedFiles.map(
                    (file) => Container(
                  margin:
                  const EdgeInsets.only(
                    bottom: 8,
                  ),
                  padding:
                  const EdgeInsets.all(
                      10),
                  decoration: BoxDecoration(
                    color:
                    Colors.grey.shade50,
                    borderRadius:
                    BorderRadius
                        .circular(10),
                    border: Border.all(
                      color: Colors
                          .grey.shade200,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.attach_file,
                        size: 18,
                        color: AppColors
                            .profileHeaderRed,
                      ),

                      const SizedBox(
                          width: 10),

                      Expanded(
                        child: Text(
                          file.name,
                          style:
                          GoogleFonts
                              .nunito(
                            fontSize: 12,
                            color: const Color(
                                0xFF5D3E3E),
                          ),
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedFiles
                                .remove(
                                file);
                          });
                        },
                        child: const Icon(
                          Icons.close,
                          size: 18,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 12),

            Text(
              "*Max file upload is 5 files.",
              style: GoogleFonts.nunito(
                fontSize: 11,
                color: Colors.grey.shade600,
                fontStyle: FontStyle.italic,
              ),
            ),

            Text(
              "*Max for each file upload is 5 MB.",
              style: GoogleFonts.nunito(
                fontSize: 11,
                color: Colors.grey.shade600,
                fontStyle: FontStyle.italic,
              ),
            ),

            const SizedBox(height: 30),

            ButtonBehaviour(
              text: "Save Changes",
              isProfileHeader: true,
              onPressed: () {
                debugPrint(
                    "Timesheet Updated");
              },
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSetDateToggle() {
    return Row(
      mainAxisAlignment:
      MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Set Date ?",
          style: GoogleFonts.nunito(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF5D3E3E),
          ),
        ),
        Transform.scale(
          scale: 0.9,
          child: Checkbox(
            value: _isSetDateChecked,
            activeColor:
            AppColors.profileHeaderRed,
            shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(4),
            ),
            onChanged: (val) {
              setState(() {
                _isSetDateChecked = val!;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 8,
        left: 2,
      ),
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),
      child: TextField(
        controller: _findActivityController,
        decoration: InputDecoration(
          hintText: "Find Timesheet..",
          hintStyle: GoogleFonts.nunito(
            color: Colors.grey.shade400,
            fontSize: 14,
          ),
          suffixIcon: Icon(
            Icons.search,
            color: Colors.grey.shade600,
          ),
          border: InputBorder.none,
          contentPadding:
          const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 12,
          ),
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
    TextInputType keyboardType =
        TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.profileHeaderRed
              .withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color:
            Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        readOnly: readOnly,
        onTap: onTap,
        keyboardType: keyboardType,
        style: GoogleFonts.nunito(
          fontSize: 14,
          color: const Color(0xFF5D3E3E),
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.nunito(
            color: Colors.grey.shade400,
            fontSize: 13,
          ),
          suffixText: suffixText,
          suffixStyle: GoogleFonts.nunito(
            color: Colors.grey.shade500,
            fontWeight: FontWeight.bold,
          ),
          border: InputBorder.none,
          contentPadding:
          const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 12,
          ),
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
      padding:
      const EdgeInsets.symmetric(
          horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.profileHeaderRed
              .withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color:
            Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text(
            hint,
            style: GoogleFonts.nunito(
              color: Colors.grey.shade400,
              fontSize: 13,
            ),
          ),
          value: value,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color:
            AppColors.profileHeaderRed,
          ),
          items: items.map((String val) {
            return DropdownMenuItem<String>(
              value: val,
              child: Text(
                val,
                style: GoogleFonts.nunito(
                    fontSize: 14),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildFileUploadButton(
      IconData icon, {
        VoidCallback? onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
          BorderRadius.circular(15),
          border: Border.all(
            color: AppColors.profileHeaderRed
                .withOpacity(0.2),
          ),
          boxShadow: [
            BoxShadow(
              color:
              Colors.black.withOpacity(0.02),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: AppColors.profileHeaderRed,
          size: 28,
        ),
      ),
    );
  }
}