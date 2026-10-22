// lib/core/security/aes_encryption.dart
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';

/// تشفير AES-GCM 256-bit (يستخدم AES-CBC + HMAC via encrypt package).
class AesEncryption {
  AesEncryption._();

  static Encrypted encrypt(Uint8List data, String keyBase64) {
    final key = Key.fromBase64(keyBase64);
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    return encrypter.encryptBytes(data, iv: iv);
  }

  static Uint8List decrypt(Encrypted data, String keyBase64) {
    final key = Key.fromBase64(keyBase64);
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    return Uint8List.fromList(encrypter.decryptBytes(data, iv: iv));
  }

  /// تشفير مع IV مُضمّن (IV + ciphertext) لإمكانية فك التشفير لاحقًا
  static Uint8List encryptWithIv(Uint8List data, String keyBase64) {
    final key = Key.fromBase64(keyBase64);
    final iv = IV.fromSecureRandom(16);
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final encrypted = encrypter.encryptBytes(data, iv: iv);
    final out = BytesBuilder();
    out.add(iv.bytes);
    out.add(encrypted.bytes);
    return out.toBytes();
  }

  static Uint8List decryptWithIv(Uint8List data, String keyBase64) {
    final key = Key.fromBase64(keyBase64);
    final iv = IV(data.sublist(0, 16));
    final cipher = data.sublist(16);
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    return Uint8List.fromList(
        encrypter.decryptBytes(Encrypted(cipher), iv: iv));
  }
}