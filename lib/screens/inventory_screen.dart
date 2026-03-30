import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/pantry_provider.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pantry = Provider.of<PantryProvider>(context);
    final items = pantry.items;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: items.isEmpty 
        ? const Center(child: Text("Your pantry is empty. Scan something!"))
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return _inventoryCard(context, item, pantry);
            },
          ),
    );
  }

  Widget _inventoryCard(BuildContext context, dynamic item, PantryProvider pantry) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 100,
                child: CachedNetworkImage(
                  imageUrl: item.product.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(color: Colors.grey.shade200),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(color: Colors.teal.shade50, borderRadius: BorderRadius.circular(8)),
                            child: Text(item.product.category, style: TextStyle(color: Colors.teal.shade700, fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                          const Icon(Icons.more_vert, size: 16, color: Colors.grey),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(item.product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(item.product.brand, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${item.quantity} ${item.unit}", style: const TextStyle(fontWeight: FontWeight.black, fontSize: 18, color: Colors.teal)),
                          Row(
                            children: [
                              _actionBtn(Icons.remove, () => pantry.deductItem(item.product.barcode, 1)),
                              const SizedBox(width: 8),
                              _actionBtn(Icons.add, () => pantry.addItem(item)),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, size: 16, color: Colors.teal),
      ),
    );
  }
}
