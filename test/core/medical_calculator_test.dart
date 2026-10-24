import 'package:flutter_test/flutter_test.dart';
import 'package:rafiqah/core/utils/medical_calculator.dart';

void main() {
  group('MedicalCalculator', () {
    test('calculateEDD uses adjusted Naegele formula', () {
      final lmp = DateTime(2027, 1, 1);
      expect(
        MedicalCalculator.calculateEDD(lmp: lmp, cycleLength: 28),
        DateTime(2027, 10, 8),
      );
      expect(
        MedicalCalculator.calculateEDD(lmp: lmp, cycleLength: 32),
        DateTime(2027, 10, 12),
      );
      expect(
        MedicalCalculator.calculateEDD(lmp: lmp, cycleLength: 25),
        DateTime(2027, 10, 5),
      );
    });

    test('calculateEDD rejects implausible cycle length', () {
      final lmp = DateTime(2027, 1, 1);
      expect(
        () => MedicalCalculator.calculateEDD(lmp: lmp, cycleLength: 10),
        throwsArgumentError,
      );
      expect(
        () => MedicalCalculator.calculateEDD(lmp: lmp, cycleLength: 60),
        throwsArgumentError,
      );
    });

    test('fertile window is anchored to ovulation day', () {
      final periodStart = DateTime(2027, 1, 1);
      final window = MedicalCalculator.calculateFertileWindow(
        periodStartDate: periodStart,
        cycleLength: 28,
      );
      expect(window.ovulationDay, DateTime(2027, 1, 15));
      expect(window.fertileStart, DateTime(2027, 1, 10));
      expect(window.fertileEnd, DateTime(2027, 1, 16));
    });

    test('periodStarts groups consecutive bleeding days', () {
      final starts = MedicalCalculator.periodStarts([
        DateTime(2027, 1, 1),
        DateTime(2027, 1, 2),
        DateTime(2027, 1, 3),
        DateTime(2027, 1, 10),
        DateTime(2027, 1, 11),
        DateTime(2027, 2, 1),
      ]);
      expect(starts, [
        DateTime(2027, 1, 1),
        DateTime(2027, 1, 10),
        DateTime(2027, 2, 1),
      ]);
    });

    test('averageCycleLength uses plausible recent gaps', () {
      final starts = [
        DateTime(2027, 1, 1),
        DateTime(2027, 1, 29),
        DateTime(2027, 2, 26),
        DateTime(2027, 3, 26),
      ];
      expect(MedicalCalculator.averageCycleLength(starts), 28);
    });

    test('averageCycleLength falls back when data is insufficient', () {
      expect(
        MedicalCalculator.averageCycleLength(
          [DateTime(2027, 1, 1)],
          fallback: 30,
        ),
        30,
      );
    });

    test('predictNextPeriod uses the average cycle', () {
      final starts = [
        DateTime(2027, 1, 1),
        DateTime(2027, 1, 29),
        DateTime(2027, 2, 26),
      ];
      expect(
        MedicalCalculator.predictNextPeriod(starts),
        DateTime(2027, 3, 26),
      );
    });

    test('shouldAlertHospital is false with fewer than 3 contractions', () {
      expect(MedicalCalculator.shouldAlertHospital([]), false);
    });

    test('shouldAlertHospital is false when the pattern is too short', () {
      final base = DateTime(2027, 1, 1, 10);
      final contractions = [
        _contraction(base),
        _contraction(base.add(const Duration(minutes: 4))),
        _contraction(base.add(const Duration(minutes: 8))),
      ];
      expect(
        MedicalCalculator.shouldAlertHospital(contractions),
        false,
      );
    });

    test('shouldAlertHospital is true after one hour of 5-1-1', () {
      final base = DateTime(2027, 1, 1, 10);
      final contractions = [
        for (var i = 0; i <= 12; i++)
          _contraction(base.add(Duration(minutes: i * 5))),
      ];
      expect(
        MedicalCalculator.shouldAlertHospital(contractions),
        true,
      );
    });

    test('shouldAlertHospital requires a continuous run', () {
      final base = DateTime(2027, 1, 1, 10);
      final contractions = [
        for (var i = 0; i <= 12; i++)
          _contraction(base.add(Duration(minutes: i * 5))),
        // فاصل 30 دقيقة يقطع النمط
        _contraction(base.add(const Duration(minutes: 90))),
      ];
      expect(
        MedicalCalculator.shouldAlertHospital(contractions),
        false,
      );
    });

    test('shouldAlertHospital requires contractions of at least 60s', () {
      final base = DateTime(2027, 1, 1, 10);
      final contractions = [
        for (var i = 0; i <= 12; i++)
          Contraction(
            startTime: base.add(Duration(minutes: i * 5)),
            endTime: base.add(Duration(minutes: i * 5, seconds: 30)),
            durationSeconds: 30,
            intervalSeconds: i == 0 ? 0 : 300,
            intensity: 2,
          ),
      ];
      expect(
        MedicalCalculator.shouldAlertHospital(contractions),
        false,
      );
    });

    test('epdsScore sums answers without reversal', () {
      expect(MedicalCalculator.epdsScore(List.filled(10, 0)), 0);
      expect(MedicalCalculator.epdsScore(List.filled(10, 3)), 30);
      expect(
        MedicalCalculator.epdsScore([0, 1, 2, 3, 0, 1, 2, 3, 0, 1]),
        13,
      );
    });

    test('epdsScore validates input', () {
      expect(
        () => MedicalCalculator.epdsScore([0, 1, 2]),
        throwsArgumentError,
      );
      expect(
        () => MedicalCalculator.epdsScore([0, 1, 2, 3, 4, 0, 0, 0, 0, 0]),
        throwsArgumentError,
      );
    });

    test('epds thresholds and self-harm alert', () {
      expect(MedicalCalculator.epdsNeedsSupport(12), false);
      expect(MedicalCalculator.epdsNeedsSupport(13), true);
      expect(
        MedicalCalculator.epdsSelfHarmAlert([0, 0, 0, 0, 0, 0, 0, 0, 0, 1]),
        true,
      );
      expect(
        MedicalCalculator.epdsSelfHarmAlert([0, 0, 0, 0, 0, 0, 0, 0, 0, 0]),
        false,
      );
    });
  });
}

Contraction _contraction(DateTime start) {
  return Contraction(
    startTime: start,
    endTime: start.add(const Duration(seconds: 65)),
    durationSeconds: 65,
    intervalSeconds: 0,
    intensity: 2,
  );
}
