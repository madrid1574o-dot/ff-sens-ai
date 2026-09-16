import 'package:flutter/material.dart';
import '../models/app_settings.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _apiKeyController =
      TextEditingController(text: AppSettings.claudeApiKey);

  Future<void> _persist() async {
    await AppSettings.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الإعدادات')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const _SectionTitle('البابل العائم'),
            SwitchListTile(
              value: AppSettings.avoidFreeFireButtons,
              activeColor: const Color(0xFFFFC107),
              title: const Text('تجنب أزرار Free Fire',
                  style: TextStyle(color: Colors.white)),
              subtitle: const Text('يبعد البابل على مناطق التحكم في اللعبة',
                  style: TextStyle(color: Colors.white54, fontSize: 12)),
              onChanged: (v) {
                setState(() => AppSettings.avoidFreeFireButtons = v);
                _persist();
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('حجم البابل',
                      style: TextStyle(color: Colors.white70)),
                  Slider(
                    value: AppSettings.bubbleSize,
                    min: 0.7,
                    max: 1.5,
                    activeColor: const Color(0xFFFFC107),
                    onChanged: (v) {
                      setState(() => AppSettings.bubbleSize = v);
                      _persist();
                    },
                  ),
                  const Text('شفافية البابل',
                      style: TextStyle(color: Colors.white70)),
                  Slider(
                    value: AppSettings.bubbleOpacity,
                    min: 0.3,
                    max: 1.0,
                    activeColor: const Color(0xFFFFC107),
                    onChanged: (v) {
                      setState(() => AppSettings.bubbleOpacity = v);
                      _persist();
                    },
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white12),
            const _SectionTitle('Checklist'),
            SwitchListTile(
              value: AppSettings.customMatchGoalsEnabled,
              activeColor: const Color(0xFFFFC107),
              title: const Text('السماح بأهداف خاصة',
                  style: TextStyle(color: Colors.white)),
              onChanged: (v) {
                setState(() => AppSettings.customMatchGoalsEnabled = v);
                _persist();
              },
            ),
            SwitchListTile(
              value: AppSettings.resetGoalsForNewMatch,
              activeColor: const Color(0xFFFFC107),
              title: const Text('إعادة تهيئة الأهداف كل ماتش',
                  style: TextStyle(color: Colors.white)),
              onChanged: (v) {
                setState(() => AppSettings.resetGoalsForNewMatch = v);
                _persist();
              },
            ),
            const Divider(color: Colors.white12),
            const _SectionTitle('تحليل بعد المباراة'),
            SwitchListTile(
              value: AppSettings.automaticAnalysis,
              activeColor: const Color(0xFFFFC107),
              title: const Text('تحليل أوتوماتيكي بعد اختيار الصورة',
                  style: TextStyle(color: Colors.white)),
              onChanged: (v) {
                setState(() => AppSettings.automaticAnalysis = v);
                _persist();
              },
            ),
            const SizedBox(height: 8),
            const Text('مستوى التحليل',
                style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 6),
            Wrap(
              spacing: 10,
              children: ['detailed', 'summary'].map((level) {
                final selected = AppSettings.analysisLevel == level;
                return ChoiceChip(
                  label: Text(level == 'detailed' ? 'مفصل' : 'ملخص'),
                  selected: selected,
                  selectedColor: const Color(0xFFFFC107),
                  backgroundColor: const Color(0xFF1C1C24),
                  labelStyle: TextStyle(
                      color: selected ? Colors.black : Colors.white70),
                  onSelected: (_) {
                    setState(() => AppSettings.analysisLevel = level);
                    _persist();
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _apiKeyController,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Claude API Key',
                labelStyle: TextStyle(color: Colors.white54),
                helperText:
                    'مطلوب باش يخدم التحليل. الكي تبقى محفوظة في جهازك فقط.',
                helperStyle: TextStyle(color: Colors.white38, fontSize: 11),
                helperMaxLines: 2,
              ),
              onChanged: (v) => AppSettings.claudeApiKey = v.trim(),
              onSubmitted: (_) => _persist(),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  AppSettings.claudeApiKey = _apiKeyController.text.trim();
                  await _persist();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم الحفظ')),
                    );
                  }
                },
                child: const Text('حفظ'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFFFFC107),
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}
