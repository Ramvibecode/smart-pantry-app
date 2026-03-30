import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Center(
            child: Column(
              children: [
                CircleAvatar(radius: 50, backgroundColor: Colors.teal, child: Icon(Icons.person, size: 50, color: Colors.white)),
                SizedBox(height: 16),
                Text("Ramakrishnan", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                Text("mrk10.krishnan@outlook.com", style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          const SizedBox(height: 40),
          _profileTile(Icons.shopping_bag_outlined, "Affiliate Earnings", "\$42.50 Pending"),
          _profileTile(Icons.location_on_outlined, "Pricing Region", "India (Blinkit/Zepto)"),
          _profileTile(Icons.family_restroom, "Family Members", "3 Connected"),
          _profileTile(Icons.settings_outlined, "Settings", ""),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {}, 
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade50, foregroundColor: Colors.red, elevation: 0),
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }

  Widget _profileTile(IconData icon, String title, String trailing) {
    return ListTile(
      leading: Icon(icon, color: Colors.teal),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      trailing: Text(trailing, style: const TextStyle(color: Colors.grey)),
      onTap: () {},
    );
  }
}
