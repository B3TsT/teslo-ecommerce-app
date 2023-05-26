import 'package:shared_preferences/shared_preferences.dart';

import 'key_value_storage_service.dart';

class KeyValueStorageServiceImpl extends KeyValueStorageService {
  Future<SharedPreferences> getSharedPreferenceInstance() async {
    return await SharedPreferences.getInstance();
  }

  @override
  Future<T?> getValue<T>(String key) async {
    final prefs = await getSharedPreferenceInstance();
    switch (T) {
      case int:
        return prefs.getInt(key) as T?;
      case String:
        return prefs.getString(key) as T?;
      default:
        throw UnimplementedError(
          'Get not implemented for type ${T.toString()}',
        );
    }
  }

  @override
  Future<bool> removeValue(String key) async {
    final prefs = await getSharedPreferenceInstance();
    return await prefs.remove(key);
  }

  @override
  Future<void> setKeyValue<T>(String key, T value) async {
    final prefs = await getSharedPreferenceInstance();
    switch (T) {
      case int:
        await prefs.setInt(key, value as int);
        break;
      case String:
        await prefs.setString(key, value as String);
        break;
      default:
        throw UnimplementedError(
          'Set not implemented for type ${T.toString()}',
        );
    }
  }
}
