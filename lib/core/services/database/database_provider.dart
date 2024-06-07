import 'package:hive/hive.dart';

class DatabaseProvider {
  Future<void> addItem(item, String collectionName) async {
    var box = Hive.box(collectionName);
    box.add(item);
  }

  Future<void> addAll(items, String collectionName) async {
    var box = Hive.box(collectionName);
    box.addAll(items);
  }

  List getAllValues(String collectionName) {
    return Hive.box(collectionName).values.toList();
  }

  Future<void> clearBox(String collectionName) async {
    await Hive.box(collectionName).clear();
  }

  getAt(String collectionName, [String? key]) {
    var box = Hive.box(collectionName);
    return box.get(key ?? 0);
  }

  Future<void> putAt(item, String collectionName, [dynamic key]) async {
    Hive.box(collectionName).put(key ?? 0, item);
  }

  Future<void> remove(dynamic key, String collectionName) async {
    Hive.box(collectionName).delete(key);
  }

  // Future<void> deleteAll() async {
  //   await HiveService.clearBoxes();
  // }
}
