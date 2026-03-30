import 'package:flutter/material.dart';

/// A class to handle medicine dosage tracking logic.
class MedicineTracker {
  final String id;
  final String name;
  int totalPills;
  final int dosagePerDay;
  final int refillThreshold; // Alert when pills reach this number

  MedicineTracker({
    required this.id,
    required this.name,
    required this.totalPills,
    required this.dosagePerDay,
    this.refillThreshold = 5,
  });

  /// Simulates a daily consumption.
  void consumeDailyDose() {
    if (totalPills >= dosagePerDay) {
      totalPills -= dosagePerDay;
    }
  }

  /// Checks if a refill alert is needed.
  bool needsRefill() {
    return totalPills <= refillThreshold;
  }

  /// Calculates how many days are left.
  int daysRemaining() {
    return (totalPills / dosagePerDay).floor();
  }

  String getStatusMessage() {
    if (needsRefill()) {
      return "⚠️ ONLY ${daysRemaining()} DAYS LEFT! Add $name to shopping list?";
    }
    return "$totalPills pills remaining (~${daysRemaining()} days).";
  }
}

/// A Mock Service for Global Price Comparison & Affiliates
class GlobalPriceService {
  /// Simulates fetching prices from different platforms based on user location.
  /// In production, this would call Blinkit/Amazon/Instamart APIs.
  Future<List<Map<String, dynamic>>> getPriceComparison(String itemName, String countryCode) async {
    // Mock Data
    return [
      {'store': 'Amazon', 'price': 4.99, 'link': 'https://amazon.com/s?k=$itemName&tag=smartpantry-20'},
      {'store': 'Local Offline Store', 'price': 5.25, 'note': 'Based on your last bill'},
      {'store': 'Instamart', 'price': 5.10, 'link': 'https://instamart.com/search/$itemName'},
    ];
  }
}
