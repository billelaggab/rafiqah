// lib/features/mode_selector/domain/app_mode.dart
enum AppMode {
  cycle('cycle', 'متابعة الدورة'),
  ttc('ttc', 'التخطيط للحمل'),
  pregnancy('pregnancy', 'أنا حامل'),
  postpartum('postpartum', 'أم جديدة');

  final String id;
  final String labelAr;
  const AppMode(this.id, this.labelAr);

  static AppMode fromId(String id) =>
      AppMode.values.firstWhere((m) => m.id == id, orElse: () => AppMode.pregnancy);
}
