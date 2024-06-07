import 'dart:io';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart';

class LocalStorageSaver {
  static Future<String> _getExternalDocumentPath() async {
    if (!await Permission.storage.isGranted) {
      await Permission.storage.request();
    }

    final status = await Permission.storage.status;
    if (!status.isGranted) {
      throw Exception();
    }

    Directory directory = Directory("dir");
    if (Platform.isAndroid) {
      directory = Directory("/storage/emulated/0/Download/Al Iman Center");
    } else {
      directory = await getApplicationDocumentsDirectory();
    }

    final exPath = directory.path;

    await Directory(exPath).create(recursive: true);
    return exPath;
  }

  static Future<String> get _localPath async {
    final String directory = await _getExternalDocumentPath();
    return directory;
  }

  static Future<String> saveImage(Uint8List bytes) async {
    // Generate a timestamp for the filename
    String timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());

    String fileName = '$timestamp.jpg';
    String filePath = join(await _localPath, fileName);
    File file = File(filePath);

    await file.writeAsBytes(bytes, flush: true);

    return filePath;
  }

  static Future<String> savePdf(Uint8List fileBytes) async {
    // Generate a timestamp for the pdf File name
    String timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());

    String fileName = 'events_$timestamp.pdf';
    String filePath = join(await _localPath, fileName);
    File file = File(filePath);

    await file.writeAsBytes(fileBytes);

    return filePath;
  }
}
