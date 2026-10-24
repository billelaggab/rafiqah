// lib/core/services/geo_routing_service.dart
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

enum FacilityType {
  gynecology('عيادة طبيبة نساء وتوليد'),
  laboratory('مختبر تحاليل طبية'),
  maternityHospital('مستشفى ولادة وأطفال');

  final String query;
  const FacilityType(this.query);
}

class GeoRoutingService {
  GeoRoutingService._();

  /// يفتح تطبيق الخرائط على أقرب مرفق. يعيد `false` إذا تعذر الفتح.
  static Future<bool> openNearby(FacilityType type) async {
    final query = Uri.encodeComponent(type.query);
    final geoUri = Uri.parse('geo:0,0?q=$query');
    final webUri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$query',
    );

    for (final uri in [geoUri, webUri]) {
      try {
        if (await canLaunchUrl(uri)) {
          final opened = await launchUrl(
            uri,
            mode: LaunchMode.externalApplication,
          );
          if (opened) return true;
        }
      } catch (e) {
        debugPrint('Map launch failed for $uri: $e');
      }
    }
    return false;
  }

  /// يفتح لوحة الاتصال على رقم الطوارئ الدولي 112.
  ///
  /// 112 يعمل في معظم شبكات GSM، لكن على المستخدمة تأكيد رقم الطوارئ المحلي.
  static Future<bool> openEmergencyDialer() async {
    final uri = Uri(scheme: 'tel', path: '112');
    try {
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri);
      }
    } catch (e) {
      debugPrint('Emergency dial failed: $e');
    }
    return false;
  }
}
