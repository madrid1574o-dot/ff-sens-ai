import 'package:flutter/material.dart';
import 'models/app_settings.dart';
import 'screens/home_screen.dart';
import 'overlay_entry.dart';

// Point d'entrée requis par flutter_overlay_window : code exécuté à
// l'intérieur de la petite fenêtre flottante elle-même.
@pragma('vm:entry-point')
void overlayMain() {
  runApp(const OverlayMenuApp());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppSettings.load();
  runApp(const FFAssistantApp());
}

class FFAssistantApp extends StatelessWidget {
  const FFAssistantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FF Assistant',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0D0D12),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFFC107),
          brightness: Brightness.dark,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF16161D),
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFFC107),
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        cardTheme: const CardThemeData(
          color: Color(0xFF1C1C24),
          elevation: 0,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
