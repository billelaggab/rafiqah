// lib/core/utils/medical_calculator.dart
import 'package:flutter/foundation.dart';

/// حاسبة المعادلات الطبية المعتمدة في تطبيق رفيقة.
class MedicalCalculator {
  MedicalCalculator._();

  static const int _minCycleLength = 20;
  static const int _maxCycleLength = 45;

  /// قاعدة Naegele المعدلة فسيولوجيًا: EDD = LMP + 280 يوم + (طول الدورة - 28)
  static DateTime calculateEDD({
    required DateTime lmp,
    required int cycleLength,
  }) {
    _validateCycleLength(cycleLength);
    final adjustment = cycleLength - 28;
    // حساب تقويمي (وليس Duration) لتجنب انزياح التوقيت الصيفي.
    return DateTime(lmp.year, lmp.month, lmp.day + 280 + adjustment);
  }

  /// حساب يوم التبويض ونافذة الخصوبة (ثبات الطور الأصفري 14 يوم)
  static ({DateTime ovulationDay, DateTime fertileStart, DateTime fertileEnd})
      calculateFertileWindow({
    required DateTime periodStartDate,
    required int cycleLength,
  }) {
    _validateCycleLength(cycleLength);
    final start = DateTime(
      periodStartDate.year,
      periodStartDate.month,
      periodStartDate.day,
    );
    final ovulationDay =
        DateTime(start.year, start.month, start.day + cycleLength - 14);
    final fertileStart =
        DateTime(ovulationDay.year, ovulationDay.month, ovulationDay.day - 5);
    final fertileEnd =
        DateTime(ovulationDay.year, ovulationDay.month, ovulationDay.day + 1);
    return (
      ovulationDay: ovulationDay,
      fertileStart: fertileStart,
      fertileEnd: fertileEnd,
    );
  }

  /// تجميع أيام النزيف المتتالية في بدايات دورات.
  ///
  /// كل يوم مسجّل ليس بالضرورة بداية دورة: الأيام المتتالية (فاصل يوم واحد
  /// على الأكثر) تُعتبر ضمن الدورة نفسها.
  static List<DateTime> periodStarts(Iterable<DateTime> loggedDays) {
    final days = loggedDays
        .map((d) => DateTime(d.year, d.month, d.day))
        .toSet()
        .toList()
      ..sort();
    final starts = <DateTime>[];
    DateTime? previous;
    for (final day in days) {
      if (previous == null || _dayDifference(day, previous) > 1) {
        starts.add(day);
      }
      previous = day;
    }
    return starts;
  }

  /// متوسط طول الدورة من آخر 3-6 فواصل منطقية (15-60 يومًا).
  static int averageCycleLength(
    List<DateTime> starts, {
    int fallback = 28,
  }) {
    if (starts.length < 2) return fallback;
    final gaps = <int>[];
    for (var i = 1; i < starts.length; i++) {
      final gap = _dayDifference(starts[i], starts[i - 1]);
      if (gap >= 15 && gap <= 60) gaps.add(gap);
    }
    if (gaps.isEmpty) return fallback;
    final recent = gaps.length > 6 ? gaps.sublist(gaps.length - 6) : gaps;
    return (recent.reduce((a, b) => a + b) / recent.length).round();
  }

  /// التحقق من تحقق قاعدة 5-1-1 للتوجه للمستشفى.
  ///
  /// يشترط نمطًا متواصلًا من الانقباضات (فاصل ≤ 5 دقائق) لمدة ساعة كاملة،
  /// مع مدة ≥ 60 ثانية لكل انقباضة. أي فاصل أطول يقطع النمط ويبدأ العد من جديد.
  static bool shouldAlertHospital(List<Contraction> contractions) {
    if (contractions.length < 3) return false;

    final sorted = [...contractions]
      ..sort((a, b) => a.startTime.compareTo(b.startTime));

    var runStart = sorted.length - 1;
    while (runStart > 0) {
      final gap = sorted[runStart].startTime
          .difference(sorted[runStart - 1].startTime);
      if (gap > const Duration(minutes: 5)) break;
      runStart--;
    }

    final run = sorted.sublist(runStart);
    if (run.length < 3) return false;
    if (run.any((c) => c.durationSeconds < 60)) return false;

    final span = run.last.endTime.difference(run.first.startTime);
    return span >= const Duration(hours: 1);
  }

  /// نتيجة EPDS (0-30).
  ///
  /// [answers] هي الدرجات الفعلية لكل بند (0 = الأفضل، 3 = الأسوأ)،
  /// بنفس ترتيب خيارات النموذج المعتمد. لا يوجد "عكس" هنا لتجنب الأخطاء.
  static int epdsScore(List<int> answers) {
    if (answers.length != 10) {
      throw ArgumentError('EPDS requires exactly 10 answers');
    }
    var total = 0;
    for (final value in answers) {
      if (value < 0 || value > 3) {
        throw ArgumentError('EPDS answers must be between 0 and 3');
      }
      total += value;
    }
    return total;
  }

  /// هل تحتاج المستخدمة توجيهًا لمختص؟ (حد التنبيه المعتمد: ≥ 13)
  static bool epdsNeedsSupport(int score) => score >= 13;

  /// أي إجابة غير صفرية على بند إيذاء النفس (البند 10) تستوجب تدخلًا فوريًا.
  static bool epdsSelfHarmAlert(List<int> answers) =>
      answers.length == 10 && answers[9] > 0;

  /// تنبؤ موعد الدورة القادمة بناءً على متوسط آخر 3-6 دورات.
  static DateTime predictNextPeriod(List<DateTime> periodStarts) {
    if (periodStarts.isEmpty) {
      throw ArgumentError('No period starts provided');
    }
    final sorted = [...periodStarts]..sort();
    final average = averageCycleLength(sorted);
    return DateTime(
      sorted.last.year,
      sorted.last.month,
      sorted.last.day + average,
    );
  }

  /// فرق الأيام بين تاريخين مع تجاهل الوقت والتوقيت الصيفي.
  static int _dayDifference(DateTime a, DateTime b) {
    final first = DateTime.utc(a.year, a.month, a.day);
    final second = DateTime.utc(b.year, b.month, b.day);
    return first.difference(second).inDays;
  }

  static void _validateCycleLength(int cycleLength) {
    if (cycleLength < _minCycleLength || cycleLength > _maxCycleLength) {
      throw ArgumentError.value(
        cycleLength,
        'cycleLength',
        'Must be between $_minCycleLength and $_maxCycleLength days',
      );
    }
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
