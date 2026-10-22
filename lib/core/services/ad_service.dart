// lib/core/services/ad_service.dart
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'ad_cooldown_manager.dart';

class AdService {
  AdService._();
  static final AdService instance = AdService._();

  static const _bannerId = 'ca-app-pub-3940256099942544/6300978111';
  static const _interstitialId = 'ca-app-pub-3940256099942544/1033173712';

  BannerAd createBanner({required void Function(Ad) onLoaded}) {
    return BannerAd(
      adUnitId: _bannerId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: onLoaded,
        onAdFailedToLoad: (ad, err) {
          debugPrint('Banner failed: $err');
          ad.dispose();
        },
      ),
    )..load();
  }

  Future<void> showInterstitialIfAllowed() async {
    if (!AdCooldownManager.instance.canShowInterstitial) return;
    await InterstitialAd.load(
      adUnitId: _interstitialId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.show();
          AdCooldownManager.instance.recordInterstitialShown();
        },
        onAdFailedToLoad: (err) => debugPrint('Interstitial failed: $err'),
      ),
    );
  }
}