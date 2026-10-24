// lib/core/services/backup_service.dart
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../database/app_database.dart';
import '../security/aes_encryption.dart';

class GoogleAuthClient extends http.BaseClient {
  GoogleAuthClient(this._headers);
  final Map<String, String> _headers;
  final http.Client _client = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(_headers);
    return _client.send(request);
  }

  @override
  void close() {
    _client.close();
    super.close();
  }
}

class BackupService {
  BackupService._();
  static final BackupService instance = BackupService._();

  static const String _fileName = 'rafiqah_secure_backup.enc';

  /// يُمرَّر عبر `--dart-define=GOOGLE_WEB_CLIENT_ID=...`.
  static const String _webClientId =
      String.fromEnvironment('GOOGLE_WEB_CLIENT_ID');

  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  GoogleSignInAccount? _currentUser;
  bool _initialized = false;

  Future<void> _ensureInit() async {
    if (_initialized) return;
    try {
      await _googleSignIn.initialize(
        serverClientId: _webClientId.isEmpty ? null : _webClientId,
      );
      _initialized = true;
    } on GoogleSignInException catch (e) {
      throw StateError(
        'تعذر تهيئة Google Sign-In (${e.code.name}). '
        'تأكدي من إعداد معرّف عميل الويب وبصمة SHA-1.',
      );
    }
  }

  /// يعيد `null` إذا ألغت المستخدمة العملية.
  Future<GoogleSignInAccount?> signIn() async {
    await _ensureInit();
    _currentUser = await _googleSignIn.authenticate();
    return _currentUser;
  }

  Future<void> signOut() async {
    await _ensureInit();
    await _googleSignIn.signOut();
    _currentUser = null;
  }

  GoogleSignInAccount? get currentUser => _currentUser;

  /// ينفّذ عملية Drive ويغلق عميل HTTP دائمًا.
  Future<T> _withDrive<T>(
    Future<T> Function(drive.DriveApi api) action,
  ) async {
    await _ensureInit();
    final account = _currentUser ?? await signIn();
    if (account == null) {
      throw StateError('لم يتم تسجيل الدخول إلى Google');
    }
    final headers = await account.authorizationClient.authorizationHeaders(
      [drive.DriveApi.driveAppdataScope],
    );
    if (headers == null) {
      throw StateError('لم يتم منح صلاحية النسخ الاحتياطي على Google Drive');
    }
    final client = GoogleAuthClient(headers);
    try {
      return await action(drive.DriveApi(client));
    } finally {
      client.close();
    }
  }

  Future<drive.File?> _findBackup(drive.DriveApi api) async {
    final list = await api.files.list(
      spaces: 'appDataFolder',
      q: "name = '$_fileName'",
    );
    final files = list.files;
    if (files == null || files.isEmpty) return null;
    return files.first;
  }

  /// ينشئ نسخة متسقة من القاعدة، يشفّرها، ثم يرفعها إلى `drive.appdata`.
  ///
  /// لا يحذف النسخة القديمة قبل نجاح الرفع.
  Future<void> backup(AppDatabase db, String passphrase) async {
    final dir = await getTemporaryDirectory();
    final snapshot = File(
      p.join(dir.path, 'rafiqah_${DateTime.now().microsecondsSinceEpoch}.sqlite'),
    );
    try {
      await db.vacuumInto(snapshot.path);
      final bytes = await snapshot.readAsBytes();
      // PBKDF2 ثقيل؛ ننفذه في isolate حتى لا تتجمد الواجهة.
      final encrypted = await Isolate.run(
        () => AesEncryption.encrypt(bytes, passphrase),
      );

      await _withDrive((api) async {
        final existing = await _findBackup(api);
        final media = drive.Media(
          Stream.value(encrypted),
          encrypted.length,
          contentType: 'application/octet-stream',
        );

        if (existing?.id != null) {
          await api.files.update(
            drive.File()..name = _fileName,
            existing!.id!,
            uploadMedia: media,
          );
        } else {
          await api.files.create(
            drive.File()
              ..name = _fileName
              ..parents = ['appDataFolder'],
            uploadMedia: media,
          );
        }
      });
    } finally {
      if (await snapshot.exists()) {
        await snapshot.delete();
      }
    }
  }

  /// ينزّل النسخة، يفك تشفيرها، ويستعيدها داخل القاعدة الحالية.
  Future<void> restore(AppDatabase db, String passphrase) async {
    final bytes = await _withDrive((api) async {
      final file = await _findBackup(api);
      if (file?.id == null) {
        throw StateError('لا توجد نسخة احتياطية على Google Drive');
      }

      final media = await api.files.get(
        file!.id!,
        downloadOptions: drive.DownloadOptions.fullMedia,
      ) as drive.Media;

      final chunks = <int>[];
      await for (final chunk in media.stream) {
        chunks.addAll(chunk);
      }
      final encrypted = Uint8List.fromList(chunks);
      return Isolate.run(
        () => AesEncryption.decrypt(encrypted, passphrase),
      );
    });
    await db.restoreFromBackup(bytes);
  }

  Future<void> deleteRemoteBackup() => _withDrive((api) async {
        final list = await api.files.list(
          spaces: 'appDataFolder',
          q: "name = '$_fileName'",
        );
        final files = list.files;
        if (files == null) return;
        for (final f in files) {
          if (f.id != null) await api.files.delete(f.id!);
        }
      });
}
