# Test Plan — Rafiqah (Sprint 4)

## Offline 100%
- Enable airplane mode
- Verify: cycle tracker, pregnancy dashboard, kick counter, contraction timer, food directory, TTC, baby tracker, EPDS, settings all functional
- Verify: backup/restore show graceful error (no crash)
- Verify: ads show placeholder/error gracefully

## Device Matrix
- [ ] Device A: small screen (5"), Android 10
- [ ] Device B: medium screen (6.5"), Android 12
- [ ] Device C: large screen (7"), Android 14

## Functional Scenarios
- EDD: LMP 2027-01-01, cycle 28 → 2027-10-08; cycle 32 → 2027-10-12; cycle 25 → 2027-10-05
- 5-1-1: 3 contractions ≥60s, ≤5min apart, span ≥1h → alert
- EPDS: score ≥13 → supportive guidance
- Kick counter: 10 kicks in 2h → no alert; <10 → alert
- Fertile window: ovulation = periodStart + cycleLength - 14

## Performance
- Timer screens: <16ms/frame (60fps)
- App launch: <2s to home
- Food search: <100ms
- No memory leaks (DevTools) on kick/contraction timers

## Accessibility
- Font scaling (large text) doesn't break layouts
- Sufficient contrast
- RTL correctness