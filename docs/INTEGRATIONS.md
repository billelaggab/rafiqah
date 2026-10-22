# 🔌 دمج الخدمات الخارجية — Integrations & Services

يوثّق هذا الملف كل الخدمات الخارجية المدمجة في تطبيق رفيقة مع قواعدها الصارمة وتفاصيل التنفيذ.

---

## 1. شبكة إعلانات Google AdMob

### 1.1 مبدأ الربحية الأخلاقية

> الإعلانات مصدر دخل ضروري لاستمرارية التطبيق، لكنها **لا تتقدم أبدًا** على سلامة المستخدمة أو مصداقية الأدوات الصحية.

### 1.2 خريطة توزيع الإعلانات

```text
┌─────────────────────────────────────────────────────────────┐
│                    خريطة الإعلانات                           │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ✅ مناطق مسموحة                                           │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ 📰 شاشات المقالات التثقيفية     → بانر + مدمج       │   │
│  │ 🥗 دليل الأغذية                → بانر أسفل الشاشة  │   │
│  │ 📝 قائمة الأسماء               → بانر أسفل الشاشة  │   │
│  │ 🔄 التنقل بين الأقسام الكبرى    → بيني (Cooldown 4m)│   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  🚫 مناطق محظورة تمامًا (Zero-Ad Zones)                    │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ 🦶 عدّاد ركلات الجنين      (KickCounterScreen)      │   │
│  │ ⏱️ مؤقت الانقباضات         (ContractionTimerScreen)  │   │
│  │ 🏥 توجيه الطوارئ           (EmergencyRoutingScreen)  │   │
│  │ 💜 مقياس EPDS              (EPDSScreen)              │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 1.3 أنواع الإعلانات وقواعدها

| النوع | الموقع | القيود | التنفيذ |
|:---|:---|:---|:---|
| **بانر (Banner)** | أسفل شاشات المقالات ودليل الأغذية | حجم `AdSize.banner` فقط — لا يحجب المحتوى | `BannerAd` |
| **مدمج (Native)** | داخل قوائم المقالات كبطاقة | تصميم متناسق مع ثيم التطبيق — لا يبدو كإعلان متطفل | `NativeAd` |
| **بيني (Interstitial)** | بين الأقسام الكبرى فقط | فاصل ≥ **4 دقائق** بين كل ظهورين | `InterstitialAd` |

### 1.4 إدارة فترات التبريد — `AdCooldownManager`

```dart
// core/services/ad_cooldown_manager.dart

/// يضمن عدم إزعاج المستخدمة بإعلانات بينية متتالية.
/// الحد الأدنى بين كل إعلان بيني = 4 دقائق.
class AdCooldownManager {
  static const _cooldownDuration = Duration(minutes: 4);
  DateTime? _lastInterstitialShown;

  bool get canShowInterstitial {
    if (_lastInterstitialShown == null) return true;
    return DateTime.now().difference(_lastInterstitialShown!) >= _cooldownDuration;
  }

  void recordInterstitialShown() {
    _lastInterstitialShown = DateTime.now();
  }
}
```

### 1.5 قائمة التحقق للنشر

- [ ] استبدال معرّفات الاختبار (`ca-app-pub-3940256099942544`) بمعرّفات AdMob الإنتاجية
- [ ] التأكد من عدم وجود أي إعلان في الشاشات الأربع المحظورة
- [ ] اختبار `AdCooldownManager` يعمل بفاصل 4 دقائق فعليًا
- [ ] التحقق من أن الإعلانات المدمجة متناسقة مع الثيم

---

## 2. التوجيه الجغرافي للمرافق الطبية — Zero-Cost Geo-Routing

### 2.1 المبدأ

> ❌ **لا تستخدم** Google Places API — تكلفتها المادية مرتفعة ولا تناسب تطبيقًا مجانيًا.
>
> ✅ **استخدم** الروابط العميقة لفتح تطبيق خرائط الجهاز الأصلي — مجاني 100%.

### 2.2 المرافق المدعومة

| نوع المرفق | الاستعلام بالعربية | السيناريو |
|:---|:---|:---|
| `gynecology` | عيادة طبيبة نساء وتوليد | متابعة حمل روتينية |
| `laboratory` | مختبر تحاليل طبية | تحاليل دم وبول |
| `maternityHospital` | مستشفى ولادة وأطفال | ولادة أو حالة طوارئ |

### 2.3 التنفيذ الكامل

```dart
// core/services/geo_routing_service.dart
import 'package:url_launcher/url_launcher.dart';

