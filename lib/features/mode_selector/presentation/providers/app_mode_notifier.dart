// lib/features/mode_selector/presentation/providers/app_mode_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafiqah/core/database/database_provider.dart';
import 'package:rafiqah/core/utils/constants.dart';
import 'package:rafiqah/features/mode_selector/data/mode_repository.dart';
import 'package:rafiqah/features/mode_selector/domain/app_mode.dart';

final modeRepositoryProvider = Provider<ModeRepository>((ref) {
  return ModeRepository(ref.watch(databaseProvider));
});

final appModeProvider = AsyncNotifierProvider<AppModeNotifier, AppMode>(
  AppModeNotifier.new,
);

class AppModeNotifier extends AsyncNotifier<AppMode> {
  @override
  Future<AppMode> build() async {
    return ref.watch(modeRepositoryProvider).getCurrentMode();
  }

  Future<void> setMode(AppMode mode) async {
    await ref.read(modeRepositoryProvider).setMode(mode);
    state = AsyncValue.data(mode);
  }
}

// Convenience provider for current mode id string
final currentModeIdProvider = Provider<String>((ref) {
  return ref.watch(appModeProvider).valueOrNull?.id ?? AppConstants.modePregnancy;
});