// lib/features/settings/presentation/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:rafiqah/app/bootstrap_provider.dart';
import 'package:rafiqah/core/database/database_provider.dart';
import 'package:rafiqah/core/providers/profile_provider.dart';
import 'package:rafiqah/core/services/backup_service.dart';
import 'package:rafiqah/core/utils/constants.dart';
import 'package:rafiqah/core/utils/medical_calculator.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _busy = false;

  void _snack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<String?> _askPassphrase({required bool confirm}) async {
    final formKey = GlobalKey<FormState>();
    final password = TextEditingController();
    final confirmation = TextEditingController();
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(confirm ? 'كلمة مرور النسخة الاحتياطية' : 'أدخلي كلمة المرور'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: password,
                  obscureText: true,
                  autofocus: true,
                  decoration: const InputDecoration(
                    labelText: 'كلمة المرور (8 أحرف على الأقل)',
                  ),
                  validator: (value) {
                    if (value == null || value.length < 8) {
                      return 'كلمة المرور قصيرة جدًا';
                    }
                    return null;
                  },
                ),
                if (confirm) ...[
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: confirmation,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'تأكيد كلمة المرور',
                    ),
                    validator: (value) {
                      if (value != password.text) {
                        return 'كلمتا المرور غير متطابقتين';
                      }
                      return null;
                    },
                  ),
                ],
                const SizedBox(height: 12),
                const Text(
                  'لا يمكن استعادة النسخة بدون كلمة المرور هذه. احتفظي بها في مكان آمن.',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                Navigator.pop(ctx, password.text);
              }
            },
            child: const Text('متابعة'),
          ),
        ],
      ),
    );
  }

  Future<void> _editProfile() async {
    final profile = await ref.read(databaseProvider).userProfileDao.getProfile();
    if (!mounted) return;

    final now = DateTime.now();
    final firstDate = DateTime(now.year - 2, now.month, now.day);
    var lmp = profile?.lmpDate?.toLocal() ??
        DateTime(now.year, now.month, now.day - 28);
    lmp = DateTime(lmp.year, lmp.month, lmp.day);
    if (lmp.isBefore(firstDate)) lmp = firstDate;
    if (lmp.isAfter(now)) lmp = now;
    var cycle = (profile?.cycleLength ?? 28).clamp(21, 40);

    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('بيانات الدورة والحمل'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.calendar_today),
                  title: const Text('تاريخ آخر دورة'),
                  subtitle: Text(DateFormat('yyyy/MM/dd').format(lmp)),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: ctx,
                      initialDate: lmp,
                      firstDate: firstDate,
                      lastDate: now,
                      locale: const Locale('ar'),
                    );
                    if (picked != null) {
                      setDialogState(() => lmp = picked);
                    }
                  },
                ),
                DropdownButtonFormField<int>(
                  initialValue: cycle,
                  decoration: const InputDecoration(
                    labelText: 'طول الدورة (يوم)',
                  ),
                  items: [
                    for (var i = 21; i <= 40; i++)
                      DropdownMenuItem(value: i, child: Text('$i')),
                  ],
                  onChanged: (value) {
                    if (value != null) setDialogState(() => cycle = value);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('حفظ'),
            ),
          ],
        ),
      ),
    );
    if (saved != true || !mounted) return;

    setState(() => _busy = true);
    try {
      final edd = MedicalCalculator.calculateEDD(
        lmp: lmp,
        cycleLength: cycle,
      );
      await ref.read(databaseProvider).userProfileDao.completeOnboarding(
            lmpDate: lmp,
            eddDate: edd,
            cycleLength: cycle,
          );
      ref.invalidate(profileProvider);
      _snack('تم تحديث بيانات الدورة والحمل');
    } catch (e) {
      _snack('تعذر حفظ البيانات: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _backup() async {
    final passphrase = await _askPassphrase(confirm: true);
    if (passphrase == null || !mounted) return;

    setState(() => _busy = true);
    try {
      final db = ref.read(databaseProvider);
      final account = await BackupService.instance.signIn();
      if (account == null) {
        _snack('تم إلغاء تسجيل الدخول إلى Google');
        return;
      }
      await BackupService.instance.backup(db, passphrase);
      _snack('تم النسخ الاحتياطي بنجاح');
    } catch (e) {
      _snack('فشل النسخ الاحتياطي: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _restore() async {
    final passphrase = await _askPassphrase(confirm: false);
    if (passphrase == null || !mounted) return;

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('استعادة النسخة'),
        content: const Text(
          'سيتم استبدال كل البيانات الحالية بالنسخة الاحتياطية. '
          'لا يمكن التراجع عن هذه الخطوة.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('استعادة'),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;

    setState(() => _busy = true);
    try {
      final db = ref.read(databaseProvider);
      final account = await BackupService.instance.signIn();
      if (account == null) {
        _snack('تم إلغاء تسجيل الدخول إلى Google');
        return;
      }
      await BackupService.instance.restore(db, passphrase);
      ref.invalidate(profileProvider);
      await ref.read(bootstrapProvider.notifier).refresh();
      _snack('تمت الاستعادة بنجاح');
      if (mounted) Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      _snack('فشل الاستعادة: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _deleteAll() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('مسح جميع بياناتي'),
        content: const Text(
          'سيتم حذف كل بياناتك المحلية (الدورة، الحمل، الرضيع، نتائج EPDS). '
          'إذا كنت مسجلة الدخول إلى Google، ستُحذف النسخة الاحتياطية السحابية أيضًا. '
          'لا يمكن التراجع عن هذه الخطوة.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('حذف نهائي'),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;

    setState(() => _busy = true);
    try {
      final db = ref.read(databaseProvider);
      await db.userProfileDao.deleteAll();
      await db.cycleDao.deleteAll();
      await db.pregnancyDao.deleteAll();
      await db.babyDao.deleteAll();
      await db.postpartumDao.deleteAll();

      // حذف النسخة السحابية فقط عند وجود جلسة تسجيل دخول حالية؛
      // لا نفرض تسجيل الدخول إلى Google أثناء المسح المحلي.
      if (BackupService.instance.currentUser != null) {
        try {
          await BackupService.instance.deleteRemoteBackup();
        } catch (e) {
          debugPrint('Remote backup delete failed: $e');
        }
      }

      ref.invalidate(profileProvider);
      await ref.read(bootstrapProvider.notifier).refresh();
      _snack('تم مسح جميع البيانات');
      if (mounted) Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      _snack('فشل مسح البيانات: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _openPrivacy() async {
    final uri = Uri.parse(AppConstants.privacyPolicyUrl);
    if (!await canLaunchUrl(uri)) {
      _snack('تعذر فتح سياسة الخصوصية');
      return;
    }
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الإعدادات')),
      body: Column(
        children: [
          if (_busy) const LinearProgressIndicator(),
          Expanded(
            child: ListView(
              children: [
                const _SectionTitle('بياناتي'),
                ListTile(
                  enabled: !_busy,
                  leading: const Icon(Icons.edit_calendar),
                  title: const Text('تاريخ آخر دورة وطول الدورة'),
                  subtitle: const Text('يُستخدم لحساب الحمل والخصوبة'),
                  onTap: _editProfile,
                ),
                const Divider(),
                const _SectionTitle('النسخ الاحتياطي'),
                ListTile(
                  enabled: !_busy,
                  leading: const Icon(Icons.cloud_upload_outlined),
                  title: const Text('نسخ احتياطي مشفّر إلى Google Drive'),
                  subtitle: const Text('AES-256-GCM مع كلمة مرور تختارينها'),
                  onTap: _backup,
                ),
                ListTile(
                  enabled: !_busy,
                  leading: const Icon(Icons.cloud_download_outlined),
                  title: const Text('استعادة من Google Drive'),
                  subtitle: const Text('تستبدل البيانات الحالية بالنسخة'),
                  onTap: _restore,
                ),
                const Divider(),
                const _SectionTitle('الخصوصية'),
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined),
                  title: const Text('سياسة الخصوصية'),
                  onTap: _openPrivacy,
                ),
                const Divider(),
                const _SectionTitle('منطقة الخطر'),
                ListTile(
                  enabled: !_busy,
                  leading: const Icon(Icons.delete_forever, color: Colors.red),
                  title: const Text('مسح جميع بياناتي'),
                  subtitle: const Text('حذف محلي وسحابي نهائي'),
                  onTap: _deleteAll,
                ),
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'رفيقة لا تقدّم تشخيصًا طبيًا. في الحالات الطارئة توجهي '
                    'إلى أقرب مشفى أو اتصلي بالطوارئ.',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }
}
