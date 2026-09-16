import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/claude_service.dart';
import '../services/goals_repository.dart';
import '../models/goal.dart';
import '../models/app_settings.dart';
import 'settings_screen.dart';

class MatchAnalysisScreen extends StatefulWidget {
  const MatchAnalysisScreen({super.key});

  @override
  State<MatchAnalysisScreen> createState() => _MatchAnalysisScreenState();
}

class _MatchAnalysisScreenState extends State<MatchAnalysisScreen> {
  File? _image;
  bool _loading = false;
  String? _result;
  String? _error;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;
    setState(() {
      _image = File(picked.path);
      _result = null;
      _error = null;
    });
    if (AppSettings.automaticAnalysis) {
      _analyze();
    }
  }

  Future<void> _analyze() async {
    if (_image == null) return;
    if (AppSettings.claudeApiKey.isEmpty) {
      setState(() => _error =
          'دخل مفتاح Claude API من الإعدادات قبل ما تعمل تحليل.');
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final result = await ClaudeService.analyzeScreenshot(_image!);
      setState(() => _result = result);

      if (AppSettings.saveMatchResults) {
        final goals = await GoalsRepository.loadCurrentGoals();
        await GoalsRepository.addMatchToHistory(
          MatchRecord(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            date: DateTime.now(),
            goals: goals,
            analysisResult: result,
            screenshotPath: _image!.path,
          ),
        );
      }
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تحليل بعد المباراة')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'ارفع screenshot من نهاية الماتش (نتيجة المباراة) وخوذ تحليل مفصل.',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 16),
              if (_image != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(_image!, height: 220, fit: BoxFit.cover),
                ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.photo_library),
                  label: const Text('اختار Screenshot'),
                ),
              ),
              if (_image != null && !AppSettings.automaticAnalysis) ...[
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: _loading ? null : _analyze,
                    child: const Text('حلل الصورة'),
                  ),
                ),
              ],
              const SizedBox(height: 20),
              if (_loading)
                const Center(child: CircularProgressIndicator()),
              if (_error != null)
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_error!,
                          style: const TextStyle(color: Colors.redAccent)),
                      if (_error!.contains('API'))
                        TextButton(
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => const SettingsScreen()),
                          ),
                          child: const Text('روح للإعدادات'),
                        ),
                    ],
                  ),
                ),
              if (_result != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1C1C24),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _result!,
                    style: const TextStyle(color: Colors.white, height: 1.5),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
