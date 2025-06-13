import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PortfolioTrackerPage extends StatefulWidget {
  const PortfolioTrackerPage({super.key});

  @override
  State<PortfolioTrackerPage> createState() => _PortfolioTrackerPageState();
}

class _PortfolioTrackerPageState extends State<PortfolioTrackerPage> {
  final TextEditingController stocksController = TextEditingController();
  final TextEditingController mfController = TextEditingController();
  final TextEditingController smallcaseController = TextEditingController();

  List<Map<String, dynamic>> entries = [];

  @override
  void initState() {
    super.initState();
    loadEntries();
  }

  Future<void> loadEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('portfolio_entries');
    if (data != null) {
      setState(() {
        entries = List<Map<String, dynamic>>.from(json.decode(data));
      });
    }
  }

  Future<void> saveEntries() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('portfolio_entries', json.encode(entries));
  }

  void addEntry() {
    final stocks = double.tryParse(stocksController.text) ?? 0;
    final mf = double.tryParse(mfController.text) ?? 0;
    final smallcase = double.tryParse(smallcaseController.text) ?? 0;
    final date = DateTime.now().toIso8601String().split('T').first;

    final entry = {
      'date': date,
      'stocks': stocks,
      'mf': mf,
      'smallcase': smallcase,
      'total': stocks + mf + smallcase,
    };

    setState(() {
      entries.insert(0, entry); // latest on top
    });

    saveEntries();

    stocksController.clear();
    mfController.clear();
    smallcaseController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Portfolio Tracker')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: stocksController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Stocks Value'),
            ),
            TextField(
              controller: mfController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Mutual Funds Value'),
            ),
            TextField(
              controller: smallcaseController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Smallcase Value'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: addEntry,
              child: const Text('Add Entry'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: entries.length,
                itemBuilder: (context, index) {
                  final entry = entries[index];
                  return Card(
                    child: ListTile(
                      title: Text(entry['date']),
                      subtitle: Text(
                          'Stocks: ₹${entry['stocks']}, MF: ₹${entry['mf']}, Smallcase: ₹${entry['smallcase']}'),
                      trailing: Text('Total: ₹${entry['total']}'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
