import 'package:hive_flutter/hive_flutter.dart';
import 'package:remote_eye/core/services/database/hive/hive_strings.dart';

class HiveService {
  //initialize database

  static Future<void> init() async {
    await Hive.initFlutter();
  }

  static void registerAdapters() {}

// open box in database to save  data in

  static Future<void> openBoxes() async {
    await Hive.openBox(settingsBox);
  }
}
