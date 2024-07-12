import 'package:flutter/material.dart';
import 'dart:io';

class StatisticsScreen extends StatelessWidget {
  final String imagePath;

  StatisticsScreen({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    // Static data for demonstration
    final coins = [
      {'image': 'assets/USD_C_1.png', 'name': '1 Cent (USD)', 'value': '0.01'},
      {
        'image': 'assets/USD_C_25.png',
        'name': '25 Cents (USD)',
        'value': '0.25'
      },
      {'image': 'assets/EUR_C_1.png', 'name': '1 Cent (EUR)', 'value': '0.01'},
      {'image': 'assets/EUR_C_2.png', 'name': '2 Cents (EUR)', 'value': '0.02'},
      {'image': 'assets/EUR_C_5.png', 'name': '5 Cents (EUR)', 'value': '0.05'},
      {
        'image': 'assets/EUR_C_10.png',
        'name': '10 Cents (EUR)',
        'value': '0.10'
      },
      {
        'image': 'assets/NIS_C_1000.png',
        'name': '10 Shekel (NIS)',
        'value': '10.00'
      },
      {
        'image': 'assets/NIS_C_50.png',
        'name': '50 Agorot (NIS)',
        'value': '0.50'
      },
    ];
    final bills = [
      {
        'image': 'assets/USD_B_1.png',
        'name': '1 Dollar (USD)',
        'value': '1.00'
      },
      {
        'image': 'assets/USD_B_5.png',
        'name': '5 Dollar (USD)',
        'value': '5.00'
      },
      {'image': 'assets/EUR_B_5.png', 'name': '5 Euro (EUR)', 'value': '5.00'},
      {
        'image': 'assets/EUR_B_10.png',
        'name': '10 Euro (EUR)',
        'value': '10.00'
      },
      {
        'image': 'assets/NIS_B_20.png',
        'name': '20 Shekel (NIS)',
        'value': '20.00'
      },
      {
        'image': 'assets/NIS_B_50.png',
        'name': '50 Shekel (NIS)',
        'value': '50.00'
      },
    ];

    double totalAmount = 0.0;
    for (var coin in coins) {
      totalAmount += double.tryParse(coin['value'] ?? '0') ?? 0.0;
    }
    for (var bill in bills) {
      totalAmount += double.tryParse(bill['value'] ?? '0') ?? 0.0;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Recognition Results'),
        backgroundColor: const Color.fromARGB(255, 217, 245, 198),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.file(File(imagePath)),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Coins:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  for (var coin in coins)
                    Card(
                      child: ListTile(
                        leading: Image.asset(
                          coin['image']!,
                          width: 50,
                          height: 50,
                        ),
                        title: Text(coin['name']!),
                        subtitle: Text('${coin['value']} USD'),
                      ),
                    ),
                  SizedBox(height: 16),
                  Text(
                    'Bills:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  for (var bill in bills)
                    Card(
                      child: ListTile(
                        leading: Image.asset(
                          bill['image']!,
                          width: 50,
                          height: 50,
                        ),
                        title: Text(bill['name']!),
                        subtitle: Text('${bill['value']} USD'),
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
                      subtitle: Text('$totalAmount USD'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
