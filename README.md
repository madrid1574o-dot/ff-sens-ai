# FF SENS AI (اسم المشروع: ff_assistant)

تطبيق مساعد شخصي لـ Free Fire: بابل عائم + checklist أهداف + تحليل بعد المباراة.

## ⚠️ مهم - شنوة هذا التطبيق يعمل وما يعملش
- ✅ يفتح مينيو سريع فوق أي تطبيق (كيف Messenger)
- ✅ يخليك تحط أهداف قبل الماتش وتتبعهم
- ✅ يحلل screenshot **بعد** ما تخلص المباراة ويقولك الأغلاط
- 🚫 ما يشوفش الشاشة لايف وقت اللعب
- 🚫 ما يتدخلش أوتوماتيكيا جوا اللعبة (auto-aim, auto-fix...)

## خطوات التركيب

### 1. المتطلبات
- Flutter SDK مثبت (`flutter --version`)
- Android Studio أو VS Code

### 2. تثبيت الحزم
```bash
flutter pub get
```

### 3. إعداد إذن الـ Overlay (البابل العائم)
حزمة `flutter_overlay_window` تحتاج تعديل بسيط في:
`android/app/src/main/AndroidManifest.xml` - زيد جوا `<manifest>`:
```xml
<uses-permission android:name="android.permission.SYSTEM_ALERT_WINDOW"/>
```
وجوا `<application>` زيد:
```xml
<service android:name="flutter_overlay_window.OverlayService" android:exported="false"/>
```
(الحزمة فيها توثيق أدق على pub.dev إذا احتجت تفاصيل زيادة)

### 4. مفتاح Claude API
باش تخدم ميزة "تحليل بعد المباراة"، لازم مفتاح API متاعك من Anthropic:
1. روح لـ https://console.anthropic.com
2. أنشئ مفتاح API
3. حطو جوا التطبيق من: الإعدادات → Claude API Key
(الكي تتحفظ محليا في جهازك فقط عبر shared_preferences، ما تتبعتش لأي سيرفر آخر)

### 5. تشغيل (تجربة مباشرة على الهاتف عبر USB)
```bash
flutter run
```
لازم يكون هاتفك (مثلا Samsung Galaxy A17 5G) موصول بالكمبيوتر بكابل USB و"USB debugging" مفعل من إعدادات المطور.

### 6. بناء ملف APK (باش تثبت التطبيق بلاش كمبيوتر)
```bash
flutter clean
flutter build apk --release
```
بعد ما يخلص، تلقى الملف هوني:
```
build/app/outputs/flutter-apk/app-release.apk
```
تبعثلو لهاتفك (بلوتوث، usb، ولا drive) وتفتحو باش يتثبت. Android يمكن يحذرك "مصدر غير معروف" - هذا عادي لتطبيق بنيتو بنفسك، اقبل التثبيت.

## ⚠️ ملاحظة مهمة على أمان الـ API Key
دروك المفتاح متاعك محفوظ **جوا التطبيق نفسه** (على جهازك فقط، عبر shared_preferences) - هاذي طريقة سريعة تخدم فورا، لكن نظريا أي حد يفكك الـ APK متاعك يقدر يلقى المفتاح ويستعملو هو. باش يكون آمن بالكامل، الحل الصحيح هو:
1. تبني سيرفر بسيط (مثلا Node.js على Render/Railway مجانا)
2. المفتاح يتخزن في السيرفر، مش في التطبيق
3. التطبيق يبعث الصورة للسيرفر متاعك، والسيرفر يكلم Claude API ويرجعلك النتيجة

إذا حبيت نبنيلك هذا السيرفر لاحقا، قولي.

## هيكلة المشروع
```
lib/
  models/         # AppSettings, Goal, MatchRecord
  services/       # GoalsRepository, ClaudeService, OverlayService
  screens/        # HomeScreen, ChecklistScreen, MatchAnalysisScreen,
                  # SettingsScreen, HistoryScreen
  overlay_entry.dart  # UI للنافذة الصغيرة اللي تطلع من البابل
  main.dart
```

## 🖼️ تغيير أيقونة التطبيق (Launcher Icon)
`pubspec.yaml` جاهز مسبقا بإعداد `flutter_launcher_icons`. باش تحط أيقونتك الخاصة:
1. صمم أو جهز صورة **من عندك** (مربعة، 1024x1024 بيكسل يفضل) - **ما تستعملش آرت Free Fire الرسمي**، هذا محمي بحقوق الملكية وممكن يسبب مشاكل قانونية للتطبيق متاعك
2. حطها في `assets/app_icon.png` (أنشئ فولدر `assets` إذا ماكانش موجود)
3. نفذ:
```bash
flutter pub get
flutter pub run flutter_launcher_icons
```
4. `flutter build apk --release` من جديد باش الأيقونة الجديدة تتحط

## أفكار لتطوير مستقبلي
- إضافة تصنيف الأخطاء (aim / positioning / rotation) في التحليل
- ربط تلقائي مع آخر screenshot في المعرض
- إحصائيات تطور الأداء عبر الوقت (رسم بياني)
