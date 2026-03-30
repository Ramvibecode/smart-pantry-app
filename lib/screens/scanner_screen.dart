import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import '../services/scanning_service.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  CameraController? _controller;
  bool _isInitializing = true;
  bool _isProcessing = false;
  final ScanningService _scanningService = ScanningService();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;

    _controller = CameraController(cameras[0], ResolutionPreset.medium, enableAudio: false);
    try {
      await _controller!.initialize();
      if (mounted) {
        setState(() => _isInitializing = false);
      }
    } catch (e) {
      debugPrint('Camera error: $e');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _scanningService.dispose();
    super.dispose();
  }

  Future<void> _processImage() async {
    if (_controller == null || !_controller!.value.isInitialized || _isProcessing) return;

    setState(() => _isProcessing = true);

    try {
      final image = await _controller!.takePicture();
      final inputImage = InputImage.fromFilePath(image.path);
      
      // Detect Barcodes
      final barcodes = await _scanningService.scanBarcodes(inputImage);
      
      if (barcodes.isNotEmpty) {
        _showResultDialog("Barcode Detected", "Found item with SKU: ${barcodes.first}\n\nGuardian Check: You have 2 of these at home!");
      } else {
        // Try Receipt Scan
        final items = await _scanningService.scanReceipt(inputImage);
        if (items.isNotEmpty) {
          String list = items.entries.map((e) => "${e.key}: \$${e.value}").join("\n");
          _showResultDialog("Receipt Scanned", "Items found:\n$list");
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("No barcode or items found. Try again.")));
        }
      }
    } catch (e) {
      debugPrint("Scan error: $e");
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  void _showResultDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitializing) {
      return const Scaffold(body: Center(child: CircularProgressIndicator(color: Colors.teal)));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Smart Scanner")),
      body: Stack(
        children: [
          CameraPreview(_controller!),
          // Overlay UI
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: FloatingActionButton.large(
                onPressed: _processImage,
                backgroundColor: Colors.teal,
                child: _isProcessing 
                  ? const CircularProgressIndicator(color: Colors.white) 
                  : const Icon(Icons.camera_alt, color: Colors.white),
              ),
            ),
          ),
          const Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                "Center barcode or receipt inside the box",
                style: TextStyle(color: Colors.white, backgroundColor: Colors.black45, padding: EdgeInsets.all(8)),
              ),
            ),
          )
        ],
      ),
    );
  }
}
