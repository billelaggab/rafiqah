// lib/features/pregnancy/presentation/providers/contraction_notifier.dart
import 'dart:async';
import 'package:rafiqah/core/database/database_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafiqah/core/database/app_database.dart';
import 'package:rafiqah/core/utils/medical_calculator.dart';

class ContractionState {
  final List<Contraction> contractions;
  final bool isContracting;
  final DateTime? currentStart;
  final int currentDuration;
  final bool alert;
  ContractionState({
    this.contractions = const <Contraction>[],
    this.isContracting = false,
    this.currentStart,
    this.currentDuration = 0,
    this.alert = false,
  });

  ContractionState copyWith({
    List<Contraction>? contractions,
    bool? isContracting,
    DateTime? currentStart,
    int? currentDuration,
    bool? alert,
  }) =>
      ContractionState(
        contractions: contractions ?? this.contractions,
        isContracting: isContracting ?? this.isContracting,
        currentStart: currentStart ?? this.currentStart,
        currentDuration: currentDuration ?? this.currentDuration,
        alert: alert ?? this.alert,
      );
}

class ContractionNotifier extends Notifier<ContractionState> {
  Timer? _timer;

  @override
  ContractionState build() {
    ref.onDispose(() => _timer?.cancel());
    return ContractionState();
  }

  void startContraction() {
    if (state.isContracting) return;
    state = state.copyWith(isContracting: true, currentStart: DateTime.now(), currentDuration: 0);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      state = state.copyWith(currentDuration: state.currentDuration + 1);
    });
  }

  Future<void> endContraction() async {
    _timer?.cancel();
    final start = state.currentStart;
    if (start == null) return;
    final end = DateTime.now();
    final duration = end.difference(start).inSeconds;
    final prev = state.contractions.isNotEmpty ? state.contractions.last : null;
    final interval = prev != null ? start.difference(prev.startTime).inSeconds : 0;
    final log = Contraction(
      startTime: start,
      endTime: end,
      durationSeconds: duration,
      intervalSeconds: interval,
      intensity: 2,
    );
    final newList = [...state.contractions, log];
    final alert = MedicalCalculator.shouldAlertHospital(newList);
    state = state.copyWith(
      contractions: newList,
      isContracting: false,
      currentStart: null,
      currentDuration: 0,
      alert: alert,
    );
    // persist
    final db = ref.read(databaseProvider);
    await db.pregnancyDao.insertContraction(ContractionLogsCompanion.insert(
      startTime: start,
      endTime: end,
      durationSeconds: duration,
      intervalSeconds: interval,
      intensity: 2,
    ));
  }

  void reset() {
    _timer?.cancel();
    state = ContractionState();
  }
}

final contractionProvider =
    NotifierProvider<ContractionNotifier, ContractionState>(ContractionNotifier.new);