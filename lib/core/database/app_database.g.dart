// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UserProfilesTable extends UserProfiles
    with TableInfo<$UserProfilesTable, UserProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _currentModeMeta =
      const VerificationMeta('currentMode');
  @override
  late final GeneratedColumn<String> currentMode = GeneratedColumn<String>(
      'current_mode', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lmpDateMeta =
      const VerificationMeta('lmpDate');
  @override
  late final GeneratedColumn<DateTime> lmpDate = GeneratedColumn<DateTime>(
      'lmp_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _eddDateMeta =
      const VerificationMeta('eddDate');
  @override
  late final GeneratedColumn<DateTime> eddDate = GeneratedColumn<DateTime>(
      'edd_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _prePregnancyWeightMeta =
      const VerificationMeta('prePregnancyWeight');
  @override
  late final GeneratedColumn<double> prePregnancyWeight =
      GeneratedColumn<double>('pre_pregnancy_weight', aliasedName, true,
          type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _heightMeta = const VerificationMeta('height');
  @override
  late final GeneratedColumn<double> height = GeneratedColumn<double>(
      'height', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _isBiometricEnabledMeta =
      const VerificationMeta('isBiometricEnabled');
  @override
  late final GeneratedColumn<bool> isBiometricEnabled = GeneratedColumn<bool>(
      'is_biometric_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_biometric_enabled" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _disclaimerAcceptedMeta =
      const VerificationMeta('disclaimerAccepted');
  @override
  late final GeneratedColumn<bool> disclaimerAccepted = GeneratedColumn<bool>(
      'disclaimer_accepted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("disclaimer_accepted" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        currentMode,
        lmpDate,
        eddDate,
        prePregnancyWeight,
        height,
        isBiometricEnabled,
        disclaimerAccepted
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_profiles';
  @override
  VerificationContext validateIntegrity(Insertable<UserProfile> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('current_mode')) {
      context.handle(
          _currentModeMeta,
          currentMode.isAcceptableOrUnknown(
              data['current_mode']!, _currentModeMeta));
    } else if (isInserting) {
      context.missing(_currentModeMeta);
    }
    if (data.containsKey('lmp_date')) {
      context.handle(_lmpDateMeta,
          lmpDate.isAcceptableOrUnknown(data['lmp_date']!, _lmpDateMeta));
    }
    if (data.containsKey('edd_date')) {
      context.handle(_eddDateMeta,
          eddDate.isAcceptableOrUnknown(data['edd_date']!, _eddDateMeta));
    }
    if (data.containsKey('pre_pregnancy_weight')) {
      context.handle(
          _prePregnancyWeightMeta,
          prePregnancyWeight.isAcceptableOrUnknown(
              data['pre_pregnancy_weight']!, _prePregnancyWeightMeta));
    }
    if (data.containsKey('height')) {
      context.handle(_heightMeta,
          height.isAcceptableOrUnknown(data['height']!, _heightMeta));
    }
    if (data.containsKey('is_biometric_enabled')) {
      context.handle(
          _isBiometricEnabledMeta,
          isBiometricEnabled.isAcceptableOrUnknown(
              data['is_biometric_enabled']!, _isBiometricEnabledMeta));
    }
    if (data.containsKey('disclaimer_accepted')) {
      context.handle(
          _disclaimerAcceptedMeta,
          disclaimerAccepted.isAcceptableOrUnknown(
              data['disclaimer_accepted']!, _disclaimerAcceptedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserProfile(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      currentMode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}current_mode'])!,
      lmpDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}lmp_date']),
      eddDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}edd_date']),
      prePregnancyWeight: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}pre_pregnancy_weight']),
      height: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}height']),
      isBiometricEnabled: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}is_biometric_enabled'])!,
      disclaimerAccepted: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}disclaimer_accepted'])!,
    );
  }

  @override
  $UserProfilesTable createAlias(String alias) {
    return $UserProfilesTable(attachedDatabase, alias);
  }
}

class UserProfile extends DataClass implements Insertable<UserProfile> {
  final int id;
  final String currentMode;
  final DateTime? lmpDate;
  final DateTime? eddDate;
  final double? prePregnancyWeight;
  final double? height;
  final bool isBiometricEnabled;
  final bool disclaimerAccepted;
  const UserProfile(
      {required this.id,
      required this.currentMode,
      this.lmpDate,
      this.eddDate,
      this.prePregnancyWeight,
      this.height,
      required this.isBiometricEnabled,
      required this.disclaimerAccepted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['current_mode'] = Variable<String>(currentMode);
    if (!nullToAbsent || lmpDate != null) {
      map['lmp_date'] = Variable<DateTime>(lmpDate);
    }
    if (!nullToAbsent || eddDate != null) {
      map['edd_date'] = Variable<DateTime>(eddDate);
    }
    if (!nullToAbsent || prePregnancyWeight != null) {
      map['pre_pregnancy_weight'] = Variable<double>(prePregnancyWeight);
    }
    if (!nullToAbsent || height != null) {
      map['height'] = Variable<double>(height);
    }
    map['is_biometric_enabled'] = Variable<bool>(isBiometricEnabled);
    map['disclaimer_accepted'] = Variable<bool>(disclaimerAccepted);
    return map;
  }

  UserProfilesCompanion toCompanion(bool nullToAbsent) {
    return UserProfilesCompanion(
      id: Value(id),
      currentMode: Value(currentMode),
      lmpDate: lmpDate == null && nullToAbsent
          ? const Value.absent()
          : Value(lmpDate),
      eddDate: eddDate == null && nullToAbsent
          ? const Value.absent()
          : Value(eddDate),
      prePregnancyWeight: prePregnancyWeight == null && nullToAbsent
          ? const Value.absent()
          : Value(prePregnancyWeight),
      height:
          height == null && nullToAbsent ? const Value.absent() : Value(height),
      isBiometricEnabled: Value(isBiometricEnabled),
      disclaimerAccepted: Value(disclaimerAccepted),
    );
  }

  factory UserProfile.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserProfile(
      id: serializer.fromJson<int>(json['id']),
      currentMode: serializer.fromJson<String>(json['currentMode']),
      lmpDate: serializer.fromJson<DateTime?>(json['lmpDate']),
      eddDate: serializer.fromJson<DateTime?>(json['eddDate']),
      prePregnancyWeight:
          serializer.fromJson<double?>(json['prePregnancyWeight']),
      height: serializer.fromJson<double?>(json['height']),
      isBiometricEnabled: serializer.fromJson<bool>(json['isBiometricEnabled']),
      disclaimerAccepted: serializer.fromJson<bool>(json['disclaimerAccepted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'currentMode': serializer.toJson<String>(currentMode),
      'lmpDate': serializer.toJson<DateTime?>(lmpDate),
      'eddDate': serializer.toJson<DateTime?>(eddDate),
      'prePregnancyWeight': serializer.toJson<double?>(prePregnancyWeight),
      'height': serializer.toJson<double?>(height),
      'isBiometricEnabled': serializer.toJson<bool>(isBiometricEnabled),
      'disclaimerAccepted': serializer.toJson<bool>(disclaimerAccepted),
    };
  }

  UserProfile copyWith(
          {int? id,
          String? currentMode,
          Value<DateTime?> lmpDate = const Value.absent(),
          Value<DateTime?> eddDate = const Value.absent(),
          Value<double?> prePregnancyWeight = const Value.absent(),
          Value<double?> height = const Value.absent(),
          bool? isBiometricEnabled,
          bool? disclaimerAccepted}) =>
      UserProfile(
        id: id ?? this.id,
        currentMode: currentMode ?? this.currentMode,
        lmpDate: lmpDate.present ? lmpDate.value : this.lmpDate,
        eddDate: eddDate.present ? eddDate.value : this.eddDate,
        prePregnancyWeight: prePregnancyWeight.present
            ? prePregnancyWeight.value
            : this.prePregnancyWeight,
        height: height.present ? height.value : this.height,
        isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
        disclaimerAccepted: disclaimerAccepted ?? this.disclaimerAccepted,
      );
  UserProfile copyWithCompanion(UserProfilesCompanion data) {
    return UserProfile(
      id: data.id.present ? data.id.value : this.id,
      currentMode:
          data.currentMode.present ? data.currentMode.value : this.currentMode,
      lmpDate: data.lmpDate.present ? data.lmpDate.value : this.lmpDate,
      eddDate: data.eddDate.present ? data.eddDate.value : this.eddDate,
      prePregnancyWeight: data.prePregnancyWeight.present
          ? data.prePregnancyWeight.value
          : this.prePregnancyWeight,
      height: data.height.present ? data.height.value : this.height,
      isBiometricEnabled: data.isBiometricEnabled.present
          ? data.isBiometricEnabled.value
          : this.isBiometricEnabled,
      disclaimerAccepted: data.disclaimerAccepted.present
          ? data.disclaimerAccepted.value
          : this.disclaimerAccepted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserProfile(')
          ..write('id: $id, ')
          ..write('currentMode: $currentMode, ')
          ..write('lmpDate: $lmpDate, ')
          ..write('eddDate: $eddDate, ')
          ..write('prePregnancyWeight: $prePregnancyWeight, ')
          ..write('height: $height, ')
          ..write('isBiometricEnabled: $isBiometricEnabled, ')
          ..write('disclaimerAccepted: $disclaimerAccepted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, currentMode, lmpDate, eddDate,
      prePregnancyWeight, height, isBiometricEnabled, disclaimerAccepted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProfile &&
          other.id == this.id &&
          other.currentMode == this.currentMode &&
          other.lmpDate == this.lmpDate &&
          other.eddDate == this.eddDate &&
          other.prePregnancyWeight == this.prePregnancyWeight &&
          other.height == this.height &&
          other.isBiometricEnabled == this.isBiometricEnabled &&
          other.disclaimerAccepted == this.disclaimerAccepted);
}

class UserProfilesCompanion extends UpdateCompanion<UserProfile> {
  final Value<int> id;
  final Value<String> currentMode;
  final Value<DateTime?> lmpDate;
  final Value<DateTime?> eddDate;
  final Value<double?> prePregnancyWeight;
  final Value<double?> height;
  final Value<bool> isBiometricEnabled;
  final Value<bool> disclaimerAccepted;
  const UserProfilesCompanion({
    this.id = const Value.absent(),
    this.currentMode = const Value.absent(),
    this.lmpDate = const Value.absent(),
    this.eddDate = const Value.absent(),
    this.prePregnancyWeight = const Value.absent(),
    this.height = const Value.absent(),
    this.isBiometricEnabled = const Value.absent(),
    this.disclaimerAccepted = const Value.absent(),
  });
  UserProfilesCompanion.insert({
    this.id = const Value.absent(),
    required String currentMode,
    this.lmpDate = const Value.absent(),
    this.eddDate = const Value.absent(),
    this.prePregnancyWeight = const Value.absent(),
    this.height = const Value.absent(),
    this.isBiometricEnabled = const Value.absent(),
    this.disclaimerAccepted = const Value.absent(),
  }) : currentMode = Value(currentMode);
  static Insertable<UserProfile> custom({
    Expression<int>? id,
    Expression<String>? currentMode,
    Expression<DateTime>? lmpDate,
    Expression<DateTime>? eddDate,
    Expression<double>? prePregnancyWeight,
    Expression<double>? height,
    Expression<bool>? isBiometricEnabled,
    Expression<bool>? disclaimerAccepted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (currentMode != null) 'current_mode': currentMode,
      if (lmpDate != null) 'lmp_date': lmpDate,
      if (eddDate != null) 'edd_date': eddDate,
      if (prePregnancyWeight != null)
        'pre_pregnancy_weight': prePregnancyWeight,
      if (height != null) 'height': height,
      if (isBiometricEnabled != null)
        'is_biometric_enabled': isBiometricEnabled,
      if (disclaimerAccepted != null) 'disclaimer_accepted': disclaimerAccepted,
    });
  }

  UserProfilesCompanion copyWith(
      {Value<int>? id,
      Value<String>? currentMode,
      Value<DateTime?>? lmpDate,
      Value<DateTime?>? eddDate,
      Value<double?>? prePregnancyWeight,
      Value<double?>? height,
      Value<bool>? isBiometricEnabled,
      Value<bool>? disclaimerAccepted}) {
    return UserProfilesCompanion(
      id: id ?? this.id,
      currentMode: currentMode ?? this.currentMode,
      lmpDate: lmpDate ?? this.lmpDate,
      eddDate: eddDate ?? this.eddDate,
      prePregnancyWeight: prePregnancyWeight ?? this.prePregnancyWeight,
      height: height ?? this.height,
      isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
      disclaimerAccepted: disclaimerAccepted ?? this.disclaimerAccepted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (currentMode.present) {
      map['current_mode'] = Variable<String>(currentMode.value);
    }
    if (lmpDate.present) {
      map['lmp_date'] = Variable<DateTime>(lmpDate.value);
    }
    if (eddDate.present) {
      map['edd_date'] = Variable<DateTime>(eddDate.value);
    }
    if (prePregnancyWeight.present) {
      map['pre_pregnancy_weight'] = Variable<double>(prePregnancyWeight.value);
    }
    if (height.present) {
      map['height'] = Variable<double>(height.value);
    }
    if (isBiometricEnabled.present) {
      map['is_biometric_enabled'] = Variable<bool>(isBiometricEnabled.value);
    }
    if (disclaimerAccepted.present) {
      map['disclaimer_accepted'] = Variable<bool>(disclaimerAccepted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProfilesCompanion(')
          ..write('id: $id, ')
          ..write('currentMode: $currentMode, ')
          ..write('lmpDate: $lmpDate, ')
          ..write('eddDate: $eddDate, ')
          ..write('prePregnancyWeight: $prePregnancyWeight, ')
          ..write('height: $height, ')
          ..write('isBiometricEnabled: $isBiometricEnabled, ')
          ..write('disclaimerAccepted: $disclaimerAccepted')
          ..write(')'))
        .toString();
  }
}

class $MenstrualLogsTable extends MenstrualLogs
    with TableInfo<$MenstrualLogsTable, MenstrualLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MenstrualLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _flowIntensityMeta =
      const VerificationMeta('flowIntensity');
  @override
  late final GeneratedColumn<int> flowIntensity = GeneratedColumn<int>(
      'flow_intensity', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _painLevelMeta =
      const VerificationMeta('painLevel');
  @override
  late final GeneratedColumn<int> painLevel = GeneratedColumn<int>(
      'pain_level', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _bbtTemperatureMeta =
      const VerificationMeta('bbtTemperature');
  @override
  late final GeneratedColumn<double> bbtTemperature = GeneratedColumn<double>(
      'bbt_temperature', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _symptomsMeta =
      const VerificationMeta('symptoms');
  @override
  late final GeneratedColumn<String> symptoms = GeneratedColumn<String>(
      'symptoms', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, date, flowIntensity, painLevel, bbtTemperature, symptoms];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'menstrual_logs';
  @override
  VerificationContext validateIntegrity(Insertable<MenstrualLog> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('flow_intensity')) {
      context.handle(
          _flowIntensityMeta,
          flowIntensity.isAcceptableOrUnknown(
              data['flow_intensity']!, _flowIntensityMeta));
    } else if (isInserting) {
      context.missing(_flowIntensityMeta);
    }
    if (data.containsKey('pain_level')) {
      context.handle(_painLevelMeta,
          painLevel.isAcceptableOrUnknown(data['pain_level']!, _painLevelMeta));
    }
    if (data.containsKey('bbt_temperature')) {
      context.handle(
          _bbtTemperatureMeta,
          bbtTemperature.isAcceptableOrUnknown(
              data['bbt_temperature']!, _bbtTemperatureMeta));
    }
    if (data.containsKey('symptoms')) {
      context.handle(_symptomsMeta,
          symptoms.isAcceptableOrUnknown(data['symptoms']!, _symptomsMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MenstrualLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MenstrualLog(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      flowIntensity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}flow_intensity'])!,
      painLevel: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}pain_level'])!,
      bbtTemperature: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}bbt_temperature']),
      symptoms: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}symptoms']),
    );
  }

  @override
  $MenstrualLogsTable createAlias(String alias) {
    return $MenstrualLogsTable(attachedDatabase, alias);
  }
}

class MenstrualLog extends DataClass implements Insertable<MenstrualLog> {
  final int id;
  final DateTime date;
  final int flowIntensity;
  final int painLevel;
  final double? bbtTemperature;
  final String? symptoms;
  const MenstrualLog(
      {required this.id,
      required this.date,
      required this.flowIntensity,
      required this.painLevel,
      this.bbtTemperature,
      this.symptoms});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['flow_intensity'] = Variable<int>(flowIntensity);
    map['pain_level'] = Variable<int>(painLevel);
    if (!nullToAbsent || bbtTemperature != null) {
      map['bbt_temperature'] = Variable<double>(bbtTemperature);
    }
    if (!nullToAbsent || symptoms != null) {
      map['symptoms'] = Variable<String>(symptoms);
    }
    return map;
  }

  MenstrualLogsCompanion toCompanion(bool nullToAbsent) {
    return MenstrualLogsCompanion(
      id: Value(id),
      date: Value(date),
      flowIntensity: Value(flowIntensity),
      painLevel: Value(painLevel),
      bbtTemperature: bbtTemperature == null && nullToAbsent
          ? const Value.absent()
          : Value(bbtTemperature),
      symptoms: symptoms == null && nullToAbsent
          ? const Value.absent()
          : Value(symptoms),
    );
  }

  factory MenstrualLog.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MenstrualLog(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      flowIntensity: serializer.fromJson<int>(json['flowIntensity']),
      painLevel: serializer.fromJson<int>(json['painLevel']),
      bbtTemperature: serializer.fromJson<double?>(json['bbtTemperature']),
      symptoms: serializer.fromJson<String?>(json['symptoms']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'flowIntensity': serializer.toJson<int>(flowIntensity),
      'painLevel': serializer.toJson<int>(painLevel),
      'bbtTemperature': serializer.toJson<double?>(bbtTemperature),
      'symptoms': serializer.toJson<String?>(symptoms),
    };
  }

  MenstrualLog copyWith(
          {int? id,
          DateTime? date,
          int? flowIntensity,
          int? painLevel,
          Value<double?> bbtTemperature = const Value.absent(),
          Value<String?> symptoms = const Value.absent()}) =>
      MenstrualLog(
        id: id ?? this.id,
        date: date ?? this.date,
        flowIntensity: flowIntensity ?? this.flowIntensity,
        painLevel: painLevel ?? this.painLevel,
        bbtTemperature:
            bbtTemperature.present ? bbtTemperature.value : this.bbtTemperature,
        symptoms: symptoms.present ? symptoms.value : this.symptoms,
      );
  MenstrualLog copyWithCompanion(MenstrualLogsCompanion data) {
    return MenstrualLog(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      flowIntensity: data.flowIntensity.present
          ? data.flowIntensity.value
          : this.flowIntensity,
      painLevel: data.painLevel.present ? data.painLevel.value : this.painLevel,
      bbtTemperature: data.bbtTemperature.present
          ? data.bbtTemperature.value
          : this.bbtTemperature,
      symptoms: data.symptoms.present ? data.symptoms.value : this.symptoms,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MenstrualLog(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('flowIntensity: $flowIntensity, ')
          ..write('painLevel: $painLevel, ')
          ..write('bbtTemperature: $bbtTemperature, ')
          ..write('symptoms: $symptoms')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, date, flowIntensity, painLevel, bbtTemperature, symptoms);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MenstrualLog &&
          other.id == this.id &&
          other.date == this.date &&
          other.flowIntensity == this.flowIntensity &&
          other.painLevel == this.painLevel &&
          other.bbtTemperature == this.bbtTemperature &&
          other.symptoms == this.symptoms);
}

class MenstrualLogsCompanion extends UpdateCompanion<MenstrualLog> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<int> flowIntensity;
  final Value<int> painLevel;
  final Value<double?> bbtTemperature;
  final Value<String?> symptoms;
  const MenstrualLogsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.flowIntensity = const Value.absent(),
    this.painLevel = const Value.absent(),
    this.bbtTemperature = const Value.absent(),
    this.symptoms = const Value.absent(),
  });
  MenstrualLogsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    required int flowIntensity,
    this.painLevel = const Value.absent(),
    this.bbtTemperature = const Value.absent(),
    this.symptoms = const Value.absent(),
  })  : date = Value(date),
        flowIntensity = Value(flowIntensity);
  static Insertable<MenstrualLog> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<int>? flowIntensity,
    Expression<int>? painLevel,
    Expression<double>? bbtTemperature,
    Expression<String>? symptoms,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (flowIntensity != null) 'flow_intensity': flowIntensity,
      if (painLevel != null) 'pain_level': painLevel,
      if (bbtTemperature != null) 'bbt_temperature': bbtTemperature,
      if (symptoms != null) 'symptoms': symptoms,
    });
  }

  MenstrualLogsCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? date,
      Value<int>? flowIntensity,
      Value<int>? painLevel,
      Value<double?>? bbtTemperature,
      Value<String?>? symptoms}) {
    return MenstrualLogsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      flowIntensity: flowIntensity ?? this.flowIntensity,
      painLevel: painLevel ?? this.painLevel,
      bbtTemperature: bbtTemperature ?? this.bbtTemperature,
      symptoms: symptoms ?? this.symptoms,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (flowIntensity.present) {
      map['flow_intensity'] = Variable<int>(flowIntensity.value);
    }
    if (painLevel.present) {
      map['pain_level'] = Variable<int>(painLevel.value);
    }
    if (bbtTemperature.present) {
      map['bbt_temperature'] = Variable<double>(bbtTemperature.value);
    }
    if (symptoms.present) {
      map['symptoms'] = Variable<String>(symptoms.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MenstrualLogsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('flowIntensity: $flowIntensity, ')
          ..write('painLevel: $painLevel, ')
          ..write('bbtTemperature: $bbtTemperature, ')
          ..write('symptoms: $symptoms')
          ..write(')'))
        .toString();
  }
}

