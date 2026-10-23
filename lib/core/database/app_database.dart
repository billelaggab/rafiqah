// lib/core/database/app_database.dart
import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables/user_profiles.dart';
import 'tables/menstrual_logs.dart';
import 'tables/kick_sessions.dart';
import 'tables/contraction_logs.dart';
import 'tables/food_directory.dart';
import 'tables/baby_care_logs.dart';

part 'app_database.g.dart';
part 'daos/user_profile_dao.dart';
part 'daos/cycle_dao.dart';
part 'daos/pregnancy_dao.dart';
part 'daos/baby_dao.dart';
part 'daos/food_dao.dart';

@DriftDatabase(
  tables: [
    UserProfiles,
    MenstrualLogs,
    KickSessions,
    ContractionLogs,
    FoodDirectory,
    BabyCareLogs,
  ],
  daos: [
    UserProfileDao,
    CycleDao,
    PregnancyDao,
    BabyDao,
    FoodDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
          await into(userProfiles).insert(
            UserProfilesCompanion.insert(currentMode: ''),
          );
          // Seed food directory
          try {
            final jsonStr = await rootBundle.loadString('assets/data/foods_init.json');
            final List<dynamic> foods = jsonDecode(jsonStr) as List<dynamic>;
            await foodDao.seed(foods.cast<Map<String, dynamic>>());
          } catch (_) {
            // ignore seeding errors
          }
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'rafiqah.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}