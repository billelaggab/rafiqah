// lib/core/security/key_manager.dart
import 'dart:convert';
import 'dart:math';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class KeyManager {
  KeyManager._();
  static const _storage = FlutterSecureStorage();
  static const _keyName = 'rafiqah_aes_key';

  static Future<String> getOrCreateKey() async {
    String? key = await _storage.read(key: _keyName);
    if (key == null) {
      final rnd = Random.secure();
      final bytes = List<int>.generate(32, (_) => rnd.nextInt(256));
      key = base64.encode(bytes);
      await _storage.write(key: _keyName, value: key);
    }
    return key;
  }

  static Future<String?> getKey() => _storage.read(key: _keyName);

  static Future<void> deleteAll() => _storage.deleteAll();
}