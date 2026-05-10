import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:edushare_app/screens/search_result.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';


class AIScanScreen extends StatefulWidget {
  const AIScanScreen({super.key});

  @override
  State<AIScanScreen> createState() => _AIScanScreenState();
}

class _AIScanScreenState extends State<AIScanScreen> {
  CameraController? controller;
  List<CameraDescription>? cameras;


  bool isFlashOn = false;
  bool isRearCamera = true;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  Future<String> scanImage(File file) async {
    final inputImage = InputImage.fromFile(file);
    final textRecognizer = TextRecognizer();

    final RecognizedText result =
    await textRecognizer.processImage(inputImage);

    textRecognizer.close();

    return result.text;
  }

  // ================= INIT CAMERA =================
  Future<void> initCamera() async {
    try {
      cameras = await availableCameras();

      if (cameras == null || cameras!.isEmpty) return;

      final cam = cameras!.first;

      controller = CameraController(
        cam,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await controller!.initialize();

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Camera error: $e");
    }
  }

  // ================= FLASH =================
  void toggleFlash() async {
    if (controller == null) return;

    isFlashOn = !isFlashOn;

    await controller!.setFlashMode(
      isFlashOn ? FlashMode.torch : FlashMode.off,
    );

    setState(() {});
  }

  // ================= FLIP CAMERA =================
  Future<void> flipCamera() async {
    if (cameras == null || cameras!.length < 2) return;

    isRearCamera = !isRearCamera;

    final cam = cameras!.firstWhere(
          (c) =>
      c.lensDirection ==
          (isRearCamera
              ? CameraLensDirection.back
              : CameraLensDirection.front),
    );

    setState(() => isLoading = true);

    await controller?.dispose();

    controller = CameraController(
      cam,
      ResolutionPreset.high,
      enableAudio: false,
    );

    await controller!.initialize();

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  }

  Future<void> takePicture() async {
    if (controller == null || !controller!.value.isInitialized) return;

    final file = await controller!.takePicture();

    setState(() => isLoading = true);

    final text = await scanImage(File(file.path));

    setState(() => isLoading = false);

    if (text.trim().isEmpty) return;

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (_) => SearchScreen(keyword: text),
    //   ),
    // );
    showScanResult(text);
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final img = await picker.pickImage(source: ImageSource.gallery);

    if (img == null) return;

    setState(() => isLoading = true);

    final file = File(img.path);

    final text = await scanImage(file);
    print("OCR RAW: [$text]");
    print("LENGTH: ${text.length}");
    print("CODES: ${text.runes.toList()}");

    setState(() => isLoading = false);

    if (text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Không nhận diện được chữ")),
      );
      return;
    }

    // 👉 sang search screen luôn
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (_) => SearchScreen(keyword: text),
    //   ),
    // );
    showScanResult(text);
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF4CD964);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // CAMERA PREVIEW
          if (!isLoading && controller != null && controller!.value.isInitialized)
            CameraPreview(controller!)
          else
            const Center(
              child: CircularProgressIndicator(color: green),
            ),

          // DARK OVERLAY
          Container(color: Colors.black.withOpacity(0.4)),

          // TOP BAR
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, color: Colors.white),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.auto_awesome, color: green, size: 16),
                      SizedBox(width: 6),
                      Text("AI Scan", style: TextStyle(color: green)),
                    ],
                  ),
                ),

                GestureDetector(
                  onTap: toggleFlash,
                  child: Icon(
                    isFlashOn ? Icons.flash_on : Icons.flash_off,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // SCAN FRAME
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 260,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: green, width: 2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Position your content here",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Text(
                    "Scan math problems, notes, diagrams, or text",
                    style: TextStyle(color: Colors.white54),
                  ),
                ),
              ],
            ),
          ),

          // BOTTOM BAR
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // GALLERY
                _buildAction(
                  icon: Icons.image,
                  label: "Gallery",
                  onTap: pickImage,
                ),

                // CAPTURE
                GestureDetector(
                  onTap: takePicture,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: green,
                      boxShadow: [
                        BoxShadow(
                          color: green.withOpacity(0.5),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.camera,
                      size: 32,
                      color: Colors.black,
                    ),
                  ),
                ),

                // FLIP
                _buildAction(
                  icon: Icons.flip_camera_ios,
                  label: "Flip",
                  onTap: flipCamera,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showScanResult(String text) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Detected Text",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(height: 10),
              Text(text, style: const TextStyle(color: Colors.grey)),

              const SizedBox(height: 20),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SearchScreen(keyword: text),
                    ),
                  );
                },
                child: const Text("Search Posts"),
              )
            ],
          ),
        );
      },
    );
  }

  // ================= ACTION BUTTON =================
  Widget _buildAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: Colors.white),
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(color: Colors.white54)),
      ],
    );
  }
}