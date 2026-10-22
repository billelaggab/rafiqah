# 🏗️ المعمارية البرمجية والهيكل التقني — Architecture

يعتمد تطبيق **رفيقة** على معمارية **Feature-First Clean Architecture** لتأمين قابلية التوسع والصيانة المستقلة لكل وضع من الأوضاع الأربعة.

---

## 1. شجرة المجلدات المعتمدة

```text
lib/
├── app/
│   ├── app.dart                        # MaterialApp الجذري مع إعدادات RTL
│   ├── routes.dart                     # جدول التنقل المركزي (GoRouter أو Navigator 2.0)
│   └── theme/
│       ├── app_colors.dart             # لوحة الألوان المهدئة
│       ├── app_text_styles.dart        # أنماط النصوص (Tajawal / Cairo)
│       └── app_theme.dart              # ThemeData مع دعم RTL كامل
│
├── core/
│   ├── database/
│   │   ├── app_database.dart           # @DriftDatabase الرئيسي
│   │   ├── app_database.g.dart         # ملف مولّد تلقائيًا (build_runner)
│   │   └── migrations/                 # استراتيجية هجرة المخطط
│   │
│   ├── network/
│   │   └── connectivity_checker.dart   # فحص الاتصال بالإنترنت (للنسخ الاحتياطي فقط)
│   │
│   ├── security/
│   │   ├── aes_encryption.dart         # تشفير AES-GCM 256-bit
│   │   └── key_manager.dart            # إدارة المفاتيح عبر FlutterSecureStorage
│   │
│   ├── services/
│   │   ├── notification_service.dart   # إشعارات محلية (تذكيرات، تنبيهات)
│   │   ├── geo_routing_service.dart    # توجيه جغرافي مجاني (Deep Links)
│   │   └── backup_service.dart         # نسخ احتياطي مشفر على Google Drive
│   │
│   └── utils/
│       ├── medical_calculator.dart     # المعادلات الطبية (EDD، التبويض، 5-1-1)
│       ├── date_utils.dart             # أدوات مساعدة للتواريخ الهجرية والميلادية
│       └── constants.dart              # الثوابت العامة
│
└── features/
    ├── mode_selector/                  # محرك التبديل بين الأوضاع الأربعة
    │   ├── data/
    │   │   └── mode_repository.dart
    │   ├── domain/
    │   │   └── app_mode.dart           # enum: cycle, ttc, pregnancy, postpartum
    │   └── presentation/
    │       ├── providers/
    │       │   └── app_mode_notifier.dart
    │       └── screens/
    │           └── mode_selector_screen.dart
    │
    ├── cycle_tracker/                  # وضع متابعة الدورة الشهرية
    │   ├── data/
    │   │   └── cycle_dao.dart
    │   ├── domain/
    │   │   ├── cycle_entity.dart
    │   │   └── cycle_predictor.dart
    │   └── presentation/
    │       ├── providers/
    │       └── screens/
    │
    ├── ttc/                            # وضع التخطيط للحمل
    │   ├── data/
    │   ├── domain/
    │   │   ├── ovulation_calculator.dart
    │   │   └── bbt_analyzer.dart
    │   └── presentation/
    │
    ├── pregnancy/                      # وضع الحمل
    │   ├── data/
    │   │   ├── pregnancy_dao.dart
    │   │   └── kick_session_dao.dart
    │   ├── domain/
    │   │   ├── edd_calculator.dart
    │   │   ├── fetal_growth.dart
    │   │   └── contraction_analyzer.dart
    │   └── presentation/
    │       ├── providers/
    │       └── screens/
    │           ├── pregnancy_dashboard_screen.dart
    │           ├── kick_counter_screen.dart
    │           ├── contraction_timer_screen.dart
    │           └── emergency_routing_screen.dart
    │
    ├── postpartum/                     # وضع ما بعد الولادة
    │   ├── data/
    │   ├── domain/
    │   │   └── epds_scorer.dart
    │   └── presentation/
    │       └── screens/
    │           ├── postpartum_dashboard_screen.dart
    │           └── epds_screen.dart
    │
    ├── baby_tracker/                   # رعاية وتتبع الرضيع
    │   ├── data/
    │   │   └── baby_dao.dart
    │   ├── domain/
    │   └── presentation/
    │
    ├── food_directory/                 # دليل الأغذية التفاعلي
    │   ├── data/
    │   │   └── food_dao.dart
    │   ├── domain/
    │   └── presentation/
    │
    └── settings/                       # الإعدادات والنسخ الاحتياطي
        ├── data/
        ├── domain/
        └── presentation/
```

