import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_settings.dart';
import '../models/goal.dart';

class GoalsRepository {
  static const _currentGoalsKey = 'current_goals';
  static const _historyKey = 'match_history';

  /// Charge la checklist courante. Si elle n'existe pas encore,
  /// la construit à partir des objectifs par défaut.
  static Future<List<Goal>> loadCurrentGoals() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_currentGoalsKey);
    if (raw == null) {
      return AppSettings.defaultGoals
          .map((t) => Goal(id: t.hashCode.toString(), text: t))
          .toList();
    }
    final list = jsonDecode(raw) as List;
    return list.map((g) => Goal.fromJson(g)).toList();
  }

  static Future<void> saveCurrentGoals(List<Goal> goals) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _currentGoalsKey,
      jsonEncode(goals.map((g) => g.toJson()).toList()),
    );
  }

  /// Réinitialise la checklist pour un nouveau match (garde les objectifs
  /// fixes, enlève les objectifs personnalisés, remet done=false).
  static Future<List<Goal>> resetForNewMatch(List<Goal> current) async {
    final reset = current
        .where((g) => !g.isCustom)
        .map((g) => Goal(id: g.id, text: g.text, done: false))
        .toList();
    await saveCurrentGoals(reset);
    return reset;
  }

  static Future<void> addMatchToHistory(MatchRecord record) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_historyKey) ?? [];
    raw.add(jsonEncode(record.toJson()));
    await prefs.setStringList(_historyKey, raw);
  }

  static Future<List<MatchRecord>> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_historyKey) ?? [];
    return raw
        .map((r) => MatchRecord.fromJson(jsonDecode(r)))
        .toList()
        .reversed
        .toList();
  }

  static Future<void> deleteFromHistory(String matchId) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_historyKey) ?? [];
    final filtered = raw.where((r) {
      final m = MatchRecord.fromJson(jsonDecode(r));
      return m.id != matchId;
    }).toList();
    await prefs.setStringList(_historyKey, filtered);
  }
}
