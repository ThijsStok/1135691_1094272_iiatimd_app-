import 'package:flutter/material.dart';

class FitnessJournalEntry {
  final double kilometersWalked;
  final int timeTakenInMinutes;

  FitnessJournalEntry({
    required this.kilometersWalked,
    required this.timeTakenInMinutes,
  });
}

class FitnessJournalPage extends StatefulWidget {
  const FitnessJournalPage({Key? key}) : super(key: key);

  @override
  _FitnessJournalPageState createState() => _FitnessJournalPageState();
}

class _FitnessJournalPageState extends State<FitnessJournalPage> {
  final _entries = <FitnessJournalEntry>[];

  void _addEntry(double kilometersWalked, int timeTakenInMinutes) {
    setState(() {
      _entries.add(FitnessJournalEntry(
        kilometersWalked: kilometersWalked,
        timeTakenInMinutes: timeTakenInMinutes,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fitness Journal'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _entries.length,
              itemBuilder: (context, index) {
                final entry = _entries[index];
                return ListTile(
                  leading: SizedBox(
                    width: 48,
                    height: 48,
                    child: const Icon(Icons.directions_walk),
                  ),
                  title: Text('${entry.kilometersWalked} km'),
                  subtitle: Text('${entry.timeTakenInMinutes} min'),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddEntryDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddEntryDialog() async {
    final kilometersWalked = await showDialog<double>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Kilometers walked'),
          content: TextField(
            decoration: InputDecoration(
              labelText: 'Kilometers walked',
            ),
            keyboardType: TextInputType.numberWithOptions(
              decimal: true,
            ),
            onSubmitted: (value) {
              final kilometersWalked = double.tryParse(value);
              if (kilometersWalked != null) {
                Navigator.of(context).pop(kilometersWalked);
              }
            },
          ),
        );
      },
    );
    if (kilometersWalked != null) {
      final timeTakenInMinutes = await showDialog<int>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Time taken'),
            content: TextField(
              decoration: InputDecoration(
                labelText: 'Minutes taken',
              ),
              keyboardType: TextInputType.number,
              onSubmitted: (value) {
                final timeTakenInMinutes = int.tryParse(value);
                if (timeTakenInMinutes != null) {
                  Navigator.of(context).pop(timeTakenInMinutes);
                }
              },
            ),
          );
        },
      );
      if (timeTakenInMinutes != null) {
        _addEntry(kilometersWalked, timeTakenInMinutes);
      }
    }
  }
}
