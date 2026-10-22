// lib/core/database/tables/user_profiles.dart
import 'package:drift/drift.dart';

class UserProfiles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get currentMode => text()();
  DateTimeColumn get lmpDate => dateTime().nullable()();
  DateTimeColumn get eddDate => dateTime().nullable()();
  RealColumn get prePregnancyWeight => real().nullable()();
  RealColumn get height => real().nullable()();
  BoolColumn get isBiometricEnabled =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get disclaimerAccepted =>
      boolean().withDefault(const Constant(false))();
}