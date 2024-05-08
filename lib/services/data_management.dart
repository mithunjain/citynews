import 'dart:convert';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

class DataManagement {
  static storeData(String key, dynamic value) async {
    final instance = await SharedPreferences.getInstance();
    final _isStored = await instance.setString(key, toJson(value));
    log('$key:   $value     ==    $_isStored');
  }

  static getStoredData(String key) async {
    final instance = await SharedPreferences.getInstance();
    final _data = instance.getString(key);
    if (_data == null) return;
    return fromJson(_data);
  }

  static String toJson(value) => json.encode(value);

  static fromJson(String data) => json.decode(data);

  // static loadEnvData() async => await dotenv.load(fileName: ".env");

  /// MAke Sure There is a file named as '.env' in root dir
  // static String? getEnvData(String key) => dotenv.env[key];

  static generateTableNameForNewConnectionChat(String id) => "_${id}_";
  static generateTableNameForNewConnectionActivity(String id) =>
      "_${id}activity_";
  static logOutFromApp() async {
    final instance = await SharedPreferences.getInstance();
    instance.clear();
  }
}
