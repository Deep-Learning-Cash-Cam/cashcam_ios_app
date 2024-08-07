import 'dart:convert';
import 'package:flutter/material.dart';

final Map<String, Map<String, String>> currencyDetails = {
  'USD_C_1': {
    'image': 'assets/USD_C_1.png',
    'name': '1 Cent (USD)',
    'value': '0.01'
  },
  'USD_C_5': {
    'image': 'assets/USD_C_5.png',
    'name': '5 Cents (USD)',
    'value': '0.05'
  },
  'USD_C_10': {
    'image': 'assets/USD_C_10.png',
    'name': '10 Cents (USD)',
    'value': '0.10'
  },
  'USD_C_25': {
    'image': 'assets/USD_C_25.png',
    'name': '25 Cents (USD)',
    'value': '0.25'
  },
  'USD_C_50': {
    'image': 'assets/USD_C_50.png',
    'name': '50 Cents (USD)',
    'value': '0.50'
  },
  'USD_C_100': {
    'image': 'assets/USD_C_100.png',
    'name': '1 Dollar Coin (USD)',
    'value': '1.00'
  },
  'USD_B_1': {
    'image': 'assets/USD_B_1.png',
    'name': '1 Dollar (USD)',
    'value': '1.00'
  },
  'USD_B_2': {
    'image': 'assets/USD_B_2.png',
    'name': '2 Dollars (USD)',
    'value': '2.00'
  },
  'USD_B_5': {
    'image': 'assets/USD_B_5.png',
    'name': '5 Dollars (USD)',
    'value': '5.00'
  },
  'USD_B_10': {
    'image': 'assets/USD_B_10.png',
    'name': '10 Dollars (USD)',
    'value': '10.00'
  },
  'USD_B_20': {
    'image': 'assets/USD_B_20.png',
    'name': '20 Dollars (USD)',
    'value': '20.00'
  },
  'USD_B_50': {
    'image': 'assets/USD_B_50.png',
    'name': '50 Dollars (USD)',
    'value': '50.00'
  },
  'USD_B_100': {
    'image': 'assets/USD_B_100.png',
    'name': '100 Dollars (USD)',
    'value': '100.00'
  },
  'EUR_C_1': {
    'image': 'assets/EUR_C_1.png',
    'name': '1 Cent (EUR)',
    'value': '0.01'
  },
  'EUR_C_2': {
    'image': 'assets/EUR_C_2.png',
    'name': '2 Cents (EUR)',
    'value': '0.02'
  },
  'EUR_C_5': {
    'image': 'assets/EUR_C_5.png',
    'name': '5 Cents (EUR)',
    'value': '0.05'
  },
  'EUR_C_10': {
    'image': 'assets/EUR_C_10.png',
    'name': '10 Cents (EUR)',
    'value': '0.10'
  },
  'EUR_C_20': {
    'image': 'assets/EUR_C_20.png',
    'name': '20 Cents (EUR)',
    'value': '0.20'
  },
  'EUR_C_50': {
    'image': 'assets/EUR_C_50.png',
    'name': '50 Cents (EUR)',
    'value': '0.50'
  },
  'EUR_C_100': {
    'image': 'assets/EUR_C_100.png',
    'name': '1 Euro (EUR)',
    'value': '1.00'
  },
  'EUR_C_200': {
    'image': 'assets/EUR_C_200.png',
    'name': '2 Euros (EUR)',
    'value': '2.00'
  },
  'EUR_B_5': {
    'image': 'assets/EUR_B_5.png',
    'name': '5 Euros (EUR)',
    'value': '5.00'
  },
  'EUR_B_10': {
    'image': 'assets/EUR_B_10.png',
    'name': '10 Euros (EUR)',
    'value': '10.00'
  },
  'EUR_B_20': {
    'image': 'assets/EUR_B_20.png',
    'name': '20 Euros (EUR)',
    'value': '20.00'
  },
  'EUR_B_50': {
    'image': 'assets/EUR_B_50.png',
    'name': '50 Euros (EUR)',
    'value': '50.00'
  },
  'EUR_B_100': {
    'image': 'assets/EUR_B_100.png',
    'name': '100 Euros (EUR)',
    'value': '100.00'
  },
  'EUR_B_200': {
    'image': 'assets/EUR_B_200.png',
    'name': '200 Euros (EUR)',
    'value': '200.00'
  },
  'EUR_B_500': {
    'image': 'assets/EUR_B_500.png',
    'name': '500 Euros (EUR)',
    'value': '500.00'
  },
  'NIS_C_10': {
    'image': 'assets/NIS_C_10.png',
    'name': '10 Agorot (NIS)',
    'value': '0.10'
  },
  'NIS_C_50': {
    'image': 'assets/NIS_C_50.png',
    'name': '50 Agorot (NIS)',
    'value': '0.50'
  },
  'NIS_C_100': {
    'image': 'assets/NIS_C_100.png',
    'name': '1 Shekel (NIS)',
    'value': '1.00'
  },
  'NIS_C_200': {
    'image': 'assets/NIS_C_200.png',
    'name': '2 Shekels (NIS)',
    'value': '2.00'
  },
  'NIS_C_500': {
    'image': 'assets/NIS_C_500.png',
    'name': '5 Shekels (NIS)',
    'value': '5.00'
  },
  'NIS_C_1000': {
    'image': 'assets/NIS_C_1000.png',
    'name': '10 Shekels (NIS)',
    'value': '10.00'
  },
  'NIS_B_20': {
    'image': 'assets/NIS_B_20.png',
    'name': '20 Shekels (NIS)',
    'value': '20.00'
  },
  'NIS_B_50': {
    'image': 'assets/NIS_B_50.png',
    'name': '50 Shekels (NIS)',
    'value': '50.00'
  },
  'NIS_B_100': {
    'image': 'assets/NIS_B_100.png',
    'name': '100 Shekels (NIS)',
    'value': '100.00'
  },
  'NIS_B_200': {
    'image': 'assets/NIS_B_200.png',
    'name': '200 Shekels (NIS)',
    'value': '200.00'
  },
};

class StatisticsScreen extends StatelessWidget {
  final String imagePath;
  final String annotatedImageBase64;
  final Map<String, dynamic> currencies;
  final String selectedCurrency;

  StatisticsScreen({
    required this.imagePath,
    required this.annotatedImageBase64,
    required this.currencies,
    required this.selectedCurrency,
  });

  @override
  Widget build(BuildContext context) {
    double totalAmount = currencies.entries.fold(
      0.0,
      (sum, entry) {
        double itemTotalValue =
            (double.tryParse(currencyDetails[entry.key]?['value'] ?? '0') ??
                    0.0) *
                entry.value['quantity'];
        return sum + itemTotalValue;
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Recognition Results'),
        backgroundColor: const Color.fromARGB(255, 31, 133, 31),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.memory(base64Decode(annotatedImageBase64)),
              SizedBox(height: 16),
              Text(
                'Detected Currencies:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              for (var entry in currencies.entries)
                if (currencyDetails.containsKey(entry.key))
                  Card(
                    child: ListTile(
                      leading: Image.asset(
                        currencyDetails[entry.key]!['image']!,
                        width: 50,
                        height: 50,
                      ),
                      title: Text(currencyDetails[entry.key]!['name']!),
                      subtitle: Text(
                          '${entry.value['quantity']} items, ${currencyDetails[entry.key]!['value']} $selectedCurrency each'),
                    ),
                  ),
              SizedBox(height: 16),
              Text(
                'Total Amount:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Card(
                child: ListTile(
                  title: Text('Total'),
                  subtitle: Text('$totalAmount $selectedCurrency'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
