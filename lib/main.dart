// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'core/services/notification_service.dart';
import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await MobileAds.instance.initialize();
  } catch (e, st) {
    debugPrint('MobileAds init failed: $e\n$st');
  }
  try {
    await NotificationService.instance.init();
  } catch (e, st) {
    debugPrint('Notification init failed: $e\n$st');
  }
  runApp(const ProviderScope(child: RafiqahApp()));
}