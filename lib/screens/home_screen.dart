import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import '../models/app_settings.dart';
import '../services/overlay_service.dart';
import 'checklist_screen.dart';
import 'match_analysis_screen.dart';
import 'settings_screen.dart';
import 'history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _bubbleOn = AppSettings.bubbleEnabled;
  StreamSubscription? _overlaySub;

  @override
  void initState() {
    super.initState();
    // يستقبل الضغطات اللي تصير جوا البابل العائم ويفتح الشاشة المطلوبة
    // في التطبيق الرئيسي.
    _overlaySub = FlutterOverlayWindow.overlayListener.listen((event) {
      if (!mounted) return;
      switch (event) {
        case 'open_checklist':
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const ChecklistScreen()),
          );
          break;
        case 'open_analysis':
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const MatchAnalysisScreen()),
          );
          break;
        case 'open_history':
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const HistoryScreen()),
          );
          break;
        case 'open_settings':
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const SettingsScreen()),
          );
          break;
      }
    });
  }

  @override
  void dispose() {
    _overlaySub?.cancel();
    super.dispose();
  }

  Future<void> _toggleBubble(bool value) async {
    setState(() => _bubbleOn = value);
    AppSettings.bubbleEnabled = value;
    await AppSettings.save();
    if (value) {
      await OverlayService.showBubble();
    } else {
      await OverlayService.hideBubble();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FF SENS AI'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1C1C24),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFFFC107)),
                  ),
                  child: const Icon(Icons.videogame_asset,
                      color: Color(0xFFFFC107)),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text('FF SENS AI',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppSettings.claudeApiKey.isEmpty
                        ? Colors.red.withOpacity(0.15)
                        : Colors.green.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    AppSettings.claudeApiKey.isEmpty
                        ? '● AI غير متصل'
                        : '● AI متصل',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppSettings.claudeApiKey.isEmpty
                          ? Colors.redAccent
                          : Colors.greenAccent,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.bubble_chart,
                        color: Color(0xFFFFC107), size: 32),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('البابل العائم',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          Text('يفتح مينيو سريع فوق أي تطبيق',
                              style: TextStyle(
                                  color: Colors.white54, fontSize: 12)),
                        ],
                      ),
                    ),
                    Switch(
                      value: _bubbleOn,
                      activeColor: const Color(0xFFFFC107),
                      onChanged: _toggleBubble,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _FeatureTile(
              icon: Icons.checklist_rtl,
              title: 'Checklist الأهداف',
              subtitle: 'حدد أهدافك قبل الماتش وتابعهم',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ChecklistScreen()),
              ),
            ),
            const SizedBox(height: 12),
            _FeatureTile(
              icon: Icons.image_search,
              title: 'تحليل بعد المباراة',
              subtitle: 'ارفع screenshot وخوذ تحليل مفصل للأغلاط',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (_) => const MatchAnalysisScreen()),
              ),
            ),
            const SizedBox(height: 12),
            _FeatureTile(
              icon: Icons.history,
              title: 'سجل الماتشات',
              subtitle: 'شوف التحليلات والأهداف القديمة',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const HistoryScreen()),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF1C1C24),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'ملاحظة: هذا تطبيق تدريب شخصي. التحليل يصير بعد ما تخلص المباراة فقط، ماعندوش أي تدخل أوتوماتيكي جوا اللعبة وقت اللعب.',
                style: TextStyle(color: Colors.white38, fontSize: 11),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _FeatureTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: const Color(0xFFFFC107)),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        subtitle:
            Text(subtitle, style: const TextStyle(color: Colors.white54)),
        trailing: const Icon(Icons.chevron_left, color: Colors.white38),
      ),
    );
  }
}
