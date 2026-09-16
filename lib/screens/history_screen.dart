import 'dart:io';
import 'package:flutter/material.dart';
import '../models/goal.dart';
import '../services/goals_repository.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<MatchRecord> _history = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final h = await GoalsRepository.loadHistory();
    setState(() => _history = h);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('سجل الماتشات')),
      body: SafeArea(
        child: _history.isEmpty
            ? const Center(
                child: Text('ماعندكش ماتشات محفوظة بعد',
                    style: TextStyle(color: Colors.white54)),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _history.length,
                itemBuilder: (context, i) {
                  final m = _history[i];
                  final done = m.goals.where((g) => g.done).length;
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ExpansionTile(
                      collapsedIconColor: Colors.white54,
                      iconColor: const Color(0xFFFFC107),
                      title: Text(
                        '${m.date.day}/${m.date.month}/${m.date.year} - ${m.date.hour}:${m.date.minute.toString().padLeft(2, '0')}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text('$done/${m.goals.length} أهداف محققة',
                          style: const TextStyle(
                              color: Colors.white54, fontSize: 12)),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline,
                            color: Colors.redAccent),
                        onPressed: () async {
                          await GoalsRepository.deleteFromHistory(m.id);
                          _load();
                        },
                      ),
                      children: [
                        if (m.screenshotPath != null &&
                            File(m.screenshotPath!).existsSync())
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(File(m.screenshotPath!),
                                  height: 160, fit: BoxFit.cover),
                            ),
                          ),
                        if (m.analysisResult != null)
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              m.analysisResult!,
                              style: const TextStyle(
                                  color: Colors.white70, height: 1.4),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
