// lib/core/database/app_database.dart
import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables/user_profiles.dart';
import 'tables/menstrual_logs.dart';
import 'tables/kick_sessions.dart';
import 'tables/contraction_logs.dart';
import 'tables/food_directory.dart';
import 'tables/baby_care_logs.dart';
import 'tables/epds_results.dart';
import 'tables/baby_measurements.dart';

part 'app_database.g.dart';
part 'daos/user_profile_dao.dart';
part 'daos/cycle_dao.dart';
part 'daos/pregnancy_dao.dart';
part 'daos/baby_dao.dart';
part 'daos/food_dao.dart';
part 'daos/postpartum_dao.dart';

@DriftDatabase(
  tables: [
    UserProfiles,
    MenstrualLogs,
    KickSessions,
    ContractionLogs,
    FoodDirectory,
    BabyCareLogs,
    EpdsResults,
    BabyMeasurements,
  ],
  daos: [
    UserProfileDao,
    CycleDao,
    PregnancyDao,
    BabyDao,
    FoodDao,
    PostpartumDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// للاختبارات فقط — يسمح باستخدام قاعدة في الذاكرة.
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
          await into(userProfiles).insert(
            UserProfilesCompanion.insert(currentMode: ''),
          );
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 2) {
            await m.addColumn(userProfiles, userProfiles.cycleLength);
            await m.addColumn(userProfiles, userProfiles.onboardingCompleted);
            await m.createTable(epdsResults);
            await m.createTable(babyMeasurements);
          }
          if (from == 2) {
            await m.addColumn(babyMeasurements, babyMeasurements.ageMonths);
          }
        },
      );

  /// يزرع دليل الأغذية عند أول تشغيل أو إذا كانت القاعدة موجودة بلا بيانات.
  ///
  /// يجب استدعاؤها من الـisolate الرئيسي لأنها تقرأ من `rootBundle`.
  Future<void> ensureFoodSeeded() async {
    if (await foodDao.count() > 0) return;
    final jsonStr = await rootBundle.loadString('assets/data/foods_init.json');
    final List<dynamic> foods = jsonDecode(jsonStr) as List<dynamic>;
    await foodDao.seed(foods.cast<Map<String, dynamic>>());
  }

  /// ينشئ نسخة متسقة من القاعدة (بما فيها آخر المعاملات) في [path].
  Future<void> vacuumInto(String path) async {
    final escaped = path.replaceAll("'", "''");
    await customStatement("VACUUM INTO '$escaped'");
  }

  /// يستعيد نسخة احتياطية داخل القاعدة الحالية دون إغلاقها.
  ///
  /// يتحقق من سلامة الملف ومن توافق إصدار المخطط قبل أي كتابة.
  Future<void> restoreFromBackup(Uint8List bytes) async {
    final dir = await getTemporaryDirectory();
    final tmp = File(
      p.join(dir.path, 'restore_${DateTime.now().microsecondsSinceEpoch}.sqlite'),
    );
    await tmp.writeAsBytes(bytes, flush: true);
    final escaped = tmp.path.replaceAll("'", "''");
    var attached = false;
    try {
      await customStatement("ATTACH DATABASE '$escaped' AS backup");
      attached = true;

      final integrityRows =
          await customSelect('PRAGMA backup.integrity_check').get();
      final integrityOk = integrityRows.isNotEmpty &&
          integrityRows.every(
            (row) => row.data.values.first.toString() == 'ok',
          );
      if (!integrityOk) {
        throw StateError('ملف النسخة الاحتياطية تالف');
      }

      final versionRow =
          await customSelect('PRAGMA backup.user_version').getSingle();
      final version = versionRow.data.values.first as int?;
      if (version != schemaVersion) {
        throw StateError('إصدار النسخة الاحتياطية غير متوافق');
      }

      final tables = <String>[
        'user_profiles',
        'menstrual_logs',
        'kick_sessions',
        'contraction_logs',
        'food_directory',
        'baby_care_logs',
        'epds_results',
        'baby_measurements',
      ];

      await transaction(() async {
        for (final table in tables) {
          await customStatement('DELETE FROM main.$table');
          await customStatement(
            'INSERT INTO main.$table SELECT * FROM backup.$table',
          );
        }
      });
    } finally {
      if (attached) {
        await customStatement('DETACH DATABASE backup');
      }
      if (await tmp.exists()) {
        await tmp.delete();
      }
    }
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'rafiqah.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

void debugLog(Object? message) {
  if (kDebugMode) debugPrint('$message');
}
