import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:open_filex/open_filex.dart';

Future<String> calculateSHA256(File file) async {
  final bytes = await file.readAsBytes();
  return sha256.convert(bytes).toString();
}

Future<void> installUpdate(String updateFilePath) async {
  await OpenFilex.open(updateFilePath);
}