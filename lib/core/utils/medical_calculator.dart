// lib/core/utils/medical_calculator.dart
import 'package:flutter/foundation.dart';

/// حاسبة المعادلات الطبية المعتمدة في تطبيق رفيقة.
class MedicalCalculator {
  MedicalCalculator._();

  /// قاعدة Naegele المعدلة فسيولوجيًا: EDD = LMP + 280 يوم + (طول الدورة - 28)
  static DateTime calculateEDD({
    required DateTime lmp,
    required int cycleLength,
  }) {
    final int adjustment = cycleLength - 28;
    return lmp.add(Duration(days: 280 + adjustment));
  }

  /// حساب يوم التبويض ونافذة الخصوبة (ثبات الطور الأصفري 14 يوم)
  static ({DateTime ovulationDay, DateTime fertileStart, DateTime fertileEnd})
      calculateFertileWindow({
    required DateTime periodStartDate,
    required int cycleLength,
  }) {
    final ovulationDay = periodStartDate.add(Duration(days: cycleLength - 14));
    final fertileStart = ovulationDay.subtract(const Duration(days: 5));
    final fertileEnd = ovulationDay.add(const Duration(days: 1));
    return (
      ovulationDay: ovulationDay,
      fertileStart: fertileStart,
      fertileEnd: fertileEnd,
    );
  }

  /// التحقق من تحقق قاعدة 5-1-1 للتوجه للمستشفى
  static bool shouldAlertHospital(List<Contraction> contractions) {
    if (contractions.length < 3) return false;
    final recent = contractions.sublist(contractions.length - 3);
    final allLongEnough = recent.every((c) => c.durationSeconds >= 60);
    final allCloseEnough = recent.every((c) => c.intervalSeconds <= 300);
    // النمط must have persisted for at least an hour overall
    final totalSpan =
        contractions.last.endTime.difference(contractions.first.startTime);
    final spansOneHour = totalSpan >= const Duration(hours: 1);
    return allLongEnough && allCloseEnough && spansOneHour;
  }

  /// حساب نتيجة EPDS (0-30)
  static int epdsScore(List<int> answers) {
    // أسئلة 1,2,4 (index 0,1,3) عكسية: 0->3,1->2,2->1,3->0
    int total = 0;
    for (int i = 0; i < answers.length; i++) {
      int v = answers[i];
      if (i == 0 || i == 1 || i == 3) {
        v = 3 - v;
      }
      total += v;
    }
    return total;
  }

  /// تنبؤ موعد الدورة القادمة بناءً على متوسط آخر 3-6 دورات
  static DateTime predictNextPeriod(List<DateTime> periodStarts) {
    if (periodStarts.isEmpty) {
      throw ArgumentError('No period starts provided');
    }
    if (periodStarts.length == 1) {
      return periodStarts.last.add(const Duration(days: 28));
    }
    final sorted = [...periodStarts]..sort();
    final gaps = <int>[];
    for (int i = 1; i < sorted.length; i++) {
      gaps.add(sorted[i].difference(sorted[i - 1]).inDays);
    }
    // استخدام آخر 3-6
    final recent = gaps.length > 6 ? gaps.sublist(gaps.length - 6) : gaps;
    final avg = (recent.reduce((a, b) => a + b) / recent.length).round();
    return sorted.last.add(Duration(days: avg));
  }
}

/// نموذج انقباضة (للحسابات والتخزين)
@immutable
class Contraction {
  final DateTime startTime;
  final DateTime endTime;
  final int durationSeconds;
  final int intervalSeconds;
  final int intensity;

  const Contraction({
    required this.startTime,
    required this.endTime,
    required this.durationSeconds,
    required this.intervalSeconds,
    required this.intensity,
  });
}