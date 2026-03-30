import 'package:flutter/material.dart';
import 'widgets/quick_action_bar.dart';
import 'screens/inventory_screen.dart';
import 'screens/scanner_screen.dart';
import 'screens/onboarding_screen.dart';

void main() {
  runApp(const SmartPantryApp());
}

class SmartPantryApp extends StatelessWidget {
  const SmartPantryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartPantry',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const MainNavigationHub(),
    );
  }
}

class MainNavigationHub extends StatefulWidget {
  const MainNavigationHub({super.key});

  @override
  State<MainNavigationHub> createState() => _MainNavigationHubState();
}

class _MainNavigationHubState extends State<MainNavigationHub> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const InventoryScreen(),
    const Center(child: Text("Bill History Coming Soon", style: TextStyle(color: Colors.grey))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SmartPantry', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const OnboardingScreen())),
          ),
          IconButton(icon: const Icon(Icons.person_outline), onPressed: () {}),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) => setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.inventory_2_outlined), selectedIcon: Icon(Icons.inventory_2), label: 'Inventory'),
          NavigationDestination(icon: Icon(Icons.receipt_long_outlined), selectedIcon: Icon(Icons.receipt_long), label: 'Bills'),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ScannerScreen())),
        icon: const Icon(Icons.qr_code_scanner),
        label: const Text('Scan & Guard'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryCard(),
          const SizedBox(height: 24),
          const QuickActionBar(),
          const SizedBox(height: 24),
          const Text('Top Recommendations', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _buildRecommendationTile("Refill Blood Pressure Meds", "Only 4 days left. Best price on Amazon (\$4.20)", Icons.medical_services, Colors.red),
          _buildRecommendationTile("Eat Chicken Breast", "Expiring tomorrow in Fridge", Icons.restaurant, Colors.orange),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.teal.shade700, Colors.teal.shade400], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.teal.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Welcome Back!', style: TextStyle(color: Colors.white70, fontSize: 16)),
          SizedBox(height: 4),
          Text('\$14.20 Saved', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
          Text('from price audits this month', style: TextStyle(color: Colors.white60, fontSize: 14)),
          SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.shield_outlined, color: Colors.white, size: 16),
              SizedBox(width: 8),
              Text('Guardian Mode Active', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationTile(String title, String subtitle, IconData icon, Color color) {
    return Card(
      elevation: 0,
      color: color.withOpacity(0.05),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), border: Border.all(color: color.withOpacity(0.1))),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right, size: 16),
        onTap: () {},
      ),
    );
  }
}
