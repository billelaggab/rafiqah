# 🗄️ تصميم وهندسة قاعدة البيانات المحلية — Drift Schema

قاعدة البيانات مبنية بـ SQLite عبر محرك **Drift** لضمان فحص الأنماط وقت التصريف (Compile-time Type Safety). جميع البيانات تُخزَّن محليًا حصريًا على جهاز المستخدمة.

---

## 1. مخطط العلاقات (Entity Relationship)

```text
┌──────────────┐       ┌──────────────┐       ┌──────────────┐
│ UserProfiles │       │ MenstrualLogs│       │ KickSessions │
│──────────────│       │──────────────│       │──────────────│
│ id (PK)      │       │ id (PK)      │       │ id (PK)      │
│ currentMode  │       │ date         │       │ startTime    │
│ lmpDate      │       │ flowIntensity│       │ endTime      │
│ eddDate      │       │ painLevel    │       │ kickCount    │
│ preWeight    │       │ bbtTemp      │       │ durationSecs │
│ height       │       │ symptoms     │       └──────────────┘
│ biometric    │       └──────────────┘
└──────────────┘
                       ┌────────────────┐     ┌──────────────┐
                       │ContractionLogs │     │ BabyCareLogs │
                       │────────────────│     │──────────────│
                       │ id (PK)        │     │ id (PK)      │
                       │ startTime      │     │ timestamp    │
                       │ endTime        │     │ logType      │
                       │ durationSecs   │     │ durationMins │
                       │ intervalSecs   │     │ amountMl     │
                       │ intensity      │     │ diaperStatus │
                       └────────────────┘     └──────────────┘

                       ┌──────────────┐
                       │FoodDirectory │  ← Pre-populated (+200 صنف)
                       │──────────────│
                       │ id (PK)      │
                       │ nameArabic   │
                       │ category     │
                       │ safetyLevel  │
                       │ reasonMedical│
                       │ pregAdvice   │
                       │ postAdvice   │
                       └──────────────┘
```

---

## 2. تعريف الجداول التفصيلي

### 2.1 جدول المستخدم والإعدادات — `UserProfiles`

```dart
// core/database/tables/user_profiles.dart
class UserProfiles extends Table {
  IntColumn    get id                  => integer().autoIncrement()();
  TextColumn   get currentMode         => text()();
  // القيم المسموحة: 'cycle', 'ttc', 'pregnancy', 'postpartum'
  DateTimeColumn get lmpDate           => dateTime().nullable()();
  // تاريخ آخر دورة شهرية — أساس حساب EDD
  DateTimeColumn get eddDate           => dateTime().nullable()();
  // موعد الولادة المتوقع — يُحسب تلقائيًا من lmpDate
  RealColumn   get prePregnancyWeight  => real().nullable()();
  // الوزن قبل الحمل بالكيلوجرام
  RealColumn   get height             => real().nullable()();
  // الطول بالسنتيمتر
  BoolColumn   get isBiometricEnabled  => boolean().withDefault(const Constant(false))();
  // تفعيل القفل البيومتري (بصمة / وجه)
}
```

### 2.2 جدول الدورة والخصوبة — `MenstrualLogs`

```dart
// core/database/tables/menstrual_logs.dart
class MenstrualLogs extends Table {
  IntColumn      get id              => integer().autoIncrement()();
  DateTimeColumn get date            => dateTime()();
  // تاريخ التسجيل اليومي
  IntColumn      get flowIntensity   => integer()();
  // شدة التدفق: 1 = خفيف، 2 = متوسط، 3 = غزير
  IntColumn      get painLevel       => integer().withDefault(const Constant(0))();
  // مستوى الألم: 0 = بدون، 1 = خفيف، 2 = متوسط، 3 = شديد
  RealColumn     get bbtTemperature  => real().nullable()();
  // حرارة الجسم القاعدية (BBT) بالدرجة المئوية — لتأكيد التبويض
  TextColumn     get symptoms        => text().nullable()();
  // الأعراض كمصفوفة JSON: ["صداع", "تقلبات_مزاجية", "إفرازات"]
}
```

### 2.3 جدول عدّاد الركلات — `KickSessions`

```dart
// core/database/tables/kick_sessions.dart
class KickSessions extends Table {
  IntColumn      get id              => integer().autoIncrement()();
  DateTimeColumn get startTime       => dateTime()();
  // وقت بدء جلسة العد
  DateTimeColumn get endTime         => dateTime().nullable()();
  // وقت الانتهاء — null تعني الجلسة لا تزال نشطة
  IntColumn      get kickCount       => integer()();
  // عدد الركلات المسجلة
  IntColumn      get durationSeconds => integer()();
  // المدة الإجمالية بالثواني
}
```

### 2.4 جدول مؤقت الانقباضات — `ContractionLogs`

```dart
// core/database/tables/contraction_logs.dart
class ContractionLogs extends Table {
  IntColumn      get id              => integer().autoIncrement()();
  DateTimeColumn get startTime       => dateTime()();
  // وقت بدء الانقباضة
  DateTimeColumn get endTime         => dateTime()();
  // وقت انتهاء الانقباضة
  IntColumn      get durationSeconds => integer()();
  // مدة الانقباضة بالثواني
  IntColumn      get intervalSeconds => integer()();
  // الفاصل الزمني بين هذه الانقباضة والسابقة
  IntColumn      get intensity       => integer()();
  // الشدة: 1 = محتملة، 2 = متوسطة، 3 = شديدة
}
```

