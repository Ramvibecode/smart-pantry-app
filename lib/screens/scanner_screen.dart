import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import '../services/scanning_service.dart';
import '../providers/pantry_provider.dart';
import '../models/product.dart';

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
  DateTime _lastScanTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;

    _controller = CameraController(
      cameras[0],
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );

    try {
      await _controller!.initialize();
      _controller!.startImageStream(_processCameraFrame);
      if (mounted) setState(() => _isInitializing = false);
    } catch (e) {
      debugPrint('Camera error: $e');
    }
  }

  void _processCameraFrame(CameraImage image) async {
    if (_isProcessing) return;
    if (DateTime.now().difference(_lastScanTime).inMilliseconds < 1500) return;

    _isProcessing = true;

    try {
      final inputImage = _inputImageFromCameraImage(image);
      final barcodes = await _scanningService.scanBarcodes(inputImage);

      if (barcodes.isNotEmpty && mounted) {
        _lastScanTime = DateTime.now();
        _handleBarcodeDetected(barcodes.first);
      }
    } catch (e) {
      debugPrint("Frame processing error: $e");
    } finally {
      _isProcessing = false;
    }
  }

  InputImage _inputImageFromCameraImage(CameraImage image) {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final metadata = InputImageMetadata(
      size: Size(image.width.toDouble(), image.height.toDouble()),
      rotation: InputImageRotation.rotation90deg,
      format: InputImageFormatValue.fromRawValue(image.format.raw) ?? InputImageFormat.yuv420,
      bytesPerRow: image.planes[0].bytesPerRow,
    );

    return InputImage.fromBytes(bytes: bytes, metadata: metadata);
  }

  void _handleBarcodeDetected(String barcode) {
    final product = _scanningService.lookupProduct(barcode);
    final pantry = Provider.of<PantryProvider>(context, listen: false);
    final existing = pantry.findByBarcode(barcode);

    if (product != null) {
      _showGuardianDialog(product, existing != null);
    } else {
      _showResultDialog("Unknown Product", "Barcode: $barcode\nThis item is not in our database yet.");
    }
  }

  void _showGuardianDialog(Product product, bool isInStock) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            Icon(isInStock ? Icons.shield : Icons.add_shopping_cart, color: isInStock ? Colors.orange : Colors.teal),
            const SizedBox(width: 12),
            Text(isInStock ? "Guardian Alert!" : "Add to Pantry?"),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(product.imageUrl, height: 120, width: double.infinity, fit: BoxFit.cover),
            ),
            const SizedBox(height: 16),
            Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text(product.brand, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 12),
            Text(
              isInStock 
                ? "Wait! You already have this item in your pantry. Avoid over-buying!" 
                : "This item is not in your stock. Want to add it now?",
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
            onPressed: () {
              if (!isInStock) {
                Provider.of<PantryProvider>(context, listen: false).addItem(
                  InventoryItem(product: product, quantity: 1)
                );
              }
              Navigator.pop(context);
            },
            child: Text(isInStock ? "I'll buy it anyway" : "Add 1 Unit"),
          ),
        ],
      ),
    );
  }

  void _showResultDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK")),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    _scanningService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitializing) {
      return const Scaffold(body: Center(child: CircularProgressIndicator(color: Colors.teal)));
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          CameraPreview(_controller!),
          ColorFiltered(
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.srcOut),
            child: Stack(
              children: [
                Container(decoration: const BoxDecoration(color: Colors.black, backgroundBlendMode: BlendMode.dstOut)),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 250,
                    width: 250,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 250,
              width: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.teal, width: 4),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          Positioned(
            top: 60,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                "Scanning automatically...",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
