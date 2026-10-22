// lib/core/utils/constants.dart
class AppConstants {
  AppConstants._();

  static const String appName = 'رفيقة';
  static const String appNameEn = 'Rafiqah';

  // AdMob test IDs
  static const String admobBannerTest = 'ca-app-pub-3940256099942544/6300978111';
  static const String admobInterstitialTest = 'ca-app-pub-3940256099942544/1033173712';

  // Backup
  static const String backupFileName = 'rafiqah_secure_backup.enc';

  // Modes
  static const String modeCycle = 'cycle';
  static const String modeTtc = 'ttc';
  static const String modePregnancy = 'pregnancy';
  static const String modePostpartum = 'postpartum';

  // Baby log types
  static const String logFeedLeft = 'feed_left';
  static const String logFeedRight = 'feed_right';
  static const String logBottle = 'bottle';
  static const String logDiaper = 'diaper';
  static const String logSleep = 'sleep';

  // Kick counter target
  static const int kickTarget = 10;
  static const Duration kickWindow = Duration(hours: 2);
}