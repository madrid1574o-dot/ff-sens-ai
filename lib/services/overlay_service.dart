import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import '../models/app_settings.dart';

/// Contrôle la bulle flottante système (comme les chat heads de Messenger).
/// Au tap, elle ouvre un petit menu (checklist / analyse) — elle ne fait
/// jamais rien automatiquement dans le jeu lui-même.
class OverlayService {
  static Future<bool> hasPermission() async {
    return await FlutterOverlayWindow.isPermissionGranted();
  }

  static Future<void> requestPermission() async {
    await FlutterOverlayWindow.requestPermission();
  }

  static Future<void> showBubble() async {
    if (!AppSettings.bubbleEnabled) return;
    final granted = await hasPermission();
    if (!granted) {
      await requestPermission();
      return;
    }

    final alignment = AppSettings.bubblePosition == 'left'
        ? OverlayAlignment.centerLeft
        : OverlayAlignment.centerRight;

    await FlutterOverlayWindow.showOverlay(
      height: (60 * AppSettings.bubbleSize).round(),
      width: (60 * AppSettings.bubbleSize).round(),
      alignment: alignment,
      flag: OverlayFlag.defaultFlag,
      visibility: NotificationVisibility.visibilityPublic,
      overlayTitle: 'FF Assistant',
      positionGravity: PositionGravity.auto,
    );
  }

  static Future<void> hideBubble() async {
    await FlutterOverlayWindow.closeOverlay();
  }
}
