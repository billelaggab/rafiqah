// lib/main.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app/app.dart';
import 'core/services/ad_service.dart';
import 'core/services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('ar');

  try {
    await NotificationService.instance.init();
  } catch (e, st) {
    debugPrint('Notification init failed: $e\n$st');
  }

  runApp(const ProviderScope(child: RafiqahApp()));

  // موافقة UMP (GDPR/EEA) بعد ظهور الواجهة، وقبل أي تحميل إعلان.
  // لا نُعطّل تشغيل التطبيق بانتظار الشبكة.
  unawaited(_initializeAdsWithConsent());
}

Future<void> _initializeAdsWithConsent() async {
  var allowed = false;
  try {
    final consent = ConsentInformation.instance;
    final completer = Completer<void>();

    consent.requestConsentInfoUpdate(
      ConsentRequestParameters(),
      () async {
        try {
          await ConsentForm.loadAndShowConsentFormIfRequired((error) async {
            if (error != null) {
              debugPrint('Consent form error: $error');
            }
            if (await consent.canRequestAds()) {
              await MobileAds.instance.initialize();
              allowed = true;
            }
          });
        } catch (e, st) {
          debugPrint('Consent form failed: $e\n$st');
        } finally {
          if (!completer.isCompleted) completer.complete();
        }
      },
      (error) {
        debugPrint('Consent update failed: $error');
        if (!completer.isCompleted) completer.complete();
      },
    );

    await completer.future.timeout(
      const Duration(seconds: 8),
      onTimeout: () => debugPrint('Consent timed out; ads disabled for now'),
    );
  } catch (e, st) {
    debugPrint('Ads init failed: $e\n$st');
  } finally {
    AdService.instance.markConsentHandled(allowed: allowed);
  }
}
