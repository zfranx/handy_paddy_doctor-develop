import 'package:hive_flutter/adapters.dart';

class HiveBox {
  static final String analysis = 'analysis';
}

class HiveUtils {
  late Box _box;
  late String _boxName;

  HiveUtils(String boxName) : _boxName = boxName;

  Future<Box> get dataBox async {
    if(!Hive.isBoxOpen(_boxName)) {
      _box = await Hive.openBox(_boxName);
    } else {
      _box = Hive.box(_boxName);
    }
    return _box;
  }
}
