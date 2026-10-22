// lib/features/baby_tracker/domain/who_growth.dart
/// WHO Weight-for-age (kg) percentiles 3/50/97 for 0-12 months (simplified).
class WhoGrowth {
  final int month;
  final double p3;
  final double p50;
  final double p97;
  const WhoGrowth(this.month, this.p3, this.p50, this.p97);
}

// Boys
const whoBoysWeight = <WhoGrowth>[
  WhoGrowth(0, 2.5, 3.3, 4.4),
  WhoGrowth(1, 3.4, 4.5, 5.8),
  WhoGrowth(2, 4.3, 5.6, 7.1),
  WhoGrowth(3, 5.0, 6.4, 8.0),
  WhoGrowth(4, 5.6, 7.0, 8.7),
  WhoGrowth(5, 6.0, 7.5, 9.3),
  WhoGrowth(6, 6.4, 7.9, 9.8),
  WhoGrowth(7, 6.7, 8.3, 10.3),
  WhoGrowth(8, 7.0, 8.6, 10.7),
  WhoGrowth(9, 7.2, 8.9, 11.0),
  WhoGrowth(10, 7.5, 9.2, 11.4),
  WhoGrowth(11, 7.7, 9.4, 11.7),
  WhoGrowth(12, 7.9, 9.6, 12.0),
];

// Girls
const whoGirlsWeight = <WhoGrowth>[
  WhoGrowth(0, 2.4, 3.2, 4.2),
  WhoGrowth(1, 3.2, 4.2, 5.5),
  WhoGrowth(2, 3.9, 5.1, 6.6),
  WhoGrowth(3, 4.5, 5.8, 7.5),
  WhoGrowth(4, 5.0, 6.4, 8.2),
  WhoGrowth(5, 5.4, 6.9, 8.8),
  WhoGrowth(6, 5.7, 7.3, 9.3),
  WhoGrowth(7, 6.0, 7.6, 9.8),
  WhoGrowth(8, 6.3, 7.9, 10.2),
  WhoGrowth(9, 6.5, 8.2, 10.5),
  WhoGrowth(10, 6.7, 8.5, 10.9),
  WhoGrowth(11, 6.9, 8.7, 11.2),
  WhoGrowth(12, 7.1, 8.9, 11.5),
];