// lib/core/utils/constants.dart
class AppConstants {
  AppConstants._();

  static const String appName = 'رفيقة';
  static const String appNameEn = 'Rafiqah';

  /// يُمرَّر عبر `--dart-define=PRIVACY_POLICY_URL=...` عند النشر.
  static const String privacyPolicyUrl = String.fromEnvironment(
    'PRIVACY_POLICY_URL',
    defaultValue: 'https://rafiqah.app/privacy',
  );

  // AdMob — القيم التجريبية تُستخدم في وضع التطوير فقط.
  static const String admobBannerTest = 'ca-app-pub-3940256099942544/6300978111';
  static const String admobBannerProd = String.fromEnvironment(
    'ADMOB_BANNER_ID',
    defaultValue: admobBannerTest,
  );

  // Backup
  // اسم ملف النسخة الاحتياطية معرّف في BackupService.

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