---

## 2. نمط إدارة الحالة — Riverpod v2

### 2.1 تدفق البيانات وحيد الاتجاه (Unidirectional Data Flow)

```text
┌──────────────┐      ┌──────────────────┐      ┌──────────────┐      ┌───────────────┐
│  UI Widget   │ ───► │ Riverpod Notifier │ ───► │  Repository  │ ───► │ Drift DAO     │
│  (يعرض فقط)  │ ◄─── │ (منطق الأعمال)    │ ◄─── │  (تجريد)     │ ◄─── │ (SQLite)      │
└──────────────┘      └──────────────────┘      └──────────────┘      └───────────────┘
     ref.watch              state                    CRUD                 Type-safe
```

### 2.2 الأنماط المعتمدة والمحظورة

| النمط | الحالة | السبب |
|:---|:---:|:---|
| `NotifierProvider` | ✅ | حالات متزامنة سريعة (عدّادات، مؤقتات) |
| `AsyncNotifierProvider` | ✅ | عمليات غير متزامنة (Drift، Drive) |
| `ref.watch(p.select(...))` | ✅ | إعادة بناء انتقائية — ضروري للمؤقتات |
| `StateProvider` | ❌ | نمط قديم مُهمَل في Riverpod v2 |
| `ChangeNotifierProvider` | ❌ | نمط قديم — يخلط بين Flutter و Riverpod |
| `StateNotifierProvider` | ❌ | مُهمَل — استُبدل بـ `NotifierProvider` |

### 2.3 مثال التدفق الكامل

```text
KickCounterScreen
  └─► ref.watch(kickCounterProvider)
        └─► KickCounterNotifier (NotifierProvider)
              ├─► state.kickCount      → العرض في الواجهة
              ├─► state.elapsedTime    → المؤقت
              └─► recordKick()
                    └─► KickSessionRepository
                          └─► KickSessionDao.insertSession()
                                └─► Drift → SQLite
```

---

## 3. مبادئ التصميم البرمجي

### 3.1 القواعد الأساسية

| المبدأ | الوصف |
|:---|:---|
| **Zero External Dependency for Core Logic** | الميزات الحيوية (عدّ الركلات، مؤقت الولادة، متابعة التبويض) لا تعتمد على الإنترنت نهائيًا |
| **Strict No-Crash Policy** | جميع الحسابات الطبية والتحويلات الزمنية محاطة بمعالجة أخطاء صارمة (try-catch / Result Pattern) |
| **Optimized Rebuilds** | استخدام `select` في Riverpod لمنع إعادة بناء الشاشات ذات المؤقتات التفاعلية |
| **Compile-time Safety** | Drift يضمن فحص الأنماط وقت التصريف — لا مفاجآت في وقت التشغيل |

### 3.2 الفصل بين الطبقات

```text
┌─────────────────────────────────────────────────────┐
│                  Presentation Layer                  │
│    Screens ← Providers ← Widgets                    │
│    (لا منطق أعمال — عرض فقط)                         │
├─────────────────────────────────────────────────────┤
│                    Domain Layer                      │
│    Entities ← UseCases ← Medical Calculators         │
│    (المعادلات الطبية ومنطق الأعمال الصرف)             │
├─────────────────────────────────────────────────────┤
│                     Data Layer                       │
│    Repositories ← DAOs ← Drift Database             │
│    (التخزين والاسترجاع — لا منطق أعمال)              │
└─────────────────────────────────────────────────────┘
```

### 3.3 قواعد الأداء

| الهدف | المعيار |
|:---|:---|
| **استجابة المؤقتات** | < 16ms لكل إطار (60fps) |
| **فتح التطبيق** | < 2 ثانية حتى الشاشة الرئيسية |
| **بحث الأغذية** | < 100ms لنتائج البحث المحلي |
| **استهلاك البطارية** | تحسين المؤقتات لتقليل الاستهلاك أثناء المراقبة الطويلة |
