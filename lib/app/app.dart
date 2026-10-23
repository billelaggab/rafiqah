// lib/app/app.dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:rafiqah/core/database/database_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafiqah/features/mode_selector/domain/app_mode.dart';
import 'package:rafiqah/features/mode_selector/presentation/providers/app_mode_notifier.dart';
import 'package:rafiqah/features/mode_selector/presentation/screens/mode_selector_screen.dart';
import 'package:rafiqah/features/pregnancy/presentation/screens/pregnancy_dashboard_screen.dart';
import 'package:rafiqah/features/postpartum/presentation/screens/postpartum_dashboard_screen.dart';
import 'package:rafiqah/features/cycle_tracker/presentation/screens/cycle_tracker_screen.dart';
import 'package:rafiqah/features/ttc/presentation/screens/ttc_screen.dart';
import 'package:rafiqah/features/settings/presentation/screens/settings_screen.dart';
import 'package:rafiqah/features/onboarding/presentation/screens/disclaimer_screen.dart';
import 'package:rafiqah/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'theme/app_theme.dart';

class RafiqahApp extends ConsumerStatefulWidget {
  const RafiqahApp({super.key});

  @override
  ConsumerState<RafiqahApp> createState() => _RafiqahAppState();
}

class _RafiqahAppState extends ConsumerState<RafiqahApp> {
  bool _disclaimerAccepted = false;
  bool _onboarded = false;
  bool _modeChosen = false;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      final db = ref.read(databaseProvider);
      final p = await db.userProfileDao.getProfile();
      setState(() {
        _disclaimerAccepted = p?.disclaimerAccepted ?? false;
        _onboarded = p?.lmpDate != null;
        _modeChosen = (p?.currentMode.isNotEmpty ?? false);
        _loading = false;
      });
    } catch (e, st) {
      debugPrint('Init error: $e\n$st');
      setState(() {
        _error = '$e';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }
    if (_error != null) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text('خطأ في البدء:\n$_error', textAlign: TextAlign.center),
            ),
          ),
        ),
      );
    }
    if (!_disclaimerAccepted) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('ar'), Locale('en')],
        home: DisclaimerScreen(onAccepted: () {
          setState(() => _disclaimerAccepted = true);
        }),
      );
    }
    if (!_onboarded) {
      return MaterialApp(
        theme: AppTheme.light(),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('ar'), Locale('en')],
        home: OnboardingScreen(onDone: () {
          setState(() => _onboarded = true);
        }),
      );
    }
    if (!_modeChosen) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('ar'), Locale('en')],
        home: ModeSelectorScreen(onSelected: () {
          setState(() => _modeChosen = true);
        }),
      );
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'رفيقة',
      theme: AppTheme.light(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('ar'), Locale('en')],
      builder: (context, child) => Directionality(
        textDirection: TextDirection.rtl,
        child: child!,
      ),
      home: const HomeShell(),
    );
  }
}

class HomeShell extends ConsumerWidget {
  const HomeShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final modeAsync = ref.watch(appModeProvider);
    return modeAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('خطأ: $e'))),
      data: (mode) => _ModeHome(mode: mode),
    );
  }
}

class _ModeHome extends ConsumerWidget {
  const _ModeHome({required this.mode});
  final AppMode mode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget body;
    switch (mode.id) {
      case 'cycle':
        body = const CycleTrackerScreen();
        break;
      case 'ttc':
        body = const TtcScreen();
        break;
      case 'pregnancy':
        body = const PregnancyDashboardScreen();
        break;
      case 'postpartum':
        body = const PostpartumDashboardScreen();
        break;
      default:
        body = const PregnancyDashboardScreen();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('رفيقة — ${mode.labelAr}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (id) {
              final m = AppMode.fromId(id);
              ref.read(appModeProvider.notifier).setMode(m);
            },
            itemBuilder: (_) => AppMode.values
                .map((m) => PopupMenuItem(value: m.id, child: Text('${m.emoji} ${m.labelAr}')))
                .toList(),
          ),
        ],
      ),
      body: body,
    );
  }
}