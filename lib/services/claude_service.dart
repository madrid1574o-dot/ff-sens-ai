import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/app_settings.dart';

/// Envoie UNE capture d'écran (prise après la fin du match) à l'API Claude
/// pour obtenir une analyse : erreurs commises + conseils d'amélioration.
///
/// Important : ce service ne fonctionne que sur une image statique fournie
/// par l'utilisateur après coup. Il n'y a aucun accès à l'écran en direct
/// et aucune automatisation pendant une partie en cours.
class ClaudeService {
  static const _endpoint = 'https://api.anthropic.com/v1/messages';

  static Future<String> analyzeScreenshot(File imageFile) async {
    if (AppSettings.claudeApiKey.isEmpty) {
      throw Exception(
          'ما فماش مفتاح API. دخل مفتاح Claude API متاعك من الإعدادات أولا.');
    }

    final bytes = await imageFile.readAsBytes();
    final base64Image = base64Encode(bytes);
    final mediaType =
        imageFile.path.toLowerCase().endsWith('.png') ? 'image/png' : 'image/jpeg';

    final languageInstruction = AppSettings.analysisLanguage == 'ar'
        ? 'أجب باللغة العربية (اللهجة التونسية إذا أمكن).'
        : 'Respond in French.';

    final levelInstruction = AppSettings.analysisLevel == 'detailed'
        ? 'أعطي تحليل مفصل مع أمثلة دقيقة من الصورة.'
        : 'أعطي ملخص قصير وسريع.';

    final prompt = '''
هاذي صورة screenshot من ماتش Free Fire (ملتقطة يدويا من طرف اللاعب بعد أو أثناء وقفة في المباراة).
حللها وأعطيني تحليل منظم تحت هاذي العناوين بالضبط:

🎯 التصويب
🏃 الحركة
🧱 استخدام الـCover
👀 قراءة الوضع داخل المباراة
🔫 السلاح
🧠 القرار التكتيكي
❌ الأخطاء الظاهرة
✅ الأشياء الجيدة
📈 اقتراحات للتحسين

قاعدة مهمة جدا: لا تخترع معلومات لا تظهر بوضوح في الصورة. إذا ما نجمتش تحدد شي حاجة من الصورة، اكتب بالضبط: "لا يمكن تحديد ذلك من الصورة."

$levelInstruction
$languageInstruction
''';

    final response = await http.post(
      Uri.parse(_endpoint),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': AppSettings.claudeApiKey,
        'anthropic-version': '2023-06-01',
      },
      body: jsonEncode({
        'model': 'claude-sonnet-4-6',
        'max_tokens': 1024,
        'messages': [
          {
            'role': 'user',
            'content': [
              {
                'type': 'image',
                'source': {
                  'type': 'base64',
                  'media_type': mediaType,
                  'data': base64Image,
                }
              },
              {'type': 'text', 'text': prompt}
            ]
          }
        ]
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('خطأ من الـ API: ${response.statusCode} - ${response.body}');
    }

    final data = jsonDecode(utf8.decode(response.bodyBytes));
    final content = data['content'] as List;
    final textBlocks = content
        .where((b) => b['type'] == 'text')
        .map((b) => b['text'] as String)
        .join('\n');
    return textBlocks;
  }
}
