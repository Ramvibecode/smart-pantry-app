import 'package:flutter/material.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionHeader("Kitchen Staples"),
          _inventoryItem("Milk", "2 liters", "Expiring in 2 days", Colors.blue),
          _inventoryItem("Eggs", "8 pcs", "Expiring in 5 days", Colors.orange),
          const SizedBox(height: 24),
          _sectionHeader("Pharmacy Vault"),
          _inventoryItem("Paracetamol", "12 tablets", "Refill needed soon", Colors.red),
          _inventoryItem("Vitamin C", "30 tablets", "Good stock", Colors.green),
          const SizedBox(height: 24),
          _sectionHeader("Groceries"),
          _inventoryItem("Detergent", "1.5 kg", "Low stock", Colors.purple),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal)),
    );
  }

  Widget _inventoryItem(String name, String qty, String status, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: color.withOpacity(0.1), child: Icon(Icons.inventory, color: color)),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(status),
        trailing: Text(qty, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
      ),
    );
  }
}
