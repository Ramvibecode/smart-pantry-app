import 'package:flutter/material.dart';
import '../models/product.dart';

class PantryProvider extends ChangeNotifier {
  final List<InventoryItem> _items = [
    InventoryItem(
      product: Product(
        barcode: "890123456",
        name: "Fresh Milk",
        imageUrl: "https://images.unsplash.com/photo-1550583724-1255818c0533?w=200",
        category: "Kitchen",
      ),
      quantity: 2.0,
      unit: "Liters",
    ),
    InventoryItem(
      product: Product(
        barcode: "123456789",
        name: "Whole Wheat Bread",
        imageUrl: "https://images.unsplash.com/photo-1509440159596-0249088772ff?w=200",
        category: "Kitchen",
      ),
      quantity: 1.0,
      unit: "Pack",
    ),
  ];

  List<InventoryItem> get items => _items;

  InventoryItem? findByBarcode(String barcode) {
    try {
      return _items.firstWhere((item) => item.product.barcode == barcode);
    } catch (e) {
      return null;
    }
  }

  void addItem(InventoryItem item) {
    final existing = findByBarcode(item.product.barcode);
    if (existing != null) {
      existing.quantity += item.quantity;
    } else {
      _items.add(item);
    }
    notifyListeners();
  }

  void deductItem(String barcode, double amount) {
    final existing = findByBarcode(barcode);
    if (existing != null) {
      existing.quantity -= amount;
      if (existing.quantity <= 0) {
        _items.remove(existing);
      }
      notifyListeners();
    }
  }
}
