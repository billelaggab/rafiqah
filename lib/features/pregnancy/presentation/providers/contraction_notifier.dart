// lib/features/pregnancy/presentation/providers/contraction_notifier.dart
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rafiqah/core/database/app_database.dart';
import 'package:rafiqah/core/database/database_provider.dart';
import 'package:rafiqah/core/utils/medical_calculator.dart';

class ContractionState {
  const ContractionState({
    this.contractions = const <Contraction>[],
    this.isContracting = false,
    this.currentStart,
    this.currentDuration = 0,
    this.alert = false,
  });

  final List<Contraction> contractions;
  final bool isContracting;
  final DateTime? currentStart;
  final int currentDuration;
  final bool alert;

  static const Object _unset = Object();

  ContractionState copyWith({
    List<Contraction>? contractions,
    bool? isContracting,
    Object? currentStart = _unset,
    int? currentDuration,
    bool? alert,
  }) =>
      ContractionState(
        contractions: contractions ?? this.contractions,
        isContracting: isContracting ?? this.isContracting,
        currentStart: identical(currentStart, _unset)
            ? this.currentStart
            : currentStart as DateTime?,
        currentDuration: currentDuration ?? this.currentDuration,
        alert: alert ?? this.alert,
      );
}

class ContractionNotifier extends Notifier<ContractionState> {
  Timer? _timer;
  DateTime? _start;

  @override
  ContractionState build() {
    ref.onDispose(() => _timer?.cancel());
    return const ContractionState();
  }

  void startContraction() {
    if (state.isContracting) return;
    _start = DateTime.now();
    state = state.copyWith(
      isContracting: true,
      currentStart: _start,
      currentDuration: 0,
    );
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    final start = _start;
    if (start == null) return;
    state = state.copyWith(
      currentDuration: DateTime.now().difference(start).inSeconds,
    );
  }

  /// يعيد مزامنة الوقت بعد عودة التطبيق من الخلفية.
  void sync() {
    if (state.isContracting) _tick();
  }

  Future<void> endContraction() async {
    _timer?.cancel();
    final start = _start ?? state.currentStart;
    if (start == null) return;
    final end = DateTime.now();
    final duration = end.difference(start).inSeconds;
    final previous =
        state.contractions.isNotEmpty ? state.contractions.last : null;
    final interval =
        previous != null ? start.difference(previous.startTime).inSeconds : 0;

    final log = Contraction(
      startTime: start,
      endTime: end,
      durationSeconds: duration,
      intervalSeconds: interval,
      intensity: 2,
    );
    final newList = [...state.contractions, log];
    final alert = MedicalCalculator.shouldAlertHospital(newList);
    final firstAlert = alert && !state.alert;

    state = state.copyWith(
      contractions: newList,
      isContracting: false,
      currentStart: null,
      currentDuration: 0,
      alert: alert,
    );
    _start = null;

    if (firstAlert) {
      HapticFeedback.heavyImpact();
      SystemSound.play(SystemSoundType.alert);
    }

    final db = ref.read(databaseProvider);
    await db.pregnancyDao.insertContraction(
      ContractionLogsCompanion.insert(
        startTime: start,
        endTime: end,
        durationSeconds: duration,
        intervalSeconds: interval,
        intensity: 2,
      ),
    );
  }

  void reset() {
    _timer?.cancel();
    state = const ContractionState();
    _start = null;
  }
}

final contractionProvider =
    NotifierProvider<ContractionNotifier, ContractionState>(
  ContractionNotifier.new,
);
