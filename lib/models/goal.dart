class Goal {
  final String id;
  String text;
  bool done;
  bool enabled;
  final bool isCustom;

  Goal({
    required this.id,
    required this.text,
    this.done = false,
    this.enabled = true,
    this.isCustom = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'done': done,
        'enabled': enabled,
        'isCustom': isCustom,
      };

  factory Goal.fromJson(Map<String, dynamic> json) => Goal(
        id: json['id'],
        text: json['text'],
        done: json['done'] ?? false,
        enabled: json['enabled'] ?? true,
        isCustom: json['isCustom'] ?? false,
      );
}

class MatchRecord {
  final String id;
  final DateTime date;
  final List<Goal> goals;
  final String? analysisResult;
  final String? screenshotPath;

  MatchRecord({
    required this.id,
    required this.date,
    required this.goals,
    this.analysisResult,
    this.screenshotPath,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'goals': goals.map((g) => g.toJson()).toList(),
        'analysisResult': analysisResult,
        'screenshotPath': screenshotPath,
      };

  factory MatchRecord.fromJson(Map<String, dynamic> json) => MatchRecord(
        id: json['id'],
        date: DateTime.parse(json['date']),
        goals: (json['goals'] as List)
            .map((g) => Goal.fromJson(g))
            .toList(),
        analysisResult: json['analysisResult'],
        screenshotPath: json['screenshotPath'],
      );
}