class $KickSessionsTable extends KickSessions
    with TableInfo<$KickSessionsTable, KickSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KickSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _startTimeMeta =
      const VerificationMeta('startTime');
  @override
  late final GeneratedColumn<DateTime> startTime = GeneratedColumn<DateTime>(
      'start_time', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _endTimeMeta =
      const VerificationMeta('endTime');
  @override
  late final GeneratedColumn<DateTime> endTime = GeneratedColumn<DateTime>(
      'end_time', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _kickCountMeta =
      const VerificationMeta('kickCount');
  @override
  late final GeneratedColumn<int> kickCount = GeneratedColumn<int>(
      'kick_count', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _durationSecondsMeta =
      const VerificationMeta('durationSeconds');
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
      'duration_seconds', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, startTime, endTime, kickCount, durationSeconds];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'kick_sessions';
  @override
  VerificationContext validateIntegrity(Insertable<KickSession> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('start_time')) {
      context.handle(_startTimeMeta,
          startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta));
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('end_time')) {
      context.handle(_endTimeMeta,
          endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta));
    }
    if (data.containsKey('kick_count')) {
      context.handle(_kickCountMeta,
          kickCount.isAcceptableOrUnknown(data['kick_count']!, _kickCountMeta));
    } else if (isInserting) {
      context.missing(_kickCountMeta);
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
          _durationSecondsMeta,
          durationSeconds.isAcceptableOrUnknown(
              data['duration_seconds']!, _durationSecondsMeta));
    } else if (isInserting) {
      context.missing(_durationSecondsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  KickSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KickSession(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      startTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_time'])!,
      endTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}end_time']),
      kickCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}kick_count'])!,
      durationSeconds: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duration_seconds'])!,
    );
  }

  @override
  $KickSessionsTable createAlias(String alias) {
    return $KickSessionsTable(attachedDatabase, alias);
  }
}

