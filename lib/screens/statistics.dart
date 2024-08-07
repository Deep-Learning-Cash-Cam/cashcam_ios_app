import 'dart:convert';
import 'package:flutter/material.dart';

class StatisticsScreen extends StatelessWidget {
  final String imagePath;
  final String annotatedImageBase64;
  final Map<String, dynamic> currencies;

  StatisticsScreen({
    required this.imagePath,
    required this.annotatedImageBase64,
    required this.currencies,
  });

  @override
  Widget build(BuildContext context) {
    double totalAmount = currencies.values.fold(
        0.0,
        (sum, item) =>
            sum +
            (double.tryParse(item['return_currency_value'].toString()) ?? 0.0));

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
                Card(
                  child: ListTile(
                    title: Text(entry.key),
                    subtitle: Text(
                        '${entry.value['quantity']} items, ${entry.value['return_currency_value']} USD each'),
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
      ),
    );
  }
}
