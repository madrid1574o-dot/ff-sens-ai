import 'package:flutter/material.dart';
import '../models/goal.dart';
import '../services/goals_repository.dart';
import '../models/app_settings.dart';

class ChecklistScreen extends StatefulWidget {
  const ChecklistScreen({super.key});

  @override
  State<ChecklistScreen> createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen> {
  List<Goal> _goals = [];
  final _customController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final goals = await GoalsRepository.loadCurrentGoals();
    setState(() => _goals = goals);
  }

  Future<void> _persist() => GoalsRepository.saveCurrentGoals(_goals);

  Future<void> _toggleDone(Goal g) async {
    setState(() => g.done = !g.done);
    await _persist();
  }

  Future<void> _toggleEnabled(Goal g) async {
    setState(() => g.enabled = !g.enabled);
    await _persist();
  }

  Future<void> _deleteGoal(Goal g) async {
    setState(() => _goals.removeWhere((x) => x.id == g.id));
    await _persist();
  }

  Future<void> _editGoal(Goal g) async {
    final controller = TextEditingController(text: g.text);
    final newText = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1C1C24),
        title:
            const Text('تعديل الهدف', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
    if (newText != null && newText.isNotEmpty) {
      setState(() => g.text = newText);
      await _persist();
    }
  }

  Future<void> _addCustomGoal() async {
    final text = _customController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _goals.add(Goal(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: text,
        isCustom: true,
      ));
      _customController.clear();
    });
    await _persist();
  }

  Future<void> _resetForNewMatch() async {
    final reset = await GoalsRepository.resetForNewMatch(_goals);
    setState(() => _goals = reset);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم تجهيز checklist جديدة للماتش الجاي')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checklist الأهداف'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'ماتش جديد',
            onPressed: _resetForNewMatch,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _goals.length,
                itemBuilder: (context, i) {
                  final g = _goals[i];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Opacity(
                      opacity: g.enabled ? 1.0 : 0.4,
                      child: CheckboxListTile(
                        value: g.done,
                        onChanged: g.enabled ? (_) => _toggleDone(g) : null,
                        activeColor: const Color(0xFFFFC107),
                        title: Text(g.text,
                            style: const TextStyle(color: Colors.white)),
                        subtitle: g.isCustom
                            ? const Text('هدف خاص',
                                style: TextStyle(
                                    color: Colors.white38, fontSize: 11))
                            : null,
                        controlAffinity: ListTileControlAffinity.leading,
                        secondary: PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert,
                              color: Colors.white54),
                          color: const Color(0xFF1C1C24),
                          onSelected: (v) {
                            if (v == 'edit') _editGoal(g);
                            if (v == 'delete') _deleteGoal(g);
                            if (v == 'toggle') _toggleEnabled(g);
                          },
                          itemBuilder: (ctx) => [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Text('تعديل',
                                  style: TextStyle(color: Colors.white)),
                            ),
                            PopupMenuItem(
                              value: 'toggle',
                              child: Text(
                                  g.enabled ? 'تعطيل الهدف' : 'تفعيل الهدف',
                                  style:
                                      const TextStyle(color: Colors.white)),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Text('حذف',
                                  style: TextStyle(color: Colors.redAccent)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (AppSettings.customMatchGoalsEnabled)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _customController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'زيد هدف خاص لهذا الماتش...',
                          hintStyle: TextStyle(color: Colors.white38),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.add_circle,
                          color: Color(0xFFFFC107)),
                      onPressed: _addCustomGoal,
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