class KickSession extends DataClass implements Insertable<KickSession> {
  final int id;
  final DateTime startTime;
  final DateTime? endTime;
  final int kickCount;
  final int durationSeconds;
  const KickSession(
      {required this.id,
      required this.startTime,
      this.endTime,
      required this.kickCount,
      required this.durationSeconds});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['start_time'] = Variable<DateTime>(startTime);
    if (!nullToAbsent || endTime != null) {
      map['end_time'] = Variable<DateTime>(endTime);
    }
    map['kick_count'] = Variable<int>(kickCount);
    map['duration_seconds'] = Variable<int>(durationSeconds);
    return map;
  }

  KickSessionsCompanion toCompanion(bool nullToAbsent) {
    return KickSessionsCompanion(
      id: Value(id),
      startTime: Value(startTime),
      endTime: endTime == null && nullToAbsent
          ? const Value.absent()
          : Value(endTime),
      kickCount: Value(kickCount),
      durationSeconds: Value(durationSeconds),
    );
  }

  factory KickSession.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KickSession(
      id: serializer.fromJson<int>(json['id']),
      startTime: serializer.fromJson<DateTime>(json['startTime']),
      endTime: serializer.fromJson<DateTime?>(json['endTime']),
      kickCount: serializer.fromJson<int>(json['kickCount']),
      durationSeconds: serializer.fromJson<int>(json['durationSeconds']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'startTime': serializer.toJson<DateTime>(startTime),
      'endTime': serializer.toJson<DateTime?>(endTime),
      'kickCount': serializer.toJson<int>(kickCount),
      'durationSeconds': serializer.toJson<int>(durationSeconds),
    };
  }

  KickSession copyWith(
          {int? id,
          DateTime? startTime,
          Value<DateTime?> endTime = const Value.absent(),
          int? kickCount,
          int? durationSeconds}) =>
      KickSession(
        id: id ?? this.id,
        startTime: startTime ?? this.startTime,
        endTime: endTime.present ? endTime.value : this.endTime,
        kickCount: kickCount ?? this.kickCount,
        durationSeconds: durationSeconds ?? this.durationSeconds,
      );
  KickSession copyWithCompanion(KickSessionsCompanion data) {
    return KickSession(
      id: data.id.present ? data.id.value : this.id,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      kickCount: data.kickCount.present ? data.kickCount.value : this.kickCount,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KickSession(')
          ..write('id: $id, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('kickCount: $kickCount, ')
          ..write('durationSeconds: $durationSeconds')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, startTime, endTime, kickCount, durationSeconds);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KickSession &&
          other.id == this.id &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.kickCount == this.kickCount &&
          other.durationSeconds == this.durationSeconds);
}

class KickSessionsCompanion extends UpdateCompanion<KickSession> {
  final Value<int> id;
  final Value<DateTime> startTime;
  final Value<DateTime?> endTime;
  final Value<int> kickCount;
  final Value<int> durationSeconds;
  const KickSessionsCompanion({
    this.id = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.kickCount = const Value.absent(),
    this.durationSeconds = const Value.absent(),
  });
  KickSessionsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime startTime,
    this.endTime = const Value.absent(),
    required int kickCount,
    required int durationSeconds,
  })  : startTime = Value(startTime),
        kickCount = Value(kickCount),
        durationSeconds = Value(durationSeconds);
  static Insertable<KickSession> custom({
    Expression<int>? id,
    Expression<DateTime>? startTime,
    Expression<DateTime>? endTime,
    Expression<int>? kickCount,
    Expression<int>? durationSeconds,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (kickCount != null) 'kick_count': kickCount,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
    });
  }

  KickSessionsCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? startTime,
      Value<DateTime?>? endTime,
      Value<int>? kickCount,
      Value<int>? durationSeconds}) {
    return KickSessionsCompanion(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      kickCount: kickCount ?? this.kickCount,
      durationSeconds: durationSeconds ?? this.durationSeconds,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<DateTime>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<DateTime>(endTime.value);
    }
    if (kickCount.present) {
      map['kick_count'] = Variable<int>(kickCount.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KickSessionsCompanion(')
          ..write('id: $id, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('kickCount: $kickCount, ')
          ..write('durationSeconds: $durationSeconds')
          ..write(')'))
        .toString();
  }
}

class $ContractionLogsTable extends ContractionLogs
    with TableInfo<$ContractionLogsTable, ContractionLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContractionLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _startTimeMeta =
      const VerificationMeta('startTime');
  @override
  late final GeneratedColumn<DateTime> startTime = GeneratedColumn<DateTime>(
      'start_time', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _endTimeMeta =
      const VerificationMeta('endTime');
  @override
  late final GeneratedColumn<DateTime> endTime = GeneratedColumn<DateTime>(
      'end_time', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _durationSecondsMeta =
      const VerificationMeta('durationSeconds');
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
      'duration_seconds', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _intervalSecondsMeta =
      const VerificationMeta('intervalSeconds');
  @override
  late final GeneratedColumn<int> intervalSeconds = GeneratedColumn<int>(
      'interval_seconds', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _intensityMeta =
      const VerificationMeta('intensity');
  @override
  late final GeneratedColumn<int> intensity = GeneratedColumn<int>(
      'intensity', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, startTime, endTime, durationSeconds, intervalSeconds, intensity];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'contraction_logs';
  @override
  VerificationContext validateIntegrity(Insertable<ContractionLog> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('start_time')) {
      context.handle(_startTimeMeta,
          startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta));
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('end_time')) {
      context.handle(_endTimeMeta,
          endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta));
    } else if (isInserting) {
      context.missing(_endTimeMeta);
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
          _durationSecondsMeta,
          durationSeconds.isAcceptableOrUnknown(
              data['duration_seconds']!, _durationSecondsMeta));
    } else if (isInserting) {
      context.missing(_durationSecondsMeta);
    }
    if (data.containsKey('interval_seconds')) {
      context.handle(
          _intervalSecondsMeta,
          intervalSeconds.isAcceptableOrUnknown(
              data['interval_seconds']!, _intervalSecondsMeta));
    } else if (isInserting) {
      context.missing(_intervalSecondsMeta);
    }
    if (data.containsKey('intensity')) {
      context.handle(_intensityMeta,
          intensity.isAcceptableOrUnknown(data['intensity']!, _intensityMeta));
    } else if (isInserting) {
      context.missing(_intensityMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ContractionLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ContractionLog(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      startTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_time'])!,
      endTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}end_time'])!,
      durationSeconds: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duration_seconds'])!,
      intervalSeconds: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}interval_seconds'])!,
      intensity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}intensity'])!,
    );
  }

  @override
  $ContractionLogsTable createAlias(String alias) {
    return $ContractionLogsTable(attachedDatabase, alias);
  }
}

