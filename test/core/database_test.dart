// test/core/database_test.dart
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rafiqah/core/database/app_database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  test('creates schema and a default profile', () async {
    final profile = await db.userProfileDao.getProfile();
    expect(profile, isNotNull);
    expect(profile!.cycleLength, 28);
    expect(profile.onboardingCompleted, isFalse);
  });

  test('upsertDay updates the same day instead of duplicating', () async {
    final day = DateTime(2027, 1, 1);
    await db.cycleDao.upsertDay(day, flowIntensity: 2);
    await db.cycleDao.upsertDay(day, bbtTemperature: 36.6);

    final logs = await db.cycleDao.getAllLogs();
    expect(logs, hasLength(1));
    expect(logs.single.flowIntensity, 2);
    expect(logs.single.bbtTemperature, 36.6);
  });

  test('a BBT-only day is not counted as a period day', () async {
    await db.cycleDao.upsertDay(
      DateTime(2027, 1, 2),
      bbtTemperature: 36.5,
    );

    final logs = await db.cycleDao.getAllLogs();
    expect(logs.single.flowIntensity, 0);
    expect(await db.cycleDao.getBbtLogs(), hasLength(1));
  });

  test('stores EPDS results and retrieves the latest', () async {
    await db.postpartumDao.insertResult(
      EpdsResultsCompanion.insert(
        takenAt: DateTime(2027, 1, 1),
        score: 7,
        answers: '[0,1,0,1,0,1,0,1,0,3]',
      ),
    );
    await db.postpartumDao.insertResult(
      EpdsResultsCompanion.insert(
        takenAt: DateTime(2027, 2, 1),
        score: 14,
        answers: '[1,1,2,2,1,1,2,2,1,1]',
      ),
    );

    final latest = await db.postpartumDao.getLatest();
    expect(latest, isNotNull);
    expect(latest!.score, 14);
  });

  test('stores baby measurements with age in months', () async {
    await db.babyDao.insertMeasurement(
      BabyMeasurementsCompanion.insert(
        measuredAt: DateTime(2027, 1, 1),
        ageMonths: const Value(3),
        weightKg: const Value(6.5),
        heightCm: const Value(61.0),
      ),
    );

    final measurements = await db.babyDao.getMeasurements();
    expect(measurements, hasLength(1));
    expect(measurements.single.ageMonths, 3);
    expect(measurements.single.weightKg, 6.5);
  });

  test('deletes all user data but keeps the food directory', () async {
    await db.foodDao.seed([
      {
        'nameArabic': 'تفاح',
        'category': 'فواكه',
        'safetyLevel': 1,
        'reasonMedical': 'آمن',
        'pregnancyAdvice': 'اغسليه جيدًا',
        'postpartumAdvice': 'مناسب',
      },
    ]);
    await db.cycleDao.upsertDay(
      DateTime(2027, 1, 1),
      flowIntensity: 2,
    );

    await db.userProfileDao.deleteAll();
    await db.cycleDao.deleteAll();
    await db.pregnancyDao.deleteAll();
    await db.babyDao.deleteAll();
    await db.postpartumDao.deleteAll();

    expect(await db.userProfileDao.getProfile(), isNull);
    expect(await db.cycleDao.getAllLogs(), isEmpty);
    expect(await db.foodDao.count(), 1);
  });
}
