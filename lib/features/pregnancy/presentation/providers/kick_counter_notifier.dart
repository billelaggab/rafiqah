// lib/features/pregnancy/presentation/providers/kick_counter_notifier.dart
import 'dart:async';

import 'package:drift/drift.dart' hide Column;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rafiqah/core/database/app_database.dart';
import 'package:rafiqah/core/database/database_provider.dart';
import 'package:rafiqah/core/utils/constants.dart';

class KickCounterState {
  const KickCounterState({
    this.count = 0,
    this.elapsedSeconds = 0,
    this.running = false,
    this.alerted = false,
  });

  final int count;
  final int elapsedSeconds;
  final bool running;
  final bool alerted;

  KickCounterState copyWith({
    int? count,
    int? elapsedSeconds,
    bool? running,
    bool? alerted,
  }) =>
      KickCounterState(
        count: count ?? this.count,
        elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
        running: running ?? this.running,
        alerted: alerted ?? this.alerted,
      );
}

class KickCounterNotifier extends Notifier<KickCounterState> {
  Timer? _timer;
  DateTime? _start;

  @override
  KickCounterState build() {
    ref.onDispose(() => _timer?.cancel());
    return const KickCounterState();
  }

  void start() {
    if (state.running) return;
    _start = DateTime.now();
    state = state.copyWith(running: true, elapsedSeconds: 0);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    final start = _start;
    if (start == null) return;
    final elapsed = DateTime.now().difference(start).inSeconds;
    final shouldAlert = state.count < AppConstants.kickTarget &&
        elapsed >= AppConstants.kickWindow.inSeconds;
    final firstAlert = shouldAlert && !state.alerted;
    state = state.copyWith(
      elapsedSeconds: elapsed,
      alerted: shouldAlert,
    );
    if (firstAlert) {
      HapticFeedback.heavyImpact();
      SystemSound.play(SystemSoundType.alert);
    }
  }

  /// يعيد مزامنة الوقت بعد عودة التطبيق من الخلفية.
  void sync() {
    if (state.running) _tick();
  }

  void recordKick() {
    if (!state.running) start();
    state = state.copyWith(count: state.count + 1);
  }

  Future<void> finish() async {
    _timer?.cancel();
    final start = _start;
    try {
      if (start != null && state.count > 0) {
        final db = ref.read(databaseProvider);
        final end = DateTime.now();
        await db.pregnancyDao.insertKickSession(
          KickSessionsCompanion.insert(
            startTime: start,
            endTime: Value(end),
            kickCount: state.count,
            durationSeconds: end.difference(start).inSeconds,
          ),
        );
      }
    } finally {
      state = const KickCounterState();
      _start = null;
    }
  }

  void reset() {
    _timer?.cancel();
    state = const KickCounterState();
    _start = null;
  }
}

final kickCounterProvider =
    NotifierProvider<KickCounterNotifier, KickCounterState>(
  KickCounterNotifier.new,
);