/// أنواع المرافق الطبية المدعومة
enum FacilityType {
  gynecology('عيادة طبيبة نساء وتوليد'),
  laboratory('مختبر تحاليل طبية'),
  maternityHospital('مستشفى ولادة وأطفال');

  final String query;
  const FacilityType(this.query);
}

/// خدمة التوجيه الجغرافي المجاني
///
/// تستخدم Deep Links لفتح تطبيق الخرائط المثبت على الجهاز.
/// إذا لم يكن متاحًا، تفتح Google Maps في المتصفح كبديل.
class GeoRoutingService {
  static Future<void> openNearby(FacilityType type) async {
    // المحاولة الأولى: فتح تطبيق خرائط أصلي عبر geo: URI
    final Uri geoUri = Uri.parse(
      'geo:0,0?q=${Uri.encodeComponent(type.query)}',
    );

    if (await canLaunchUrl(geoUri)) {
      await launchUrl(geoUri, mode: LaunchMode.externalApplication);
    } else {
      // البديل: فتح Google Maps في المتصفح
      final Uri webUri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(type.query)}',
      );
      await launchUrl(webUri, mode: LaunchMode.externalApplication);
    }
  }
}
```

### 2.4 سيناريوهات الاستخدام

```text
┌────────────────────────────────────────────┐
│  🏥 توجيه الطوارئ                          │
│                                            │
│  ┌──────────────────────────────────────┐  │
│  │  🩺 أقرب عيادة نساء وتوليد          │  │
│  └──────────────────────────────────────┘  │
│  ┌──────────────────────────────────────┐  │
│  │  🧪 أقرب مختبر تحاليل طبية          │  │
│  └──────────────────────────────────────┘  │
│  ┌──────────────────────────────────────┐  │
│  │  🏥 أقرب مستشفى ولادة وأطفال        │  │
│  └──────────────────────────────────────┘  │
│                                            │
└────────────────────────────────────────────┘
         │ عند النقر
         ▼
    تطبيق الخرائط يفتح بنتائج البحث
    مع تحديد الموقع الحالي تلقائيًا
```

---

## 3. النسخ الاحتياطي المشفر — Google Drive (`drive.appdata`)

### 3.1 المبادئ الأمنية

| المبدأ | التطبيق |
|:---|:---|
| **تشفير قبل الرفع** | الملف يُشفَّر محليًا **قبل** مغادرة الجهاز |
| **مفتاح محلي حصري** | المفتاح مخزن في Keystore عبر `FlutterSecureStorage` — لا يُرفع للسحابة |
| **مجلد مخفي** | نطاق `drive.appdata` لا يرى ملفات المستخدمة الشخصية على Drive |
| **ملف واحد** | نسخة واحدة باسم `rafiqah_secure_backup.enc` — تُستبدل عند كل نسخ |

### 3.2 مسار النسخ الاحتياطي

```text
               ┌──── النسخ الاحتياطي (Backup) ────┐
               │                                  │
  ┌──────────┐ │ ┌────────┐   ┌──────────┐   ┌──────────────┐
  │  Drift   │─┼►│ تصدير  │──►│ تشفير    │──►│ Google Drive  │
  │ Database │ │ │ SQLite  │   │ AES-GCM  │   │ (appdata)    │
  └──────────┘ │ └────────┘   │ 256-bit  │   │              │
               │              └────┬─────┘   └──────────────┘
               │                   │
               │              FlutterSecureStorage
               │                (مفتاح التشفير)
               │                                  │
               └──── الاستعادة (Restore) ──────────┘
                                  │
  ┌──────────┐   ┌────────┐   ┌──────────┐   ┌──────────────┐
  │  Drift   │◄──│ استبدال│◄──│ فك      │◄──│ Google Drive  │
  │ Database │   │ الملف  │   │ التشفير  │   │ (appdata)    │
  └──────────┘   └────────┘   └──────────┘   └──────────────┘
       │
  إعادة تهيئة Drift Providers