### 2.5 دليل الأغذية — `FoodDirectory`

```dart
// core/database/tables/food_directory.dart
class FoodDirectory extends Table {
  IntColumn  get id              => integer().autoIncrement()();
  TextColumn get nameArabic      => text().withLength(min: 2, max: 100)();
  // اسم الصنف الغذائي بالعربية
  TextColumn get category        => text()();
  // التصنيف: ألبان، لحوم، أعشاب، بحريات، فواكه، خضروات، مشروبات
  IntColumn  get safetyLevel     => integer()();
  // مستوى الأمان: 1 = آمن ✅، 2 = بحذر ⚠️، 3 = ممنوع 🚫
  TextColumn get reasonMedical   => text()();
  // السبب الطبي للتصنيف (ليستيريا، توكسوبلازميا، زئبق، كافيين...)
  TextColumn get pregnancyAdvice => text()();
  // نصيحة خاصة بفترة الحمل
  TextColumn get postpartumAdvice => text()();
  // نصيحة خاصة بفترة ما بعد الولادة والرضاعة
}
```

### 2.6 جدول رعاية الرضيع — `BabyCareLogs`

```dart
// core/database/tables/baby_care_logs.dart
class BabyCareLogs extends Table {
  IntColumn      get id              => integer().autoIncrement()();
  DateTimeColumn get timestamp       => dateTime()();
  // وقت التسجيل
  TextColumn     get logType         => text()();
  // النوع: 'feed_left', 'feed_right', 'bottle', 'diaper', 'sleep'
  IntColumn      get durationMinutes => integer().nullable()();
  // المدة بالدقائق (للرضاعة والنوم)
  RealColumn     get amountMl        => real().nullable()();
  // الكمية بالمل (للرضاعة الصناعية)
  TextColumn     get diaperStatus    => text().nullable()();
  // حالة الحفاض: 'wet', 'soiled', 'both', 'clean'
}
```

---

## 3. كائنات الوصول للبيانات — DAOs

كل مجال وظيفي له DAO مستقل لضمان عزل المسؤوليات:

| DAO | الجداول | المسؤولية |
|:---|:---|:---|
| `UserProfileDao` | `UserProfiles` | إدارة الملف الشخصي والوضع الحالي |
| `CycleDao` | `MenstrualLogs` | تسجيل الدورة، حساب المتوسطات، التنبؤ |
| `PregnancyDao` | `KickSessions`, `ContractionLogs` | عدّاد الركلات ومؤقت الانقباضات |
| `BabyDao` | `BabyCareLogs` | تسجيل الرضاعة والنوم والحفاضات |
| `FoodDao` | `FoodDirectory` | بحث الأغذية والتصفية حسب الأمان |

---

## 4. استراتيجية التهيئة والتغذية المسبقة

### 4.1 عند الإنشاء الأول — `onCreate`

```dart
@override
MigrationStrategy get migration => MigrationStrategy(
  onCreate: (Migrator m) async {
    await m.createAll();

    // 1. إدراج سجل افتراضي بوضع 'pregnancy'
    await into(userProfiles).insert(
      UserProfilesCompanion.insert(currentMode: 'pregnancy'),
    );

    // 2. حقن +200 صنف غذائي من ملف JSON
    final String jsonStr = await rootBundle.loadString('assets/data/foods_init.json');
    final List<dynamic> foods = jsonDecode(jsonStr);
    for (final food in foods) {
      await into(foodDirectory).insert(
        FoodDirectoryCompanion.insert(/* ... */),
      );
    }
  },
);
```

### 4.2 عند التحديث — `onUpgrade`

```dart
onUpgrade: (Migrator m, int from, int to) async {
  // هجرة آمنة تضمن عدم فقدان بيانات المستخدمة
  if (from < 2) {
    // إضافة عمود جديد بدون حذف البيانات الموجودة
    await m.addColumn(userProfiles, userProfiles.height);
  }
  if (from < 3) {
    await m.createTable(babyCareLogs);
  }
},
```

> ⚠️ **قاعدة صارمة:** كل هجرة يجب اختبارها بحالة اختبار مخصصة تتحقق من:
> 1. عدم فقدان أي بيانات مُسجلة سابقًا
> 2. القيم الافتراضية للأعمدة الجديدة سليمة
> 3. التطبيق يعمل بشكل طبيعي بعد الهجرة

---

## 5. قواعد الاستعلام

| القاعدة | التفاصيل |
|:---|:---|
| **Type-safe DSL فقط** | ممنوع استخدام `customSelect()` أو Raw SQL مباشر |
| **Streams للبيانات الحية** | استخدم `watch()` بدلًا من `get()` لتحديثات الواجهة التفاعلية |
| **Batch Operations** | عمليات الإدخال الجماعي (الأغذية) تستخدم `batch()` لتحسين الأداء |
| **Transactions** | العمليات المترابطة تُنفَّذ داخل `transaction()` لضمان الذرية |
