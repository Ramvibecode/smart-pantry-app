class Product {
  final String barcode;
  final String name;
  final String imageUrl;
  final String category;
  final String brand;

  Product({
    required this.barcode,
    required this.name,
    required this.imageUrl,
    required this.category,
    this.brand = 'Generic',
  });
}

class InventoryItem {
  final Product product;
  double quantity;
  final String unit;
  final DateTime? expiryDate;

  InventoryItem({
    required this.product,
    required this.quantity,
    this.unit = 'pcs',
    this.expiryDate,
  });
}
