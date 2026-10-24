// lib/features/mode_selector/presentation/app_mode_icons.dart
import 'package:flutter/material.dart';

import 'package:rafiqah/features/mode_selector/domain/app_mode.dart';

extension AppModeIcons on AppMode {
  IconData get icon => switch (this) {
        AppMode.cycle => Icons.calendar_month,
        AppMode.ttc => Icons.thermostat,
        AppMode.pregnancy => Icons.pregnant_woman,
        AppMode.postpartum => Icons.child_care,
      };
}
