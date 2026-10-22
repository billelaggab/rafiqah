// lib/core/services/ad_cooldown_manager.dart
class AdCooldownManager {
  AdCooldownManager._();
  static final AdCooldownManager instance = AdCooldownManager._();

  static const _cooldownDuration = Duration(minutes: 4);
  DateTime? _lastInterstitialShown;

  bool get canShowInterstitial {
    if (_lastInterstitialShown == null) return true;
    return DateTime.now().difference(_lastInterstitialShown!) >= _cooldownDuration;
  }

  void recordInterstitialShown() {
    _lastInterstitialShown = DateTime.now();
  }
}