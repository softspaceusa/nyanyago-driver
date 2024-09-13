import 'package:nanny_core/nanny_core.dart';

class NannyStorage {
  static late final LocalStorage _storage;
  static Future<bool> get ready => _storage.ready;

  static Future<bool> init({required bool isClient}) {
    _storage = LocalStorage(isClient ? "nanny_data.json" : "nanny_driver_data.json");
    return _storage.ready;
  }

  static Future<void> updateLoginData(LoginStorageData data) async {
    await _storage.setItem('login_data', data.toJson());
  }

  static Future<void> removeLoginData() async => await _storage.deleteItem('login_data');

  static Future<LoginStorageData?> getLoginData() async {
    Map<String,dynamic>? data = await _storage.getItem('login_data');
    if(data == null) return null;

    return LoginStorageData.fromJson(data);
  }


  static Future<void> updateSettingsData(SettingsStorageData data) async {
    await _storage.setItem('settings_data', data.toJson());
  }
  
  static Future<SettingsStorageData?> getSettingsData() async {
    Map<String, dynamic>? data = await _storage.getItem('settings_data');
    if(data == null) return null;

    return SettingsStorageData.fromJson(data);
  }
}