class ContractionLog extends DataClass implements Insertable<ContractionLog> {
  final int id;
  final DateTime startTime;
  final DateTime endTime;
  final int durationSeconds;
  final int intervalSeconds;
  final int intensity;
  const ContractionLog(
      {required this.id,
      required this.startTime,
      required this.endTime,
      required this.durationSeconds,
      required this.intervalSeconds,
      required this.intensity});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['start_time'] = Variable<DateTime>(startTime);
    map['end_time'] = Variable<DateTime>(endTime);
    map['duration_seconds'] = Variable<int>(durationSeconds);
    map['interval_seconds'] = Variable<int>(intervalSeconds);
    map['intensity'] = Variable<int>(intensity);
    return map;
  }

  ContractionLogsCompanion toCompanion(bool nullToAbsent) {
    return ContractionLogsCompanion(
      id: Value(id),
      startTime: Value(startTime),
      endTime: Value(endTime),
      durationSeconds: Value(durationSeconds),
      intervalSeconds: Value(intervalSeconds),
      intensity: Value(intensity),
    );
  }

  factory ContractionLog.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ContractionLog(
      id: serializer.fromJson<int>(json['id']),
      startTime: serializer.fromJson<DateTime>(json['startTime']),
      endTime: serializer.fromJson<DateTime>(json['endTime']),
      durationSeconds: serializer.fromJson<int>(json['durationSeconds']),
      intervalSeconds: serializer.fromJson<int>(json['intervalSeconds']),
      intensity: serializer.fromJson<int>(json['intensity']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'startTime': serializer.toJson<DateTime>(startTime),
      'endTime': serializer.toJson<DateTime>(endTime),
      'durationSeconds': serializer.toJson<int>(durationSeconds),
      'intervalSeconds': serializer.toJson<int>(intervalSeconds),
      'intensity': serializer.toJson<int>(intensity),
    };
  }

  ContractionLog copyWith(
          {int? id,
          DateTime? startTime,
          DateTime? endTime,
          int? durationSeconds,
          int? intervalSeconds,
          int? intensity}) =>
      ContractionLog(
        id: id ?? this.id,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        durationSeconds: durationSeconds ?? this.durationSeconds,
        intervalSeconds: intervalSeconds ?? this.intervalSeconds,
        intensity: intensity ?? this.intensity,
      );
  ContractionLog copyWithCompanion(ContractionLogsCompanion data) {
    return ContractionLog(
      id: data.id.present ? data.id.value : this.id,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
      intervalSeconds: data.intervalSeconds.present
          ? data.intervalSeconds.value
          : this.intervalSeconds,
      intensity: data.intensity.present ? data.intensity.value : this.intensity,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ContractionLog(')
          ..write('id: $id, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('intervalSeconds: $intervalSeconds, ')
          ..write('intensity: $intensity')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, startTime, endTime, durationSeconds, intervalSeconds, intensity);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ContractionLog &&
          other.id == this.id &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.durationSeconds == this.durationSeconds &&
          other.intervalSeconds == this.intervalSeconds &&
          other.intensity == this.intensity);
}

class ContractionLogsCompanion extends UpdateCompanion<ContractionLog> {
  final Value<int> id;
  final Value<DateTime> startTime;
  final Value<DateTime> endTime;
  final Value<int> durationSeconds;
  final Value<int> intervalSeconds;
  final Value<int> intensity;
  const ContractionLogsCompanion({
    this.id = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.intervalSeconds = const Value.absent(),
    this.intensity = const Value.absent(),
  });
  ContractionLogsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime startTime,
    required DateTime endTime,
    required int durationSeconds,
    required int intervalSeconds,
    required int intensity,
  })  : startTime = Value(startTime),
        endTime = Value(endTime),
        durationSeconds = Value(durationSeconds),
        intervalSeconds = Value(intervalSeconds),
        intensity = Value(intensity);
  static Insertable<ContractionLog> custom({
    Expression<int>? id,
    Expression<DateTime>? startTime,
    Expression<DateTime>? endTime,
    Expression<int>? durationSeconds,
    Expression<int>? intervalSeconds,
    Expression<int>? intensity,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (intervalSeconds != null) 'interval_seconds': intervalSeconds,
      if (intensity != null) 'intensity': intensity,
    });
  }

  ContractionLogsCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? startTime,
      Value<DateTime>? endTime,
      Value<int>? durationSeconds,
      Value<int>? intervalSeconds,
      Value<int>? intensity}) {
    return ContractionLogsCompanion(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      intervalSeconds: intervalSeconds ?? this.intervalSeconds,
      intensity: intensity ?? this.intensity,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<DateTime>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<DateTime>(endTime.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    if (intervalSeconds.present) {
      map['interval_seconds'] = Variable<int>(intervalSeconds.value);
    }
    if (intensity.present) {
      map['intensity'] = Variable<int>(intensity.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContractionLogsCompanion(')
          ..write('id: $id, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('intervalSeconds: $intervalSeconds, ')
          ..write('intensity: $intensity')
          ..write(')'))
        .toString();
  }
}

class $FoodDirectoryTable extends FoodDirectory
    with TableInfo<$FoodDirectoryTable, FoodDirectoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FoodDirectoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameArabicMeta =
      const VerificationMeta('nameArabic');
  @override
  late final GeneratedColumn<String> nameArabic = GeneratedColumn<String>(
      'name_arabic', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 2, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _safetyLevelMeta =
      const VerificationMeta('safetyLevel');
  @override
  late final GeneratedColumn<int> safetyLevel = GeneratedColumn<int>(
      'safety_level', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _reasonMedicalMeta =
      const VerificationMeta('reasonMedical');
  @override
  late final GeneratedColumn<String> reasonMedical = GeneratedColumn<String>(
      'reason_medical', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _pregnancyAdviceMeta =
      const VerificationMeta('pregnancyAdvice');
  @override
  late final GeneratedColumn<String> pregnancyAdvice = GeneratedColumn<String>(
      'pregnancy_advice', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _postpartumAdviceMeta =
      const VerificationMeta('postpartumAdvice');
  @override
  late final GeneratedColumn<String> postpartumAdvice = GeneratedColumn<String>(
      'postpartum_advice', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        nameArabic,
        category,
        safetyLevel,
        reasonMedical,
        pregnancyAdvice,
        postpartumAdvice
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'food_directory';
  @override
  VerificationContext validateIntegrity(Insertable<FoodDirectoryData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name_arabic')) {
      context.handle(
          _nameArabicMeta,
          nameArabic.isAcceptableOrUnknown(
              data['name_arabic']!, _nameArabicMeta));
    } else if (isInserting) {
      context.missing(_nameArabicMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('safety_level')) {
      context.handle(
          _safetyLevelMeta,
          safetyLevel.isAcceptableOrUnknown(
              data['safety_level']!, _safetyLevelMeta));
    } else if (isInserting) {
      context.missing(_safetyLevelMeta);
    }
    if (data.containsKey('reason_medical')) {
      context.handle(
          _reasonMedicalMeta,
          reasonMedical.isAcceptableOrUnknown(
              data['reason_medical']!, _reasonMedicalMeta));
    } else if (isInserting) {
      context.missing(_reasonMedicalMeta);
    }
    if (data.containsKey('pregnancy_advice')) {
      context.handle(
          _pregnancyAdviceMeta,
          pregnancyAdvice.isAcceptableOrUnknown(
              data['pregnancy_advice']!, _pregnancyAdviceMeta));
    } else if (isInserting) {
      context.missing(_pregnancyAdviceMeta);
    }
    if (data.containsKey('postpartum_advice')) {
      context.handle(
          _postpartumAdviceMeta,
          postpartumAdvice.isAcceptableOrUnknown(
              data['postpartum_advice']!, _postpartumAdviceMeta));
    } else if (isInserting) {
      context.missing(_postpartumAdviceMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FoodDirectoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FoodDirectoryData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      nameArabic: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_arabic'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      safetyLevel: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}safety_level'])!,
      reasonMedical: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reason_medical'])!,
      pregnancyAdvice: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}pregnancy_advice'])!,
      postpartumAdvice: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}postpartum_advice'])!,
    );
  }

  @override
  $FoodDirectoryTable createAlias(String alias) {
    return $FoodDirectoryTable(attachedDatabase, alias);
  }
}

class FoodDirectoryData extends DataClass
    implements Insertable<FoodDirectoryData> {
  final int id;
  final String nameArabic;
  final String category;
  final int safetyLevel;
  final String reasonMedical;
  final String pregnancyAdvice;
  final String postpartumAdvice;
  const FoodDirectoryData(
      {required this.id,
      required this.nameArabic,
      required this.category,
      required this.safetyLevel,
      required this.reasonMedical,
      required this.pregnancyAdvice,
      required this.postpartumAdvice});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name_arabic'] = Variable<String>(nameArabic);
    map['category'] = Variable<String>(category);
    map['safety_level'] = Variable<int>(safetyLevel);
    map['reason_medical'] = Variable<String>(reasonMedical);
    map['pregnancy_advice'] = Variable<String>(pregnancyAdvice);
    map['postpartum_advice'] = Variable<String>(postpartumAdvice);
    return map;
  }

  FoodDirectoryCompanion toCompanion(bool nullToAbsent) {
    return FoodDirectoryCompanion(
      id: Value(id),
      nameArabic: Value(nameArabic),
      category: Value(category),
      safetyLevel: Value(safetyLevel),
      reasonMedical: Value(reasonMedical),
      pregnancyAdvice: Value(pregnancyAdvice),
      postpartumAdvice: Value(postpartumAdvice),
    );
  }

  factory FoodDirectoryData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FoodDirectoryData(
      id: serializer.fromJson<int>(json['id']),
      nameArabic: serializer.fromJson<String>(json['nameArabic']),
      category: serializer.fromJson<String>(json['category']),
      safetyLevel: serializer.fromJson<int>(json['safetyLevel']),
      reasonMedical: serializer.fromJson<String>(json['reasonMedical']),
      pregnancyAdvice: serializer.fromJson<String>(json['pregnancyAdvice']),
      postpartumAdvice: serializer.fromJson<String>(json['postpartumAdvice']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nameArabic': serializer.toJson<String>(nameArabic),
      'category': serializer.toJson<String>(category),
      'safetyLevel': serializer.toJson<int>(safetyLevel),
      'reasonMedical': serializer.toJson<String>(reasonMedical),
      'pregnancyAdvice': serializer.toJson<String>(pregnancyAdvice),
      'postpartumAdvice': serializer.toJson<String>(postpartumAdvice),
    };
  }

  FoodDirectoryData copyWith(
          {int? id,
          String? nameArabic,
          String? category,
          int? safetyLevel,
          String? reasonMedical,
          String? pregnancyAdvice,
          String? postpartumAdvice}) =>
      FoodDirectoryData(
        id: id ?? this.id,
        nameArabic: nameArabic ?? this.nameArabic,
        category: category ?? this.category,
        safetyLevel: safetyLevel ?? this.safetyLevel,
        reasonMedical: reasonMedical ?? this.reasonMedical,
        pregnancyAdvice: pregnancyAdvice ?? this.pregnancyAdvice,
        postpartumAdvice: postpartumAdvice ?? this.postpartumAdvice,
      );
  FoodDirectoryData copyWithCompanion(FoodDirectoryCompanion data) {
    return FoodDirectoryData(
      id: data.id.present ? data.id.value : this.id,
      nameArabic:
          data.nameArabic.present ? data.nameArabic.value : this.nameArabic,
      category: data.category.present ? data.category.value : this.category,
      safetyLevel:
          data.safetyLevel.present ? data.safetyLevel.value : this.safetyLevel,
      reasonMedical: data.reasonMedical.present
          ? data.reasonMedical.value
          : this.reasonMedical,
      pregnancyAdvice: data.pregnancyAdvice.present
          ? data.pregnancyAdvice.value
          : this.pregnancyAdvice,
      postpartumAdvice: data.postpartumAdvice.present
          ? data.postpartumAdvice.value
          : this.postpartumAdvice,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FoodDirectoryData(')
          ..write('id: $id, ')
          ..write('nameArabic: $nameArabic, ')
          ..write('category: $category, ')
          ..write('safetyLevel: $safetyLevel, ')
          ..write('reasonMedical: $reasonMedical, ')
          ..write('pregnancyAdvice: $pregnancyAdvice, ')
          ..write('postpartumAdvice: $postpartumAdvice')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nameArabic, category, safetyLevel,
      reasonMedical, pregnancyAdvice, postpartumAdvice);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FoodDirectoryData &&
          other.id == this.id &&
          other.nameArabic == this.nameArabic &&
          other.category == this.category &&
          other.safetyLevel == this.safetyLevel &&
          other.reasonMedical == this.reasonMedical &&
          other.pregnancyAdvice == this.pregnancyAdvice &&
          other.postpartumAdvice == this.postpartumAdvice);
}

class FoodDirectoryCompanion extends UpdateCompanion<FoodDirectoryData> {
  final Value<int> id;
  final Value<String> nameArabic;
  final Value<String> category;
  final Value<int> safetyLevel;
  final Value<String> reasonMedical;
  final Value<String> pregnancyAdvice;
  final Value<String> postpartumAdvice;
  const FoodDirectoryCompanion({
    this.id = const Value.absent(),
    this.nameArabic = const Value.absent(),
    this.category = const Value.absent(),
    this.safetyLevel = const Value.absent(),
    this.reasonMedical = const Value.absent(),
    this.pregnancyAdvice = const Value.absent(),
    this.postpartumAdvice = const Value.absent(),
  });
  FoodDirectoryCompanion.insert({
    this.id = const Value.absent(),
    required String nameArabic,
    required String category,
    required int safetyLevel,
    required String reasonMedical,
    required String pregnancyAdvice,
    required String postpartumAdvice,
  })  : nameArabic = Value(nameArabic),
        category = Value(category),
        safetyLevel = Value(safetyLevel),
        reasonMedical = Value(reasonMedical),
        pregnancyAdvice = Value(pregnancyAdvice),
        postpartumAdvice = Value(postpartumAdvice);
  static Insertable<FoodDirectoryData> custom({
    Expression<int>? id,
    Expression<String>? nameArabic,
    Expression<String>? category,
    Expression<int>? safetyLevel,
    Expression<String>? reasonMedical,
    Expression<String>? pregnancyAdvice,
    Expression<String>? postpartumAdvice,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nameArabic != null) 'name_arabic': nameArabic,
      if (category != null) 'category': category,
      if (safetyLevel != null) 'safety_level': safetyLevel,
      if (reasonMedical != null) 'reason_medical': reasonMedical,
      if (pregnancyAdvice != null) 'pregnancy_advice': pregnancyAdvice,
      if (postpartumAdvice != null) 'postpartum_advice': postpartumAdvice,
    });
  }

  FoodDirectoryCompanion copyWith(
      {Value<int>? id,
      Value<String>? nameArabic,
      Value<String>? category,
      Value<int>? safetyLevel,
      Value<String>? reasonMedical,
      Value<String>? pregnancyAdvice,
      Value<String>? postpartumAdvice}) {
    return FoodDirectoryCompanion(
      id: id ?? this.id,
      nameArabic: nameArabic ?? this.nameArabic,
      category: category ?? this.category,
      safetyLevel: safetyLevel ?? this.safetyLevel,
      reasonMedical: reasonMedical ?? this.reasonMedical,
      pregnancyAdvice: pregnancyAdvice ?? this.pregnancyAdvice,
      postpartumAdvice: postpartumAdvice ?? this.postpartumAdvice,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nameArabic.present) {
      map['name_arabic'] = Variable<String>(nameArabic.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (safetyLevel.present) {
      map['safety_level'] = Variable<int>(safetyLevel.value);
    }
    if (reasonMedical.present) {
      map['reason_medical'] = Variable<String>(reasonMedical.value);
    }
    if (pregnancyAdvice.present) {
      map['pregnancy_advice'] = Variable<String>(pregnancyAdvice.value);
    }
    if (postpartumAdvice.present) {
      map['postpartum_advice'] = Variable<String>(postpartumAdvice.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FoodDirectoryCompanion(')
          ..write('id: $id, ')
          ..write('nameArabic: $nameArabic, ')
          ..write('category: $category, ')
          ..write('safetyLevel: $safetyLevel, ')
          ..write('reasonMedical: $reasonMedical, ')
          ..write('pregnancyAdvice: $pregnancyAdvice, ')
          ..write('postpartumAdvice: $postpartumAdvice')
          ..write(')'))
        .toString();
  }
}

class $BabyCareLogsTable extends BabyCareLogs
    with TableInfo<$BabyCareLogsTable, BabyCareLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BabyCareLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _logTypeMeta =
      const VerificationMeta('logType');
  @override
  late final GeneratedColumn<String> logType = GeneratedColumn<String>(
      'log_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _durationMinutesMeta =
      const VerificationMeta('durationMinutes');
  @override
  late final GeneratedColumn<int> durationMinutes = GeneratedColumn<int>(
      'duration_minutes', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _amountMlMeta =
      const VerificationMeta('amountMl');
  @override
  late final GeneratedColumn<double> amountMl = GeneratedColumn<double>(
      'amount_ml', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _diaperStatusMeta =
      const VerificationMeta('diaperStatus');
  @override
  late final GeneratedColumn<String> diaperStatus = GeneratedColumn<String>(
      'diaper_status', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, timestamp, logType, durationMinutes, amountMl, diaperStatus];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'baby_care_logs';
  @override
  VerificationContext validateIntegrity(Insertable<BabyCareLog> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('log_type')) {
      context.handle(_logTypeMeta,
          logType.isAcceptableOrUnknown(data['log_type']!, _logTypeMeta));
    } else if (isInserting) {
      context.missing(_logTypeMeta);
    }
    if (data.containsKey('duration_minutes')) {
      context.handle(
          _durationMinutesMeta,
          durationMinutes.isAcceptableOrUnknown(
              data['duration_minutes']!, _durationMinutesMeta));
    }
    if (data.containsKey('amount_ml')) {
      context.handle(_amountMlMeta,
          amountMl.isAcceptableOrUnknown(data['amount_ml']!, _amountMlMeta));
    }
    if (data.containsKey('diaper_status')) {
      context.handle(
          _diaperStatusMeta,
          diaperStatus.isAcceptableOrUnknown(
              data['diaper_status']!, _diaperStatusMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BabyCareLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BabyCareLog(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}timestamp'])!,
      logType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}log_type'])!,
      durationMinutes: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duration_minutes']),
      amountMl: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount_ml']),
      diaperStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}diaper_status']),
    );
  }

  @override
  $BabyCareLogsTable createAlias(String alias) {
    return $BabyCareLogsTable(attachedDatabase, alias);
  }
}

class BabyCareLog extends DataClass implements Insertable<BabyCareLog> {
  final int id;
  final DateTime timestamp;
  final String logType;
  final int? durationMinutes;
  final double? amountMl;
  final String? diaperStatus;
  const BabyCareLog(
      {required this.id,
      required this.timestamp,
      required this.logType,
      this.durationMinutes,
      this.amountMl,
      this.diaperStatus});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['log_type'] = Variable<String>(logType);
    if (!nullToAbsent || durationMinutes != null) {
      map['duration_minutes'] = Variable<int>(durationMinutes);
    }
    if (!nullToAbsent || amountMl != null) {
      map['amount_ml'] = Variable<double>(amountMl);
    }
    if (!nullToAbsent || diaperStatus != null) {
      map['diaper_status'] = Variable<String>(diaperStatus);
    }
    return map;
  }

  BabyCareLogsCompanion toCompanion(bool nullToAbsent) {
    return BabyCareLogsCompanion(
      id: Value(id),
      timestamp: Value(timestamp),
      logType: Value(logType),
      durationMinutes: durationMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(durationMinutes),
      amountMl: amountMl == null && nullToAbsent
          ? const Value.absent()
          : Value(amountMl),
      diaperStatus: diaperStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(diaperStatus),
    );
  }

  factory BabyCareLog.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BabyCareLog(
      id: serializer.fromJson<int>(json['id']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      logType: serializer.fromJson<String>(json['logType']),
      durationMinutes: serializer.fromJson<int?>(json['durationMinutes']),
      amountMl: serializer.fromJson<double?>(json['amountMl']),
      diaperStatus: serializer.fromJson<String?>(json['diaperStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'logType': serializer.toJson<String>(logType),
      'durationMinutes': serializer.toJson<int?>(durationMinutes),
      'amountMl': serializer.toJson<double?>(amountMl),
      'diaperStatus': serializer.toJson<String?>(diaperStatus),
    };
  }

  BabyCareLog copyWith(
          {int? id,
          DateTime? timestamp,
          String? logType,
          Value<int?> durationMinutes = const Value.absent(),
          Value<double?> amountMl = const Value.absent(),
          Value<String?> diaperStatus = const Value.absent()}) =>
      BabyCareLog(
        id: id ?? this.id,
        timestamp: timestamp ?? this.timestamp,
        logType: logType ?? this.logType,
        durationMinutes: durationMinutes.present
            ? durationMinutes.value
            : this.durationMinutes,
        amountMl: amountMl.present ? amountMl.value : this.amountMl,
        diaperStatus:
            diaperStatus.present ? diaperStatus.value : this.diaperStatus,
      );
  BabyCareLog copyWithCompanion(BabyCareLogsCompanion data) {
    return BabyCareLog(
      id: data.id.present ? data.id.value : this.id,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      logType: data.logType.present ? data.logType.value : this.logType,
      durationMinutes: data.durationMinutes.present
          ? data.durationMinutes.value
          : this.durationMinutes,
      amountMl: data.amountMl.present ? data.amountMl.value : this.amountMl,
      diaperStatus: data.diaperStatus.present
          ? data.diaperStatus.value
          : this.diaperStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BabyCareLog(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('logType: $logType, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('amountMl: $amountMl, ')
          ..write('diaperStatus: $diaperStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, timestamp, logType, durationMinutes, amountMl, diaperStatus);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BabyCareLog &&
          other.id == this.id &&
          other.timestamp == this.timestamp &&
          other.logType == this.logType &&
          other.durationMinutes == this.durationMinutes &&
          other.amountMl == this.amountMl &&
          other.diaperStatus == this.diaperStatus);
}

class BabyCareLogsCompanion extends UpdateCompanion<BabyCareLog> {
  final Value<int> id;
  final Value<DateTime> timestamp;
  final Value<String> logType;
  final Value<int?> durationMinutes;
  final Value<double?> amountMl;
  final Value<String?> diaperStatus;
  const BabyCareLogsCompanion({
    this.id = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.logType = const Value.absent(),
    this.durationMinutes = const Value.absent(),
    this.amountMl = const Value.absent(),
    this.diaperStatus = const Value.absent(),
  });
  BabyCareLogsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime timestamp,
    required String logType,
    this.durationMinutes = const Value.absent(),
    this.amountMl = const Value.absent(),
    this.diaperStatus = const Value.absent(),
  })  : timestamp = Value(timestamp),
        logType = Value(logType);
  static Insertable<BabyCareLog> custom({
    Expression<int>? id,
    Expression<DateTime>? timestamp,
    Expression<String>? logType,
    Expression<int>? durationMinutes,
    Expression<double>? amountMl,
    Expression<String>? diaperStatus,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (timestamp != null) 'timestamp': timestamp,
      if (logType != null) 'log_type': logType,
      if (durationMinutes != null) 'duration_minutes': durationMinutes,
      if (amountMl != null) 'amount_ml': amountMl,
      if (diaperStatus != null) 'diaper_status': diaperStatus,
    });
  }

  BabyCareLogsCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? timestamp,
      Value<String>? logType,
      Value<int?>? durationMinutes,
      Value<double?>? amountMl,
      Value<String?>? diaperStatus}) {
    return BabyCareLogsCompanion(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      logType: logType ?? this.logType,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      amountMl: amountMl ?? this.amountMl,
      diaperStatus: diaperStatus ?? this.diaperStatus,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (logType.present) {
      map['log_type'] = Variable<String>(logType.value);
    }
    if (durationMinutes.present) {
      map['duration_minutes'] = Variable<int>(durationMinutes.value);
    }
    if (amountMl.present) {
      map['amount_ml'] = Variable<double>(amountMl.value);
    }
    if (diaperStatus.present) {
      map['diaper_status'] = Variable<String>(diaperStatus.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BabyCareLogsCompanion(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('logType: $logType, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('amountMl: $amountMl, ')
          ..write('diaperStatus: $diaperStatus')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UserProfilesTable userProfiles = $UserProfilesTable(this);
  late final $MenstrualLogsTable menstrualLogs = $MenstrualLogsTable(this);
  late final $KickSessionsTable kickSessions = $KickSessionsTable(this);
  late final $ContractionLogsTable contractionLogs =
      $ContractionLogsTable(this);
  late final $FoodDirectoryTable foodDirectory = $FoodDirectoryTable(this);
  late final $BabyCareLogsTable babyCareLogs = $BabyCareLogsTable(this);
  late final UserProfileDao userProfileDao =
      UserProfileDao(this as AppDatabase);
  late final CycleDao cycleDao = CycleDao(this as AppDatabase);
  late final PregnancyDao pregnancyDao = PregnancyDao(this as AppDatabase);
  late final BabyDao babyDao = BabyDao(this as AppDatabase);
  late final FoodDao foodDao = FoodDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        userProfiles,
        menstrualLogs,
        kickSessions,
        contractionLogs,
        foodDirectory,
        babyCareLogs
      ];
}

typedef $$UserProfilesTableCreateCompanionBuilder = UserProfilesCompanion
    Function({
  Value<int> id,
  required String currentMode,
  Value<DateTime?> lmpDate,
  Value<DateTime?> eddDate,
  Value<double?> prePregnancyWeight,
  Value<double?> height,
  Value<bool> isBiometricEnabled,
  Value<bool> disclaimerAccepted,
});
typedef $$UserProfilesTableUpdateCompanionBuilder = UserProfilesCompanion
    Function({
  Value<int> id,
  Value<String> currentMode,
  Value<DateTime?> lmpDate,
  Value<DateTime?> eddDate,
  Value<double?> prePregnancyWeight,
  Value<double?> height,
  Value<bool> isBiometricEnabled,
  Value<bool> disclaimerAccepted,
});

class $$UserProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currentMode => $composableBuilder(
      column: $table.currentMode, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lmpDate => $composableBuilder(
      column: $table.lmpDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get eddDate => $composableBuilder(
      column: $table.eddDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get prePregnancyWeight => $composableBuilder(
      column: $table.prePregnancyWeight,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get height => $composableBuilder(
      column: $table.height, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isBiometricEnabled => $composableBuilder(
      column: $table.isBiometricEnabled,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get disclaimerAccepted => $composableBuilder(
      column: $table.disclaimerAccepted,
      builder: (column) => ColumnFilters(column));
}

class $$UserProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currentMode => $composableBuilder(
      column: $table.currentMode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lmpDate => $composableBuilder(
      column: $table.lmpDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get eddDate => $composableBuilder(
      column: $table.eddDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get prePregnancyWeight => $composableBuilder(
      column: $table.prePregnancyWeight,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get height => $composableBuilder(
      column: $table.height, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isBiometricEnabled => $composableBuilder(
      column: $table.isBiometricEnabled,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get disclaimerAccepted => $composableBuilder(
      column: $table.disclaimerAccepted,
      builder: (column) => ColumnOrderings(column));
}

class $$UserProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get currentMode => $composableBuilder(
      column: $table.currentMode, builder: (column) => column);

  GeneratedColumn<DateTime> get lmpDate =>
      $composableBuilder(column: $table.lmpDate, builder: (column) => column);

  GeneratedColumn<DateTime> get eddDate =>
      $composableBuilder(column: $table.eddDate, builder: (column) => column);

  GeneratedColumn<double> get prePregnancyWeight => $composableBuilder(
      column: $table.prePregnancyWeight, builder: (column) => column);

  GeneratedColumn<double> get height =>
      $composableBuilder(column: $table.height, builder: (column) => column);

  GeneratedColumn<bool> get isBiometricEnabled => $composableBuilder(
      column: $table.isBiometricEnabled, builder: (column) => column);

  GeneratedColumn<bool> get disclaimerAccepted => $composableBuilder(
      column: $table.disclaimerAccepted, builder: (column) => column);
}

class $$UserProfilesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UserProfilesTable,
    UserProfile,
    $$UserProfilesTableFilterComposer,
    $$UserProfilesTableOrderingComposer,
    $$UserProfilesTableAnnotationComposer,
    $$UserProfilesTableCreateCompanionBuilder,
    $$UserProfilesTableUpdateCompanionBuilder,
    (
      UserProfile,
      BaseReferences<_$AppDatabase, $UserProfilesTable, UserProfile>
    ),
    UserProfile,
    PrefetchHooks Function()> {
  $$UserProfilesTableTableManager(_$AppDatabase db, $UserProfilesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> currentMode = const Value.absent(),
            Value<DateTime?> lmpDate = const Value.absent(),
            Value<DateTime?> eddDate = const Value.absent(),
            Value<double?> prePregnancyWeight = const Value.absent(),
            Value<double?> height = const Value.absent(),
            Value<bool> isBiometricEnabled = const Value.absent(),
            Value<bool> disclaimerAccepted = const Value.absent(),
          }) =>
              UserProfilesCompanion(
            id: id,
            currentMode: currentMode,
            lmpDate: lmpDate,
            eddDate: eddDate,
            prePregnancyWeight: prePregnancyWeight,
            height: height,
            isBiometricEnabled: isBiometricEnabled,
            disclaimerAccepted: disclaimerAccepted,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String currentMode,
            Value<DateTime?> lmpDate = const Value.absent(),
            Value<DateTime?> eddDate = const Value.absent(),
            Value<double?> prePregnancyWeight = const Value.absent(),
            Value<double?> height = const Value.absent(),
            Value<bool> isBiometricEnabled = const Value.absent(),
            Value<bool> disclaimerAccepted = const Value.absent(),
          }) =>
              UserProfilesCompanion.insert(
            id: id,
            currentMode: currentMode,
            lmpDate: lmpDate,
            eddDate: eddDate,
            prePregnancyWeight: prePregnancyWeight,
            height: height,
            isBiometricEnabled: isBiometricEnabled,
            disclaimerAccepted: disclaimerAccepted,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$UserProfilesTable, UserProfile>(table),
                    BaseReferences<_$AppDatabase, $UserProfilesTable,
                        UserProfile>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UserProfilesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UserProfilesTable,
    UserProfile,
    $$UserProfilesTableFilterComposer,
    $$UserProfilesTableOrderingComposer,
    $$UserProfilesTableAnnotationComposer,
    $$UserProfilesTableCreateCompanionBuilder,
    $$UserProfilesTableUpdateCompanionBuilder,
    (
      UserProfile,
      BaseReferences<_$AppDatabase, $UserProfilesTable, UserProfile>
    ),
    UserProfile,
    PrefetchHooks Function()>;
typedef $$MenstrualLogsTableCreateCompanionBuilder = MenstrualLogsCompanion
    Function({
  Value<int> id,
  required DateTime date,
  required int flowIntensity,
  Value<int> painLevel,
  Value<double?> bbtTemperature,
  Value<String?> symptoms,
});
typedef $$MenstrualLogsTableUpdateCompanionBuilder = MenstrualLogsCompanion
    Function({
  Value<int> id,
  Value<DateTime> date,
  Value<int> flowIntensity,
  Value<int> painLevel,
  Value<double?> bbtTemperature,
  Value<String?> symptoms,
});

class $$MenstrualLogsTableFilterComposer
    extends Composer<_$AppDatabase, $MenstrualLogsTable> {
  $$MenstrualLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get flowIntensity => $composableBuilder(
      column: $table.flowIntensity, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get painLevel => $composableBuilder(
      column: $table.painLevel, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get bbtTemperature => $composableBuilder(
      column: $table.bbtTemperature,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get symptoms => $composableBuilder(
      column: $table.symptoms, builder: (column) => ColumnFilters(column));
}

class $$MenstrualLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $MenstrualLogsTable> {
  $$MenstrualLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get flowIntensity => $composableBuilder(
      column: $table.flowIntensity,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get painLevel => $composableBuilder(
      column: $table.painLevel, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get bbtTemperature => $composableBuilder(
      column: $table.bbtTemperature,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get symptoms => $composableBuilder(
      column: $table.symptoms, builder: (column) => ColumnOrderings(column));
}

class $$MenstrualLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MenstrualLogsTable> {
  $$MenstrualLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get flowIntensity => $composableBuilder(
      column: $table.flowIntensity, builder: (column) => column);

  GeneratedColumn<int> get painLevel =>
      $composableBuilder(column: $table.painLevel, builder: (column) => column);

  GeneratedColumn<double> get bbtTemperature => $composableBuilder(
      column: $table.bbtTemperature, builder: (column) => column);

  GeneratedColumn<String> get symptoms =>
      $composableBuilder(column: $table.symptoms, builder: (column) => column);
}

class $$MenstrualLogsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MenstrualLogsTable,
    MenstrualLog,
    $$MenstrualLogsTableFilterComposer,
    $$MenstrualLogsTableOrderingComposer,
    $$MenstrualLogsTableAnnotationComposer,
    $$MenstrualLogsTableCreateCompanionBuilder,
    $$MenstrualLogsTableUpdateCompanionBuilder,
    (
      MenstrualLog,
      BaseReferences<_$AppDatabase, $MenstrualLogsTable, MenstrualLog>
    ),
    MenstrualLog,
    PrefetchHooks Function()> {
  $$MenstrualLogsTableTableManager(_$AppDatabase db, $MenstrualLogsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MenstrualLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MenstrualLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MenstrualLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<int> flowIntensity = const Value.absent(),
            Value<int> painLevel = const Value.absent(),
            Value<double?> bbtTemperature = const Value.absent(),
            Value<String?> symptoms = const Value.absent(),
          }) =>
              MenstrualLogsCompanion(
            id: id,
            date: date,
            flowIntensity: flowIntensity,
            painLevel: painLevel,
            bbtTemperature: bbtTemperature,
            symptoms: symptoms,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required DateTime date,
            required int flowIntensity,
            Value<int> painLevel = const Value.absent(),
            Value<double?> bbtTemperature = const Value.absent(),
            Value<String?> symptoms = const Value.absent(),
          }) =>
              MenstrualLogsCompanion.insert(
            id: id,
            date: date,
            flowIntensity: flowIntensity,
            painLevel: painLevel,
            bbtTemperature: bbtTemperature,
            symptoms: symptoms,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$MenstrualLogsTable, MenstrualLog>(table),
                    BaseReferences<_$AppDatabase, $MenstrualLogsTable,
                        MenstrualLog>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$MenstrualLogsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MenstrualLogsTable,
    MenstrualLog,
    $$MenstrualLogsTableFilterComposer,
    $$MenstrualLogsTableOrderingComposer,
    $$MenstrualLogsTableAnnotationComposer,
    $$MenstrualLogsTableCreateCompanionBuilder,
    $$MenstrualLogsTableUpdateCompanionBuilder,
    (
      MenstrualLog,
      BaseReferences<_$AppDatabase, $MenstrualLogsTable, MenstrualLog>
    ),
    MenstrualLog,
    PrefetchHooks Function()>;
typedef $$KickSessionsTableCreateCompanionBuilder = KickSessionsCompanion
    Function({
  Value<int> id,
  required DateTime startTime,
  Value<DateTime?> endTime,
  required int kickCount,
  required int durationSeconds,
});
typedef $$KickSessionsTableUpdateCompanionBuilder = KickSessionsCompanion
    Function({
  Value<int> id,
  Value<DateTime> startTime,
  Value<DateTime?> endTime,
  Value<int> kickCount,
  Value<int> durationSeconds,
});

class $$KickSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $KickSessionsTable> {
  $$KickSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startTime => $composableBuilder(
      column: $table.startTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endTime => $composableBuilder(
      column: $table.endTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get kickCount => $composableBuilder(
      column: $table.kickCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get durationSeconds => $composableBuilder(
      column: $table.durationSeconds,
      builder: (column) => ColumnFilters(column));
}

class $$KickSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $KickSessionsTable> {
  $$KickSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startTime => $composableBuilder(
      column: $table.startTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endTime => $composableBuilder(
      column: $table.endTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get kickCount => $composableBuilder(
      column: $table.kickCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
      column: $table.durationSeconds,
      builder: (column) => ColumnOrderings(column));
}

class $$KickSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $KickSessionsTable> {
  $$KickSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<DateTime> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<int> get kickCount =>
      $composableBuilder(column: $table.kickCount, builder: (column) => column);

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
      column: $table.durationSeconds, builder: (column) => column);
}

class $$KickSessionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $KickSessionsTable,
    KickSession,
    $$KickSessionsTableFilterComposer,
    $$KickSessionsTableOrderingComposer,
    $$KickSessionsTableAnnotationComposer,
    $$KickSessionsTableCreateCompanionBuilder,
    $$KickSessionsTableUpdateCompanionBuilder,
    (
      KickSession,
      BaseReferences<_$AppDatabase, $KickSessionsTable, KickSession>
    ),
    KickSession,
    PrefetchHooks Function()> {
  $$KickSessionsTableTableManager(_$AppDatabase db, $KickSessionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KickSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$KickSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KickSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> startTime = const Value.absent(),
            Value<DateTime?> endTime = const Value.absent(),
            Value<int> kickCount = const Value.absent(),
            Value<int> durationSeconds = const Value.absent(),
          }) =>
              KickSessionsCompanion(
            id: id,
            startTime: startTime,
            endTime: endTime,
            kickCount: kickCount,
            durationSeconds: durationSeconds,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required DateTime startTime,
            Value<DateTime?> endTime = const Value.absent(),
            required int kickCount,
            required int durationSeconds,
          }) =>
              KickSessionsCompanion.insert(
            id: id,
            startTime: startTime,
            endTime: endTime,
            kickCount: kickCount,
            durationSeconds: durationSeconds,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$KickSessionsTable, KickSession>(table),
                    BaseReferences<_$AppDatabase, $KickSessionsTable,
                        KickSession>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$KickSessionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $KickSessionsTable,
    KickSession,
    $$KickSessionsTableFilterComposer,
    $$KickSessionsTableOrderingComposer,
    $$KickSessionsTableAnnotationComposer,
    $$KickSessionsTableCreateCompanionBuilder,
    $$KickSessionsTableUpdateCompanionBuilder,
    (
      KickSession,
      BaseReferences<_$AppDatabase, $KickSessionsTable, KickSession>
    ),
    KickSession,
    PrefetchHooks Function()>;
typedef $$ContractionLogsTableCreateCompanionBuilder = ContractionLogsCompanion
    Function({
  Value<int> id,
  required DateTime startTime,
  required DateTime endTime,
  required int durationSeconds,
  required int intervalSeconds,
  required int intensity,
});
typedef $$ContractionLogsTableUpdateCompanionBuilder = ContractionLogsCompanion
    Function({
  Value<int> id,
  Value<DateTime> startTime,
  Value<DateTime> endTime,
  Value<int> durationSeconds,
  Value<int> intervalSeconds,
  Value<int> intensity,
});

class $$ContractionLogsTableFilterComposer
    extends Composer<_$AppDatabase, $ContractionLogsTable> {
  $$ContractionLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startTime => $composableBuilder(
      column: $table.startTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endTime => $composableBuilder(
      column: $table.endTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get durationSeconds => $composableBuilder(
      column: $table.durationSeconds,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get intervalSeconds => $composableBuilder(
      column: $table.intervalSeconds,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get intensity => $composableBuilder(
      column: $table.intensity, builder: (column) => ColumnFilters(column));
}

class $$ContractionLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $ContractionLogsTable> {
  $$ContractionLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startTime => $composableBuilder(
      column: $table.startTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endTime => $composableBuilder(
      column: $table.endTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
      column: $table.durationSeconds,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get intervalSeconds => $composableBuilder(
      column: $table.intervalSeconds,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get intensity => $composableBuilder(
      column: $table.intensity, builder: (column) => ColumnOrderings(column));
}

class $$ContractionLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ContractionLogsTable> {
  $$ContractionLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<DateTime> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
      column: $table.durationSeconds, builder: (column) => column);

  GeneratedColumn<int> get intervalSeconds => $composableBuilder(
      column: $table.intervalSeconds, builder: (column) => column);

  GeneratedColumn<int> get intensity =>
      $composableBuilder(column: $table.intensity, builder: (column) => column);
}

class $$ContractionLogsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ContractionLogsTable,
    ContractionLog,
    $$ContractionLogsTableFilterComposer,
    $$ContractionLogsTableOrderingComposer,
    $$ContractionLogsTableAnnotationComposer,
    $$ContractionLogsTableCreateCompanionBuilder,
    $$ContractionLogsTableUpdateCompanionBuilder,
    (
      ContractionLog,
      BaseReferences<_$AppDatabase, $ContractionLogsTable, ContractionLog>
    ),
    ContractionLog,
    PrefetchHooks Function()> {
  $$ContractionLogsTableTableManager(
      _$AppDatabase db, $ContractionLogsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ContractionLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ContractionLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ContractionLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> startTime = const Value.absent(),
            Value<DateTime> endTime = const Value.absent(),
            Value<int> durationSeconds = const Value.absent(),
            Value<int> intervalSeconds = const Value.absent(),
            Value<int> intensity = const Value.absent(),
          }) =>
              ContractionLogsCompanion(
            id: id,
            startTime: startTime,
            endTime: endTime,
            durationSeconds: durationSeconds,
            intervalSeconds: intervalSeconds,
            intensity: intensity,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required DateTime startTime,
            required DateTime endTime,
            required int durationSeconds,
            required int intervalSeconds,
            required int intensity,
          }) =>
              ContractionLogsCompanion.insert(
            id: id,
            startTime: startTime,
            endTime: endTime,
            durationSeconds: durationSeconds,
            intervalSeconds: intervalSeconds,
            intensity: intensity,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$ContractionLogsTable, ContractionLog>(table),
                    BaseReferences<_$AppDatabase, $ContractionLogsTable,
                        ContractionLog>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ContractionLogsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ContractionLogsTable,
    ContractionLog,
    $$ContractionLogsTableFilterComposer,
    $$ContractionLogsTableOrderingComposer,
    $$ContractionLogsTableAnnotationComposer,
    $$ContractionLogsTableCreateCompanionBuilder,
    $$ContractionLogsTableUpdateCompanionBuilder,
    (
      ContractionLog,
      BaseReferences<_$AppDatabase, $ContractionLogsTable, ContractionLog>
    ),
    ContractionLog,
    PrefetchHooks Function()>;
typedef $$FoodDirectoryTableCreateCompanionBuilder = FoodDirectoryCompanion
    Function({
  Value<int> id,
  required String nameArabic,
  required String category,
  required int safetyLevel,
  required String reasonMedical,
  required String pregnancyAdvice,
  required String postpartumAdvice,
});
typedef $$FoodDirectoryTableUpdateCompanionBuilder = FoodDirectoryCompanion
    Function({
  Value<int> id,
  Value<String> nameArabic,
  Value<String> category,
  Value<int> safetyLevel,
  Value<String> reasonMedical,
  Value<String> pregnancyAdvice,
  Value<String> postpartumAdvice,
});

class $$FoodDirectoryTableFilterComposer
    extends Composer<_$AppDatabase, $FoodDirectoryTable> {
  $$FoodDirectoryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameArabic => $composableBuilder(
      column: $table.nameArabic, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get safetyLevel => $composableBuilder(
      column: $table.safetyLevel, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reasonMedical => $composableBuilder(
      column: $table.reasonMedical, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pregnancyAdvice => $composableBuilder(
      column: $table.pregnancyAdvice,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get postpartumAdvice => $composableBuilder(
      column: $table.postpartumAdvice,
      builder: (column) => ColumnFilters(column));
}

class $$FoodDirectoryTableOrderingComposer
    extends Composer<_$AppDatabase, $FoodDirectoryTable> {
  $$FoodDirectoryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameArabic => $composableBuilder(
      column: $table.nameArabic, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get safetyLevel => $composableBuilder(
      column: $table.safetyLevel, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reasonMedical => $composableBuilder(
      column: $table.reasonMedical,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pregnancyAdvice => $composableBuilder(
      column: $table.pregnancyAdvice,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get postpartumAdvice => $composableBuilder(
      column: $table.postpartumAdvice,
      builder: (column) => ColumnOrderings(column));
}

class $$FoodDirectoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $FoodDirectoryTable> {
  $$FoodDirectoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nameArabic => $composableBuilder(
      column: $table.nameArabic, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get safetyLevel => $composableBuilder(
      column: $table.safetyLevel, builder: (column) => column);

  GeneratedColumn<String> get reasonMedical => $composableBuilder(
      column: $table.reasonMedical, builder: (column) => column);

  GeneratedColumn<String> get pregnancyAdvice => $composableBuilder(
      column: $table.pregnancyAdvice, builder: (column) => column);

  GeneratedColumn<String> get postpartumAdvice => $composableBuilder(
      column: $table.postpartumAdvice, builder: (column) => column);
}

class $$FoodDirectoryTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FoodDirectoryTable,
    FoodDirectoryData,
    $$FoodDirectoryTableFilterComposer,
    $$FoodDirectoryTableOrderingComposer,
    $$FoodDirectoryTableAnnotationComposer,
    $$FoodDirectoryTableCreateCompanionBuilder,
    $$FoodDirectoryTableUpdateCompanionBuilder,
    (
      FoodDirectoryData,
      BaseReferences<_$AppDatabase, $FoodDirectoryTable, FoodDirectoryData>
    ),
    FoodDirectoryData,
    PrefetchHooks Function()> {
  $$FoodDirectoryTableTableManager(_$AppDatabase db, $FoodDirectoryTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FoodDirectoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FoodDirectoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FoodDirectoryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> nameArabic = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<int> safetyLevel = const Value.absent(),
            Value<String> reasonMedical = const Value.absent(),
            Value<String> pregnancyAdvice = const Value.absent(),
            Value<String> postpartumAdvice = const Value.absent(),
          }) =>
              FoodDirectoryCompanion(
            id: id,
            nameArabic: nameArabic,
            category: category,
            safetyLevel: safetyLevel,
            reasonMedical: reasonMedical,
            pregnancyAdvice: pregnancyAdvice,
            postpartumAdvice: postpartumAdvice,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String nameArabic,
            required String category,
            required int safetyLevel,
            required String reasonMedical,
            required String pregnancyAdvice,
            required String postpartumAdvice,
          }) =>
              FoodDirectoryCompanion.insert(
            id: id,
            nameArabic: nameArabic,
            category: category,
            safetyLevel: safetyLevel,
            reasonMedical: reasonMedical,
            pregnancyAdvice: pregnancyAdvice,
            postpartumAdvice: postpartumAdvice,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$FoodDirectoryTable, FoodDirectoryData>(table),
                    BaseReferences<_$AppDatabase, $FoodDirectoryTable,
                        FoodDirectoryData>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$FoodDirectoryTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FoodDirectoryTable,
    FoodDirectoryData,
    $$FoodDirectoryTableFilterComposer,
    $$FoodDirectoryTableOrderingComposer,
    $$FoodDirectoryTableAnnotationComposer,
    $$FoodDirectoryTableCreateCompanionBuilder,
    $$FoodDirectoryTableUpdateCompanionBuilder,
    (
      FoodDirectoryData,
      BaseReferences<_$AppDatabase, $FoodDirectoryTable, FoodDirectoryData>
    ),
    FoodDirectoryData,
    PrefetchHooks Function()>;
typedef $$BabyCareLogsTableCreateCompanionBuilder = BabyCareLogsCompanion
    Function({
  Value<int> id,
  required DateTime timestamp,
  required String logType,
  Value<int?> durationMinutes,
  Value<double?> amountMl,
  Value<String?> diaperStatus,
});
typedef $$BabyCareLogsTableUpdateCompanionBuilder = BabyCareLogsCompanion
    Function({
  Value<int> id,
  Value<DateTime> timestamp,
  Value<String> logType,
  Value<int?> durationMinutes,
  Value<double?> amountMl,
  Value<String?> diaperStatus,
});

class $$BabyCareLogsTableFilterComposer
    extends Composer<_$AppDatabase, $BabyCareLogsTable> {
  $$BabyCareLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get logType => $composableBuilder(
      column: $table.logType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get durationMinutes => $composableBuilder(
      column: $table.durationMinutes,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amountMl => $composableBuilder(
      column: $table.amountMl, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get diaperStatus => $composableBuilder(
      column: $table.diaperStatus, builder: (column) => ColumnFilters(column));
}

class $$BabyCareLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $BabyCareLogsTable> {
  $$BabyCareLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get logType => $composableBuilder(
      column: $table.logType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get durationMinutes => $composableBuilder(
      column: $table.durationMinutes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amountMl => $composableBuilder(
      column: $table.amountMl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get diaperStatus => $composableBuilder(
      column: $table.diaperStatus,
      builder: (column) => ColumnOrderings(column));
}

class $$BabyCareLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BabyCareLogsTable> {
  $$BabyCareLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<String> get logType =>
      $composableBuilder(column: $table.logType, builder: (column) => column);

  GeneratedColumn<int> get durationMinutes => $composableBuilder(
      column: $table.durationMinutes, builder: (column) => column);

  GeneratedColumn<double> get amountMl =>
      $composableBuilder(column: $table.amountMl, builder: (column) => column);

  GeneratedColumn<String> get diaperStatus => $composableBuilder(
      column: $table.diaperStatus, builder: (column) => column);
}

class $$BabyCareLogsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BabyCareLogsTable,
    BabyCareLog,
    $$BabyCareLogsTableFilterComposer,
    $$BabyCareLogsTableOrderingComposer,
    $$BabyCareLogsTableAnnotationComposer,
    $$BabyCareLogsTableCreateCompanionBuilder,
    $$BabyCareLogsTableUpdateCompanionBuilder,
    (
      BabyCareLog,
      BaseReferences<_$AppDatabase, $BabyCareLogsTable, BabyCareLog>
    ),
    BabyCareLog,
    PrefetchHooks Function()> {
  $$BabyCareLogsTableTableManager(_$AppDatabase db, $BabyCareLogsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BabyCareLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BabyCareLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BabyCareLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> timestamp = const Value.absent(),
            Value<String> logType = const Value.absent(),
            Value<int?> durationMinutes = const Value.absent(),
            Value<double?> amountMl = const Value.absent(),
            Value<String?> diaperStatus = const Value.absent(),
          }) =>
              BabyCareLogsCompanion(
            id: id,
            timestamp: timestamp,
            logType: logType,
            durationMinutes: durationMinutes,
            amountMl: amountMl,
            diaperStatus: diaperStatus,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required DateTime timestamp,
            required String logType,
            Value<int?> durationMinutes = const Value.absent(),
            Value<double?> amountMl = const Value.absent(),
            Value<String?> diaperStatus = const Value.absent(),
          }) =>
              BabyCareLogsCompanion.insert(
            id: id,
            timestamp: timestamp,
            logType: logType,
            durationMinutes: durationMinutes,
            amountMl: amountMl,
            diaperStatus: diaperStatus,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$BabyCareLogsTable, BabyCareLog>(table),
                    BaseReferences<_$AppDatabase, $BabyCareLogsTable,
                        BabyCareLog>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BabyCareLogsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BabyCareLogsTable,
    BabyCareLog,
    $$BabyCareLogsTableFilterComposer,
    $$BabyCareLogsTableOrderingComposer,
    $$BabyCareLogsTableAnnotationComposer,
    $$BabyCareLogsTableCreateCompanionBuilder,
    $$BabyCareLogsTableUpdateCompanionBuilder,
    (
      BabyCareLog,
      BaseReferences<_$AppDatabase, $BabyCareLogsTable, BabyCareLog>
    ),
    BabyCareLog,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UserProfilesTableTableManager get userProfiles =>
      $$UserProfilesTableTableManager(_db, _db.userProfiles);
  $$MenstrualLogsTableTableManager get menstrualLogs =>
      $$MenstrualLogsTableTableManager(_db, _db.menstrualLogs);
  $$KickSessionsTableTableManager get kickSessions =>
      $$KickSessionsTableTableManager(_db, _db.kickSessions);
  $$ContractionLogsTableTableManager get contractionLogs =>
      $$ContractionLogsTableTableManager(_db, _db.contractionLogs);
  $$FoodDirectoryTableTableManager get foodDirectory =>
      $$FoodDirectoryTableTableManager(_db, _db.foodDirectory);
  $$BabyCareLogsTableTableManager get babyCareLogs =>
      $$BabyCareLogsTableTableManager(_db, _db.babyCareLogs);
}

mixin _$UserProfileDaoMixin on DatabaseAccessor<AppDatabase> {
  $UserProfilesTable get userProfiles => attachedDatabase.userProfiles;
  UserProfileDaoManager get managers => UserProfileDaoManager(this);
}

class UserProfileDaoManager {
  final _$UserProfileDaoMixin _db;
  UserProfileDaoManager(this._db);
  $$UserProfilesTableTableManager get userProfiles =>
      $$UserProfilesTableTableManager(_db.attachedDatabase, _db.userProfiles);
}

mixin _$CycleDaoMixin on DatabaseAccessor<AppDatabase> {
  $MenstrualLogsTable get menstrualLogs => attachedDatabase.menstrualLogs;
  CycleDaoManager get managers => CycleDaoManager(this);
}

class CycleDaoManager {
  final _$CycleDaoMixin _db;
  CycleDaoManager(this._db);
  $$MenstrualLogsTableTableManager get menstrualLogs =>
      $$MenstrualLogsTableTableManager(_db.attachedDatabase, _db.menstrualLogs);
}

mixin _$PregnancyDaoMixin on DatabaseAccessor<AppDatabase> {
  $KickSessionsTable get kickSessions => attachedDatabase.kickSessions;
  $ContractionLogsTable get contractionLogs => attachedDatabase.contractionLogs;
  PregnancyDaoManager get managers => PregnancyDaoManager(this);
}

class PregnancyDaoManager {
  final _$PregnancyDaoMixin _db;
  PregnancyDaoManager(this._db);
  $$KickSessionsTableTableManager get kickSessions =>
      $$KickSessionsTableTableManager(_db.attachedDatabase, _db.kickSessions);
  $$ContractionLogsTableTableManager get contractionLogs =>
      $$ContractionLogsTableTableManager(
          _db.attachedDatabase, _db.contractionLogs);
}

mixin _$BabyDaoMixin on DatabaseAccessor<AppDatabase> {
  $BabyCareLogsTable get babyCareLogs => attachedDatabase.babyCareLogs;
  BabyDaoManager get managers => BabyDaoManager(this);
}

class BabyDaoManager {
  final _$BabyDaoMixin _db;
  BabyDaoManager(this._db);
  $$BabyCareLogsTableTableManager get babyCareLogs =>
      $$BabyCareLogsTableTableManager(_db.attachedDatabase, _db.babyCareLogs);
}

mixin _$FoodDaoMixin on DatabaseAccessor<AppDatabase> {
  $FoodDirectoryTable get foodDirectory => attachedDatabase.foodDirectory;
  FoodDaoManager get managers => FoodDaoManager(this);
}

class FoodDaoManager {
  final _$FoodDaoMixin _db;
  FoodDaoManager(this._db);
  $$FoodDirectoryTableTableManager get foodDirectory =>
      $$FoodDirectoryTableTableManager(_db.attachedDatabase, _db.foodDirectory);
}
