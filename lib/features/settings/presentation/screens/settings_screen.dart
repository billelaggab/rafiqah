// lib/features/settings/presentation/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafiqah/core/database/database_provider.dart';
import 'package:rafiqah/core/services/backup_service.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _deleteAll(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('مسح جميع البيانات'),
        content: const Text('هل أنتِ متأكدة؟ سيتم حذف كل البيانات نهائياً.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('إلغاء')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('حذف')),
        ],
      ),
    );
    if (ok != true) return;
    final db = ref.read(databaseProvider);
    await db.userProfileDao.deleteAll();
    await db.cycleDao.deleteAll();
    await db.pregnancyDao.deleteAll();
    await db.babyDao.deleteAll();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم مسح البيانات')));
    }
  }

  Future<void> _backup(BuildContext context) async {
    try {
      await BackupService.instance.signIn();
      await BackupService.instance.backup();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم النسخ الاحتياطي')));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('فشل النسخ: $e')));
      }
    }
  }

  Future<void> _restore(BuildContext context) async {
    try {
      await BackupService.instance.signIn();
      await BackupService.instance.restore();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تمت الاستعادة — أعيدي تشغيل التطبيق')));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('فشل الاستعادة: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('الإعدادات')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.cloud_upload),
            title: const Text('نسخ احتياطي (Google Drive)'),
            onTap: () => _backup(context),
          ),
          ListTile(
            leading: const Icon(Icons.cloud_download),
            title: const Text('استعادة من Google Drive'),
            onTap: () => _restore(context),
          ),
          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            title: const Text('مسح جميع بياناتي'),
            onTap: () => _deleteAll(context, ref),
          ),
        ],
      ),
    );
  }
}