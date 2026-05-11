import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraCapturePage extends StatefulWidget {
  const CameraCapturePage({super.key});

  @override
  State<CameraCapturePage> createState() =>
      _CameraCapturePageState();
}

class _CameraCapturePageState
    extends State<CameraCapturePage> {

  CameraController? _controller;
  List<CameraDescription> _cameras = [];

  int _cameraIndex = 1;

  bool _isReady = false;

  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
    );

    _initCamera();
  }

  @override
  void dispose() {

    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
    );

    _controller?.dispose();

    super.dispose();
  }

  Future<void> _initCamera() async {
    final status = await Permission.camera.request();

    if (!status.isGranted) return;

    _cameras = await availableCameras();

    if (_cameras.isEmpty) return;

    int frontIndex = _cameras.indexWhere(
          (camera) =>
      camera.lensDirection ==
          CameraLensDirection.front,
    );

    _cameraIndex = frontIndex != -1 ? frontIndex : 0;

    await _startCamera(_cameraIndex);
  }

  Future<void> _startCamera(int index) async {
    final oldController = _controller;

    if (oldController != null) {
      await oldController.dispose();
    }

    final controller = CameraController(
      _cameras[index],
      ResolutionPreset.high,
      enableAudio: false,
    );

    _controller = controller;

    await controller.initialize();

    if (!mounted) return;

    setState(() {
      _isReady = true;
    });
  }

  Future<void> _switchCamera() async {
    if (_cameras.length < 2) return;

    _cameraIndex =
        (_cameraIndex + 1) % _cameras.length;

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

          /// FULLSCREEN CAMERA
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

          /// TOP BAR
          Positioned(
            top: 50,
            left: 20,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.close,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),

          /// SWITCH CAMERA
          Positioned(
            top: 50,
            right: 20,
            child: IconButton(
              onPressed: _switchCamera,
              icon: const Icon(
                Icons.flip_camera_ios,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),

          /// CAPTURE BUTTON
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
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 5,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      )
          : const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}