// lib/features/pregnancy/presentation/providers/kick_counter_notifier.dart
import 'dart:async';
import 'package:drift/drift.dart' hide Column;
import 'package:rafiqah/core/database/database_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafiqah/core/database/app_database.dart';
import 'package:rafiqah/core/utils/constants.dart';

class KickCounterState {
  final int count;
  final int elapsedSeconds;
  final bool running;
  final bool alerted;
  KickCounterState({this.count = 0, this.elapsedSeconds = 0, this.running = false, this.alerted = false});

  KickCounterState copyWith({int? count, int? elapsedSeconds, bool? running, bool? alerted}) =>
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
    return KickCounterState();
  }

  void start() {
    if (state.running) return;
    _start = DateTime.now();
    state = state.copyWith(running: true);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      state = state.copyWith(elapsedSeconds: state.elapsedSeconds + 1);
      if (state.count < AppConstants.kickTarget &&
          state.elapsedSeconds >= AppConstants.kickWindow.inSeconds &&
          !state.alerted) {
        state = state.copyWith(alerted: true);
      }
    });
  }

  void recordKick() {
    if (!state.running) start();
    state = state.copyWith(count: state.count + 1);
  }

  Future<void> finish() async {
    _timer?.cancel();
    final db = ref.read(databaseProvider);
    if (_start != null) {
      await db.pregnancyDao.insertKickSession(KickSessionsCompanion.insert(
        startTime: _start!,
        endTime: Value(DateTime.now()),
        kickCount: state.count,
        durationSeconds: state.elapsedSeconds,
      ));
    }
    state = KickCounterState();
    _start = null;
  }

  void reset() {
    _timer?.cancel();
    state = KickCounterState();
    _start = null;
  }

}

final kickCounterProvider =
    NotifierProvider<KickCounterNotifier, KickCounterState>(KickCounterNotifier.new);
