// lib/app/bootstrap_provider.dart
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/database/database_provider.dart';

class BootstrapState {
  const BootstrapState({
    required this.disclaimerAccepted,
    required this.onboardingCompleted,
    required this.modeChosen,
  });

  final bool disclaimerAccepted;
  final bool onboardingCompleted;
  final bool modeChosen;
}

class BootstrapNotifier extends AsyncNotifier<BootstrapState> {
  @override
  Future<BootstrapState> build() => _load();

  Future<BootstrapState> _load() async {
    final db = ref.watch(databaseProvider);
    try {
      await db.ensureFoodSeeded();
    } catch (e, st) {
      // لا نُفشل تشغيل التطبيق بسبب بيانات مرجعية، لكن نُسجّل الخطأ.
      debugPrint('Food seeding failed: $e\n$st');
    }
    final profile = await db.userProfileDao.getProfile();
    return BootstrapState(
      disclaimerAccepted: profile?.disclaimerAccepted ?? false,
      onboardingCompleted: profile?.onboardingCompleted ?? false,
      modeChosen: profile?.currentMode.isNotEmpty ?? false,
    );
  }

  /// يعيد قراءة الحالة دون إظهار شاشة تحميل (لتجنب الوميض).
  Future<void> refresh() async {
    state = await AsyncValue.guard(_load);
  }

  Future<void> acceptDisclaimer() async {
    await ref.read(databaseProvider).userProfileDao.acceptDisclaimer();
    await refresh();
  }

  Future<void> retry() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
  }
}

final bootstrapProvider =
    AsyncNotifierProvider<BootstrapNotifier, BootstrapState>(
  BootstrapNotifier.new,
);
