// lib/core/security/aes_encryption.dart
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:pointycastle/export.dart';

/// تشفير AES-256-GCM مع مفتاح مشتق من عبارة مرور (PBKDF2-HMAC-SHA256).
///
/// صيغة الملف:
/// `RFQ1` (4 بايت) + الإصدار (1) + الملح (16) + الـnonce (12) + ciphertext+tag.
///
/// الاعتماد على عبارة مرور يجعل النسخة قابلة للاستعادة على جهاز جديد،
/// بخلاف المفتاح المحفوظ في التخزين الآمن فقط.
class AesEncryption {
  AesEncryption._();

  static const String _magic = 'RFQ1';
  static const int _version = 1;
  static const int _saltLength = 16;
  static const int _nonceLength = 12;
  static const int _tagLength = 16;
  static const int _keyLength = 32;
  static const int _pbkdf2Iterations = 120000;

  static Uint8List encrypt(Uint8List data, String passphrase) {
    final salt = _randomBytes(_saltLength);
    final nonce = _randomBytes(_nonceLength);
    final key = _deriveKey(passphrase, salt);

    final cipher = GCMBlockCipher(AESEngine())
      ..init(
        true,
        AEADParameters(KeyParameter(key), 128, nonce, Uint8List(0)),
      );

    final cipherText = cipher.process(data);
    final builder = BytesBuilder(copy: false)
      ..add(utf8.encode(_magic))
      ..addByte(_version)
      ..add(salt)
      ..add(nonce)
      ..add(cipherText);
    return builder.toBytes();
  }

  static Uint8List decrypt(Uint8List data, String passphrase) {
    const headerLength = 4 + 1 + _saltLength + _nonceLength;
    if (data.length < headerLength + _tagLength) {
      throw const FormatException('ملف النسخة الاحتياطية غير صالح');
    }
    if (utf8.decode(data.sublist(0, 4), allowMalformed: true) != _magic) {
      throw const FormatException('صيغة النسخة الاحتياطية غير معروفة');
    }
    if (data[4] != _version) {
      throw const FormatException('إصدار النسخة الاحتياطية غير مدعوم');
    }

    final salt = data.sublist(5, 5 + _saltLength);
    final nonce = data.sublist(5 + _saltLength, headerLength);
    final cipherText = data.sublist(headerLength);
    final key = _deriveKey(passphrase, salt);

    final cipher = GCMBlockCipher(AESEngine())
      ..init(
        false,
        AEADParameters(KeyParameter(key), 128, nonce, Uint8List(0)),
      );

    try {
      return cipher.process(cipherText);
    } catch (_) {
      throw const FormatException(
        'تعذر فك التشفير: كلمة المرور غير صحيحة أو الملف تالف',
      );
    }
  }

  static Uint8List _deriveKey(String passphrase, Uint8List salt) {
    final derivator = PBKDF2KeyDerivator(HMac(SHA256Digest(), 64))
      ..init(Pbkdf2Parameters(salt, _pbkdf2Iterations, _keyLength));
    return derivator.process(Uint8List.fromList(utf8.encode(passphrase)));
  }

  static Uint8List _randomBytes(int length) {
    final random = Random.secure();
    return Uint8List.fromList(
      List<int>.generate(length, (_) => random.nextInt(256)),
    );
  }
}
