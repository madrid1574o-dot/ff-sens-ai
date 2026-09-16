import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

/// C'est ce mini écran qui s'affiche quand l'utilisateur appuie sur la
/// bulle flottante. Juste des raccourcis — aucune automatisation de jeu.
class OverlayMenuApp extends StatelessWidget {
  const OverlayMenuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1C1C24),
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(color: Colors.black54, blurRadius: 10),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _MenuButton(
                  icon: Icons.checklist,
                  label: 'Checklist',
                  onTap: () {
                    // Renvoie le choix à l'app principale via shareData.
                    FlutterOverlayWindow.shareData('open_checklist');
                  },
                ),
                const SizedBox(height: 8),
                _MenuButton(
                  icon: Icons.image_search,
                  label: 'تحليل Screenshot',
                  onTap: () {
                    FlutterOverlayWindow.shareData('open_analysis');
                  },
                ),
                const SizedBox(height: 8),
                _MenuButton(
                  icon: Icons.history,
                  label: 'آخر تحليل',
                  onTap: () {
                    FlutterOverlayWindow.shareData('open_history');
                  },
                ),
                const SizedBox(height: 8),
                _MenuButton(
                  icon: Icons.settings,
                  label: 'إعدادات',
                  onTap: () {
                    FlutterOverlayWindow.shareData('open_settings');
                  },
                ),
                const SizedBox(height: 8),
                _MenuButton(
                  icon: Icons.close,
                  label: 'إخفاء',
                  onTap: () => FlutterOverlayWindow.closeOverlay(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MenuButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: const Color(0xFFFFC107), size: 20),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
