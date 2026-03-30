import 'package:google_ml_kit/google_ml_kit.dart';
import '../models/product.dart';

class ScanningService {
  final BarcodeScanner _barcodeScanner = GoogleMlKit.vision.barcodeScanner();
  final TextRecognizer _textRecognizer = GoogleMlKit.vision.textRecognizer();

  /// Mock database of common products for demo purposes
  final Map<String, Product> _mockProductDb = {
    "890123456": Product(
      barcode: "890123456",
      name: "Fresh Cow Milk",
      imageUrl: "https://images.unsplash.com/photo-1550583724-1255818c0533?w=200",
      category: "Kitchen",
      brand: "Amul",
    ),
    "123456789": Product(
      barcode: "123456789",
      name: "Multigrain Bread",
      imageUrl: "https://images.unsplash.com/photo-1509440159596-0249088772ff?w=200",
      category: "Kitchen",
      brand: "Harvest",
    ),
    "111222333": Product(
      barcode: "111222333",
      name: "Paracetamol 500mg",
      imageUrl: "https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=200",
      category: "Pharmacy",
      brand: "Dolo",
    ),
  };

  Product? lookupProduct(String barcode) {
    return _mockProductDb[barcode];
  }

  Future<List<String>> scanBarcodes(InputImage inputImage) async {
    final List<Barcode> barcodes = await _barcodeScanner.processImage(inputImage);
    return barcodes.map((barcode) => barcode.rawValue ?? '').where((val) => val.isNotEmpty).toList();
  }

  Future<Map<String, double>> scanReceipt(InputImage inputImage) async {
    final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);
    Map<String, double> detectedPrices = {};

    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        String text = line.text;
        RegExp priceRegex = RegExp(r'(\d+[.,]\d{2})');
        Iterable<Match> matches = priceRegex.allMatches(text);

        if (matches.isNotEmpty) {
          String priceStr = matches.last.group(0)!;
          try {
            double price = double.parse(priceStr.replaceAll(',', '.'));
            String itemName = text.replaceAll(priceStr, '').trim();
            if (itemName.length > 2) {
              detectedPrices[itemName] = price;
            }
          } catch (_) {}
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
