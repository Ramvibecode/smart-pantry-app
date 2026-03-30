import 'package:flutter/material.dart';

class QuickActionBar extends StatelessWidget {
  const QuickActionBar({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> quickItems = [
      {'name': 'Milk', 'icon': Icons.local_drink, 'color': Colors.blue, 'stock': '500ml'},
      {'name': 'Eggs', 'icon': Icons.egg, 'color': Colors.orange, 'stock': '8 pcs'},
      {'name': 'Bread', 'icon': Icons.bakery_dining, 'color': Colors.brown, 'stock': '12 slices'},
      {'name': 'Water', 'icon': Icons.water_drop, 'color': Colors.lightBlue, 'stock': '5L'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Quick Use (One-Tap Minus)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'Edit',
                style: TextStyle(color: Colors.emerald, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: quickItems.length,
            itemBuilder: (context, index) {
              final item = quickItems[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Deducted 1 unit of ${item['name']}!'),
                        duration: const Duration(seconds: 1),
                        backgroundColor: Colors.emerald,
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: 90,
                    decoration: BoxDecoration(
                      color: (item['color'] as Color).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: (item['color'] as Color).withOpacity(0.2)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(item['icon'] as IconData, color: item['color'] as Color, size: 28),
                        const SizedBox(height: 4),
                        Text(
                          item['name'] as String,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: (item['color'] as Color).darken(0.2),
                          ),
                        ),
                        Text(
                          item['stock'] as String,
                          style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

extension ColorExtension on Color {
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}
