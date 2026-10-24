// lib/core/services/ad_service.dart
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../utils/constants.dart';

class AdService {
  AdService._();
  static final AdService instance = AdService._();

  final Completer<void> _ready = Completer<void>();
  bool _adsAllowed = false;

  /// يكتمل بعد انتهاء تدفق الموافقة (سواء سُمح بالإعلانات أم لا).
  ///
  /// لا نُهيّئ الإعلانات قبل موافقة UMP، ولا نُعطّل تشغيل التطبيق بانتظارها.
  Future<void> get ready => _ready.future;

  bool get adsAllowed => _adsAllowed;

  /// تُستدعى مرة واحدة من `main` بعد انتهاء تدفق الموافقة.
  void markConsentHandled({required bool allowed}) {
    _adsAllowed = allowed;
    if (!_ready.isCompleted) _ready.complete();
  }

  String get _bannerId => kDebugMode
      ? AppConstants.admobBannerTest
      : AppConstants.admobBannerProd;

  BannerAd? createBanner({
    required void Function(Ad) onLoaded,
    void Function(LoadAdError)? onFailed,
  }) {
    if (!_adsAllowed) return null;
    return BannerAd(
      adUnitId: _bannerId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: onLoaded,
        onAdFailedToLoad: (ad, error) {
          debugPrint('Banner failed: $error');
          ad.dispose();
          onFailed?.call(error);
        },
      ),
    )..load();
  }
}
