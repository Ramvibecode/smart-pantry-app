import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:camera/camera.dart';

/// The brain of SmartPantry's scanning capabilities.
/// Handles both Barcode detection for individual items and OCR for receipts.
class ScanningService {
  final BarcodeScanner _barcodeScanner = GoogleMlKit.vision.barcodeScanner();
  final TextRecognizer _textRecognizer = GoogleMlKit.vision.textRecognizer();

  /// Scans an image for barcodes. 
  /// Returns a list of detected barcode values (UPC/EAN codes).
  Future<List<String>> scanBarcodes(InputImage inputImage) async {
    final List<Barcode> barcodes = await _barcodeScanner.processImage(inputImage);
    return barcodes.map((barcode) => barcode.rawValue ?? '').where((val) => val.isNotEmpty).toList();
  }

  /// Scans a receipt image and extracts price/item information.
  /// This is the core of the Bill Auditing feature.
  Future<Map<String, double>> scanReceipt(InputImage inputImage) async {
    final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);
    Map<String, double> detectedPrices = {};

    // Logic for parsing lines into [Item Name] and [Price]
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        String text = line.text;
        
        // Use regex to find potential price values (e.g., "4.99" or "4,99")
        RegExp priceRegex = RegExp(r'(\d+[.,]\d{2})');
        Iterable<Match> matches = priceRegex.allMatches(text);

        if (matches.isNotEmpty) {
          // Attempt to extract the item name by removing the price from the line
          String priceStr = matches.last.group(0)!;
          double price = double.parse(priceStr.replaceAll(',', '.'));
          String itemName = text.replaceAll(priceStr, '').trim();

          if (itemName.length > 2) {
            detectedPrices[itemName] = price;
          }
        }
      }
    }
    return detectedPrices;
  }

  void dispose() {
    _barcodeScanner.close();
    _textRecognizer.close();
  }
}
