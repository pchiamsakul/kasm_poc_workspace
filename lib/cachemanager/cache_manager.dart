import 'dart:convert';

import 'package:encrypt_shared_preferences/provider.dart';
import 'package:flutter/foundation.dart';

class CacheManager {
  final EncryptedSharedPreferences sharedPref;

  CacheManager(this.sharedPref);

  static Future<CacheManager> init() async {
    final key = "b7e3c393e43ba956";
    await EncryptedSharedPreferences.initialize(key);
    var sharedPref = EncryptedSharedPreferences.getInstance();
    return CacheManager(sharedPref);
  }

  void saveString(String key, String value) {
    sharedPref.setString(key, value);
  }

  void saveInt(String key, int value) {
    sharedPref.setInt(key, value);
  }

  void saveBool(String key, bool value) {
    sharedPref.setBoolean(key, value);
  }

  void saveDouble(String key, double value) {
    sharedPref.setDouble(key, value);
  }

  String? loadString(String key) {
    return sharedPref.getString(key);
  }

  int? loadInt(String key) {
    return sharedPref.getInt(key);
  }

  bool? loadBool(String key) {
    return sharedPref.getBoolean(key);
  }

  double? loadDouble(String key) {
    return sharedPref.getDouble(key);
  }

  void saveModel(String key, dynamic model) {
    try {
      var jsonString = "";
      if (model is List) {
        model = model.map((e) => e.toJson()).toList();
        jsonString = jsonEncode(model);
      } else {
        jsonString = jsonEncode(model.toJson());
      }
      saveString(key, jsonString);
    } catch (e) {
      if (kDebugMode) {
        print("Error saving model to cache: $e");
      }
      // do nothing
    }
  }

  T? loadModel<T>(String key, T Function(String) fromJson) {
    final jsonString = loadString(key);
    if (jsonString != null) {
      return fromJson(jsonString);
    }
    return null;
  }

  bool containsKey(String key) {
    return sharedPref.getString(key) != null ||
        sharedPref.getInt(key) != null ||
        sharedPref.getBoolean(key) != null ||
        sharedPref.getDouble(key) != null;
  }

  void remove(String key) {
    sharedPref.remove(key);
  }

  void clear() {
    sharedPref.clear();
  }
}
