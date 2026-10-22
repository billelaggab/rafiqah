# ✅ Pre-Launch Checklist — Rafiqah

## Build
- [ ] `flutter analyze` = 0 issues
- [ ] `flutter test` = 0 failures
- [ ] `flutter build appbundle --release` succeeds
- [ ] Replace AdMob TEST IDs with PRODUCTION IDs (banner + interstitial)
- [ ] Place 1024×1024 icon at `assets/icon/app_icon.png` → `dart run flutter_launcher_icons`
- [ ] Bump version in `pubspec.yaml` (version: x.y.z+build)

## Legal / Compliance
- [ ] Publish `privacy_policy.html` to a public URL; add URL in Play Console
- [ ] Fill Health Declaration form (see `HEALTH_DECLARATION.md`)
- [ ] Medical disclaimer shows on first launch, non-dismissible
- [ ] "Delete all my data" button works and removes everything
- [ ] No health data shared with third parties
- [ ] App works 100% without Google login (Drive is optional)

## Medical
- [ ] EDD (Modified Naegele) verified against known medical examples
- [ ] Ovulation / fertile window verified
- [ ] 5-1-1 algorithm tested with multiple realistic scenarios
- [ ] EPDS scoring verified (reverse items 1,2,4)
- [ ] All medical text reviewed by an OB/GYN

## Ads
- [ ] No ads in: KickCounterScreen, ContractionTimerScreen, EmergencyRoutingScreen, EPDSScreen
- [ ] AdCooldownManager enforces ≥ 4 min between interstitials
- [ ] Banner only on article/food screens, size AdSize.banner
- [ ] Native ads match app theme

## Offline
- [ ] All core features work with airplane mode ON
- [ ] No network calls in core logic (only backup/ads)
- [ ] DB seeding (foods) works on first launch

## Testing
- [ ] Test on ≥ 3 devices with different screen sizes (5"-7")
- [ ] Accessibility check (font scaling, contrast)
- [ ] Battery profiling for timers (kick counter, contraction)
- [ ] No memory leaks (DevTools)

## Play Console
- [ ] App icon + 8 screenshots uploaded
- [ ] Store listing (title, short/long desc, keywords) filled
- [ ] Content rating questionnaire completed
- [ ] Closed testing track with 10–20 beta users
- [ ] Privacy policy URL added

## Post-Launch
- [ ] Monitor crash reports (Firebase Crashlytics optional)
- [ ] Respond to reviews
- [ ] Plan v1.1 (remaining roadmap items)