```

### 3.3 التفاصيل التقنية

| البند | القيمة |
|:---|:---|
| **النطاق (Scope)** | `https://www.googleapis.com/auth/drive.appdata` |
| **خوارزمية التشفير** | AES-GCM (256-bit) |
| **مكتبة التشفير** | `encrypt` package |
| **تخزين المفتاح** | `flutter_secure_storage` (Android Keystore) |
| **اسم الملف المرفوع** | `rafiqah_secure_backup.enc` |
| **المصادقة** | `google_sign_in` → OAuth 2.0 |

### 3.4 إجراء النسخ الاحتياطي

```dart
// core/services/backup_service.dart (مخطط مبسط)

class BackupService {
  Future<void> backup() async {
    // 1. تصدير ملف SQLite
    final dbFile = await _getDriftDatabaseFile();
    final bytes = await dbFile.readAsBytes();

    // 2. تشفير محلي بـ AES-GCM
    final key = await _keyManager.getOrCreateKey();
    final encrypted = _aesEncryption.encrypt(bytes, key);

    // 3. رفع إلى Google Drive (appdata)
    await _driveApi.files.create(
      drive.File()..name = 'rafiqah_secure_backup.enc',
      uploadMedia: drive.Media(Stream.value(encrypted), encrypted.length),
    );
  }

  Future<void> restore() async {
    // 1. تنزيل الملف المشفر
    final encryptedBytes = await _downloadFromDrive();

    // 2. فك التشفير محليًا
    final key = await _keyManager.getKey();
    final decrypted = _aesEncryption.decrypt(encryptedBytes, key);

    // 3. استبدال ملف قاعدة البيانات
    await _replaceDriftDatabase(decrypted);

    // 4. إعادة تهيئة Drift Providers
    ref.invalidate(databaseProvider);
  }
}
```

### 3.5 شروط النسخ الاحتياطي

| الشرط | التفاصيل |
|:---|:---|
| **اتصال بالإنترنت** | التحقق عبر `connectivity_plus` قبل البدء |
| **تسجيل دخول Google** | مطلوب — يُطلب من المستخدمة عند أول نسخ |
| **مساحة كافية** | فحص حجم الملف قبل الرفع |
| **عدم تعارض** | قفل قاعدة البيانات أثناء الاستعادة لمنع الكتابة المتزامنة |

---

## 4. الإشعارات المحلية — `flutter_local_notifications`

### 4.1 أنواع الإشعارات

| الإشعار | التوقيت | المحتوى |
|:---|:---|:---|
| **تذكير الدورة** | قبل الموعد المتوقع بيومين | "دورتك القادمة متوقعة بعد يومين 🌸" |
| **نافذة الخصوبة** | بداية نافذة الخصوبة | "بدأت نافذة خصوبتك — أفضل وقت للحمل 🌡️" |
| **فحص الثدي** | بعد انتهاء الدورة بـ 3 أيام | "حان وقت الفحص الذاتي الشهري للثدي 💗" |
| **تطور الجنين** | بداية كل أسبوع حمل جديد | "الأسبوع 20: طفلك بحجم الموزة 🍌" |
| **تذكير الركلات** | يوميًا في الثلث الثالث | "هل سجلتِ ركلات اليوم؟ 🦶" |

### 4.2 القواعد

- الإشعارات **محلية بالكامل** — لا تمر عبر خوادم خارجية
- تُجدوَل عبر `zonedSchedule()` لدعم المناطق الزمنية
- تحترم وضع "عدم الإزعاج" على الجهاز
- يمكن للمستخدمة تعطيل أي نوع من الإعدادات
