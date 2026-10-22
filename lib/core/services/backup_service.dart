// lib/core/services/backup_service.dart
import 'dart:io';
import 'dart:typed_data';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../security/aes_encryption.dart';
import '../security/key_manager.dart';

class GoogleAuthClient extends http.BaseClient {
  GoogleAuthClient(this._headers);
  final Map<String, String> _headers;
  final http.Client _client = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(_headers);
    return _client.send(request);
  }
}

class BackupService {
  BackupService._();
  static final BackupService instance = BackupService._();

  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  GoogleSignInAccount? _currentUser;

  bool _initialized = false;
  Future<void> _ensureInit() async {
    if (_initialized) return;
    await _googleSignIn.initialize();
    _initialized = true;
  }

  Future<GoogleSignInAccount?> signIn() async {
    await _ensureInit();
    try {
      _currentUser = await _googleSignIn.authenticate();
      return _currentUser;
    } catch (_) {
      return null;
    }
  }

  Future<void> signOut() async {
    await _ensureInit();
    await _googleSignIn.signOut();
    _currentUser = null;
  }

  GoogleSignInAccount? get currentUser => _currentUser;

  Future<File> getDatabaseFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File(p.join(dir.path, 'rafiqah.sqlite'));
  }

  Future<drive.DriveApi?> _driveApi() async {
    await _ensureInit();
    var account = _currentUser;
    account ??= await signIn();
    if (account == null) return null;
    final headers = await account.authorizationClient.authorizationHeaders(
      [drive.DriveApi.driveAppdataScope],
    );
    if (headers == null) return null;
    final client = GoogleAuthClient(headers);
    return drive.DriveApi(client);
  }

  Future<void> backup() async {
    final api = await _driveApi();
    if (api == null) throw StateError('Not signed in');
    final file = await getDatabaseFile();
    final bytes = await file.readAsBytes();
    final key = await KeyManager.getOrCreateKey();
    final encrypted = AesEncryption.encryptWithIv(bytes, key);

    final list = await api.files.list(
      spaces: 'appDataFolder',
      q: "name = 'rafiqah_secure_backup.enc'",
    );
    if (list.files != null && list.files!.isNotEmpty) {
      final id = list.files!.first.id!;
      await api.files.delete(id);
    }

    final driveFile = drive.File()
      ..name = 'rafiqah_secure_backup.enc'
      ..parents = ['appDataFolder'];
    await api.files.create(
      driveFile,
      uploadMedia: drive.Media(Stream.value(encrypted), encrypted.length),
    );
  }

  Future<void> restore() async {
    final api = await _driveApi();
    if (api == null) throw StateError('Not signed in');
    final list = await api.files.list(
      spaces: 'appDataFolder',
      q: "name = 'rafiqah_secure_backup.enc'",
    );
    if (list.files == null || list.files!.isEmpty) {
      throw StateError('No backup found');
    }
    final id = list.files!.first.id!;
    final media = await api.files.get(id, downloadOptions: drive.DownloadOptions.fullMedia)
        as drive.Media;
    final chunks = <int>[];
    await for (final c in media.stream) {
      chunks.addAll(c);
    }
    final encrypted = Uint8List.fromList(chunks);
    final key = await KeyManager.getKey();
    if (key == null) throw StateError('No key available');
    final bytes = AesEncryption.decryptWithIv(encrypted, key);
    final file = await getDatabaseFile();
    await file.writeAsBytes(bytes, flush: true);
  }

  Future<void> deleteRemoteBackup() async {
    final api = await _driveApi();
    if (api == null) return;
    final list = await api.files.list(
      spaces: 'appDataFolder',
      q: "name = 'rafiqah_secure_backup.enc'",
    );
    if (list.files != null) {
      for (final f in list.files!) {
        if (f.id != null) await api.files.delete(f.id!);
      }
    }
  }
}