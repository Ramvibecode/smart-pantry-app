import 'package:flutter/material.dart';
import 'widgets/quick_action_bar.dart';

void main() {
  runApp(const SmartPantryApp());
}

class SmartPantryApp extends StatelessWidget {
  const SmartPantryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartPantry',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SmartPantry', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal.shade50,
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2), label: 'Inventory'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Shopping'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Bills'),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {}, // Action for scanning
        icon: const Icon(Icons.qr_code_scanner),
        label: const Text('Scan Item'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildBody() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // RESPONSIVE LOGIC: Change layout based on screen width
        if (constraints.maxWidth > 600) {
          return _buildTabletLayout(); // For Foldables/Tablets
        } else {
          return _buildMobileLayout(); // For standard Android Phones
        }
      },
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryCard(),
          const SizedBox(height: 24),
          const QuickActionBar(),
          const SizedBox(height: 24),
          const Text('Inventory Categories', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _buildCategoryGrid(),
        ],
      ),
    );
  }

  Widget _buildTabletLayout() {
    return Row(
      children: [
        Expanded(flex: 2, child: _buildMobileLayout()),
        VerticalDivider(width: 1),
        Expanded(
          flex: 1,
          child: Container(
            color: Colors.teal.shade50,
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Text("Price Comparisons", style: TextStyle(fontWeight: FontWeight.bold)),
                // Placeholder for Comparison List
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.teal.shade600, Colors.teal.shade400]),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Good Morning!', style: TextStyle(color: Colors.white70)),
          Text('\$14.20 Saved Today', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text('2 Items expiring soon in Kitchen', style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildCategoryGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: [
        _categoryTile('Kitchen', Icons.kitchen, Colors.orange),
        _categoryTile('Pharmacy', Icons.medical_services, Colors.red),
        _categoryTile('Groceries', Icons.shopping_bag, Colors.blue),
        _categoryTile('Alerts', Icons.warning, Colors.amber),
      ],
    );
  }

  Widget _categoryTile(String title, IconData icon, Color color) {
    return Card(
      elevation: 0,
      color: color.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 8),
            Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }
}
