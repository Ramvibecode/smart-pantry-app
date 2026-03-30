import 'package:flutter/material.dart';

class QuickActionBar extends StatelessWidget {
  const QuickActionBar({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> quickItems = [
      {'name': 'Milk', 'icon': Icons.local_drink, 'color': Colors.blue, 'stock': '500ml'},
      {'name': 'Eggs', 'icon': Icons.egg, 'color': Colors.orange, 'stock': '8 pcs'},
      {'name': 'Bread', 'icon': Icons.bakery_dining, 'color': Colors.brown, 'stock': '12 slc'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Quick Deduct', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
            TextButton(onPressed: () {}, child: const Text('Edit List')),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: quickItems.map((item) => _quickTile(context, item)).toList(),
        ),
      ],
    );
  }

  Widget _quickTile(BuildContext context, Map<String, dynamic> item) {
    final color = item['color'] as Color;
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Deducted 1 unit of ${item['name']}!'), backgroundColor: Colors.teal));
      },
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: color.withOpacity(0.15)),
        ),
        child: Column(
          children: [
            Icon(item['icon'] as IconData, color: color, size: 28),
            const SizedBox(height: 8),
            Text(item['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            Text(item['stock'] as String, style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
          ],
        ),
      ),
    );
  }
}
