import 'package:shared_preferences/shared_preferences.dart';

/// Paramètres globaux de l'application, persistés localement.
class AppSettings {
  // 🔵 Floating Bubble
  static bool bubbleEnabled = true;
  static double bubbleSize = 1.0; // 0.8 = petit, 1.0 = moyen, 1.3 = grand
  static double bubbleOpacity = 0.70;
  static String bubblePosition = 'right'; // 'right' ou 'left'
  static String bubbleTapAction = 'open_menu'; // 'open_menu' ou 'open_game'
  static bool avoidFreeFireButtons = true;

  // 🎯 Checklist
  static bool fixedGoalsEnabled = true;
  static bool customMatchGoalsEnabled = true;
  static bool saveGoalsAfterMatch = true;
  static bool resetGoalsForNewMatch = true;
  static bool goalReminder = false;

  // 📊 Match Analysis (toujours post-match, jamais en direct)
  static String analysisSource = 'screenshot';
  static bool automaticAnalysis = true;
  static String analysisLanguage = 'ar';
  static String analysisLevel = 'detailed';
  static bool saveMatchResults = true;

  // 🔑 Clé API Claude (fournie par l'utilisateur, jamais codée en dur)
  static String claudeApiKey = '';

  // 🎮 Objectifs par défaut
  static List<String> defaultGoals = [
    '🎯 التركيز على الرأس',
    '🧱 استخدام الـCover',
    '🏃 تحسين الحركة',
    '👀 مراقبة الخريطة',
    '🔫 اختيار السلاح المناسب',
    '🧠 عدم الاندفاع بدون سبب',
    '❌ تسجيل الخطأ الذي حصل',
    '✅ تسجيل أفضل لقطة في المباراة',
  ];

  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    bubbleEnabled = prefs.getBool('bubbleEnabled') ?? bubbleEnabled;
    bubbleSize = prefs.getDouble('bubbleSize') ?? bubbleSize;
    bubbleOpacity = prefs.getDouble('bubbleOpacity') ?? bubbleOpacity;
    bubblePosition = prefs.getString('bubblePosition') ?? bubblePosition;
    bubbleTapAction = prefs.getString('bubbleTapAction') ?? bubbleTapAction;
    avoidFreeFireButtons =
        prefs.getBool('avoidFreeFireButtons') ?? avoidFreeFireButtons;
    fixedGoalsEnabled =
        prefs.getBool('fixedGoalsEnabled') ?? fixedGoalsEnabled;
    customMatchGoalsEnabled =
        prefs.getBool('customMatchGoalsEnabled') ?? customMatchGoalsEnabled;
    saveGoalsAfterMatch =
        prefs.getBool('saveGoalsAfterMatch') ?? saveGoalsAfterMatch;
    resetGoalsForNewMatch =
        prefs.getBool('resetGoalsForNewMatch') ?? resetGoalsForNewMatch;
    goalReminder = prefs.getBool('goalReminder') ?? goalReminder;
    analysisLevel = prefs.getString('analysisLevel') ?? analysisLevel;
    claudeApiKey = prefs.getString('claudeApiKey') ?? claudeApiKey;
  }

  static Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('bubbleEnabled', bubbleEnabled);
    await prefs.setDouble('bubbleSize', bubbleSize);
    await prefs.setDouble('bubbleOpacity', bubbleOpacity);
    await prefs.setString('bubblePosition', bubblePosition);
    await prefs.setString('bubbleTapAction', bubbleTapAction);
    await prefs.setBool('avoidFreeFireButtons', avoidFreeFireButtons);
    await prefs.setBool('fixedGoalsEnabled', fixedGoalsEnabled);
    await prefs.setBool('customMatchGoalsEnabled', customMatchGoalsEnabled);
    await prefs.setBool('saveGoalsAfterMatch', saveGoalsAfterMatch);
    await prefs.setBool('resetGoalsForNewMatch', resetGoalsForNewMatch);
    await prefs.setBool('goalReminder', goalReminder);
    await prefs.setString('analysisLevel', analysisLevel);
    await prefs.setString('claudeApiKey', claudeApiKey);
  }
}
