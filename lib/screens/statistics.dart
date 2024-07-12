import 'package:flutter/material.dart';
import 'dart:io';

class StatisticsScreen extends StatelessWidget {
  final String imagePath;

  StatisticsScreen({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    // Static data for demonstration
    final coins = [
      {'name': 'Penny', 'value': '0.01 USD'},
      {'name': 'Nickel', 'value': '0.05 USD'},
      {'name': 'Dime', 'value': '0.10 USD'},
      {'name': 'Quarter', 'value': '0.25 USD'},
    ];
    final bills = [
      {'name': 'One Dollar Bill', 'value': '1.00 USD'},
      {'name': 'Five Dollar Bill', 'value': '5.00 USD'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Recognition Results'),
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
                        title: Text(coin['name']!),
                        subtitle: Text(coin['value']!),
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
                        title: Text(bill['name']!),
                        subtitle: Text(bill['value']!),
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
