import 'package:flutter_test/flutter_test.dart';
import 'package:rafiqah/core/utils/medical_calculator.dart';

void main() {
  group('MedicalCalculator', () {
    test('calculateEDD', () {
      final lmp = DateTime(2027, 1, 1);
      expect(MedicalCalculator.calculateEDD(lmp: lmp, cycleLength: 28),
          DateTime(2027, 10, 8));
      expect(MedicalCalculator.calculateEDD(lmp: lmp, cycleLength: 32),
          DateTime(2027, 10, 12));
      expect(MedicalCalculator.calculateEDD(lmp: lmp, cycleLength: 25),
          DateTime(2027, 10, 5));
    });

    test('fertile window', () {
      final p = DateTime(2027, 1, 1);
      final r = MedicalCalculator.calculateFertileWindow(periodStartDate: p, cycleLength: 28);
      expect(r.ovulationDay, DateTime(2027, 1, 15));
    });

    test('shouldAlertHospital false with <3', () {
      expect(MedicalCalculator.shouldAlertHospital([]), false);
    });

    test('shouldAlertHospital true scenario', () {
      final base = DateTime(2027, 1, 1, 10, 0);
      // build manually
      final c1 = Contraction(startTime: base, endTime: base.add(const Duration(seconds: 65)), durationSeconds: 65, intervalSeconds: 0, intensity: 3);
      final c2 = Contraction(startTime: base.add(const Duration(minutes: 4)), endTime: base.add(const Duration(minutes: 4, seconds: 65)), durationSeconds: 65, intervalSeconds: 240, intensity: 3);
      final c3 = Contraction(startTime: base.add(const Duration(minutes: 8)), endTime: base.add(const Duration(minutes: 8, seconds: 65)), durationSeconds: 65, intervalSeconds: 240, intensity: 3);
      // interval between c2 and c3 is 4 min (240s) ok; c1->c2 4 min ok. span 8 min < 1 hour -> false
      expect(MedicalCalculator.shouldAlertHospital([c1, c2, c3]), false);
    });

    test('shouldAlertHospital true scenario', () {
      final base = DateTime(2027, 1, 1, 10, 0);
      final c1 = Contraction(startTime: base, endTime: base.add(const Duration(seconds: 65)), durationSeconds: 65, intervalSeconds: 0, intensity: 3);
      final c2 = Contraction(startTime: base.add(const Duration(minutes: 4)), endTime: base.add(const Duration(minutes: 4, seconds: 65)), durationSeconds: 65, intervalSeconds: 240, intensity: 3);
      final c3 = Contraction(startTime: base.add(const Duration(hours: 1, minutes: 4)), endTime: base.add(const Duration(hours: 1, minutes: 4, seconds: 65)), durationSeconds: 65, intervalSeconds: 240, intensity: 3);
      expect(MedicalCalculator.shouldAlertHospital([c1, c2, c3]), true);
    });

    test('epds score', () {
      final answers = [0,0,0,0,0,0,0,0,0,0];
      expect(MedicalCalculator.epdsScore(answers), 9); // 3 reverse-scored items
    });
  });
}