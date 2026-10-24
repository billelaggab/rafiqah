// lib/app/app.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rafiqah/app/theme/app_colors.dart';
import 'package:rafiqah/app/theme/app_text_styles.dart';
import 'package:rafiqah/app/theme/app_theme.dart';
import 'package:rafiqah/app/bootstrap_provider.dart';
import 'package:rafiqah/features/cycle_tracker/presentation/screens/cycle_tracker_screen.dart';
import 'package:rafiqah/features/mode_selector/domain/app_mode.dart';
import 'package:rafiqah/features/mode_selector/presentation/app_mode_icons.dart';
import 'package:rafiqah/features/mode_selector/presentation/providers/app_mode_notifier.dart';
import 'package:rafiqah/features/mode_selector/presentation/screens/mode_selector_screen.dart';
import 'package:rafiqah/features/onboarding/presentation/screens/disclaimer_screen.dart';
import 'package:rafiqah/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:rafiqah/features/postpartum/presentation/screens/postpartum_dashboard_screen.dart';
import 'package:rafiqah/features/pregnancy/presentation/screens/pregnancy_dashboard_screen.dart';
import 'package:rafiqah/features/settings/presentation/screens/settings_screen.dart';
import 'package:rafiqah/features/ttc/presentation/screens/ttc_screen.dart';

class RafiqahApp extends ConsumerWidget {
  const RafiqahApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bootstrap = ref.watch(bootstrapProvider);

    return bootstrap.when(
      loading: () => _appShell(
        const Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
      error: (error, _) => _appShell(
        Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    'تعذر بدء التطبيق:\n$error',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        ref.read(bootstrapProvider.notifier).retry(),
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      data: (state) {
        if (!state.disclaimerAccepted) {
          return _appShell(
            DisclaimerScreen(
              onAccepted: () =>
                  ref.read(bootstrapProvider.notifier).acceptDisclaimer(),
            ),
          );
        }
        if (!state.onboardingCompleted) {
          return _appShell(
            OnboardingScreen(
              onDone: () => ref.read(bootstrapProvider.notifier).refresh(),
            ),
          );
        }
        if (!state.modeChosen) {
          return _appShell(
            ModeSelectorScreen(
              onSelected: () => ref.read(bootstrapProvider.notifier).refresh(),
            ),
          );
        }
        return _appShell(const HomeShell());
      },
    );
  }

  Widget _appShell(Widget home) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'رفيقة',
      theme: AppTheme.light(),
      locale: const Locale('ar'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('ar')],
      builder: (context, child) => Directionality(
        textDirection: TextDirection.rtl,
        child: child ?? const SizedBox.shrink(),
      ),
      home: home,
    );
  }
}

class HomeShell extends ConsumerWidget {
  const HomeShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final modeAsync = ref.watch(appModeProvider);
    return modeAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('تعذر تحديد الوضع: $e', textAlign: TextAlign.center),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => ref.invalidate(appModeProvider),
                child: const Text('إعادة المحاولة'),
              ),
            ],
          ),
        ),
      ),
      data: (mode) => _ModeHome(mode: mode),
    );
  }
}

class _ModeHome extends ConsumerWidget {
  const _ModeHome({required this.mode});
  final AppMode mode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Widget body = switch (mode.id) {
      'cycle' => const CycleTrackerScreen(),
      'ttc' => const TtcScreen(),
      'postpartum' => const PostpartumDashboardScreen(),
      _ => const PregnancyDashboardScreen(),
    };

    final currentIndex = AppMode.values.indexWhere((m) => m.id == mode.id);

    return Scaffold(
      appBar: AppBar(
        title: Text('رفيقة — ${mode.labelAr}'),
        titleTextStyle: AppTextStyles.titleLarge.copyWith(color: Colors.white),
        foregroundColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        flexibleSpace: const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.gradientStart, AppColors.gradientEnd],
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'الإعدادات',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex < 0 ? 0 : currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        onTap: (i) async {
          try {
            await ref.read(appModeProvider.notifier).setMode(AppMode.values[i]);
          } catch (e) {
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('تعذر تغيير الوضع: $e')),
            );
          }
        },
        items: AppMode.values
            .map(
              (m) => BottomNavigationBarItem(
                icon: Icon(m.icon),
                label: m.labelAr,
                tooltip: m.labelAr,
              ),
            )
            .toList(),
      ),
    );
  }
}
