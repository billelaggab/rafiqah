// lib/core/services/geo_routing_service.dart
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

  static Future<void> openNearby(FacilityType type) async {
    final geoUri = Uri.parse('geo:0,0?q=${Uri.encodeComponent(type.query)}');
    if (await canLaunchUrl(geoUri)) {
      await launchUrl(geoUri, mode: LaunchMode.externalApplication);
    } else {
      final webUri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(type.query)}',
      );
      await launchUrl(webUri, mode: LaunchMode.externalApplication);
    }
  }
}