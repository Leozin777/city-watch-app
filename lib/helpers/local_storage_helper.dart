import 'package:city_watch/data/models/interface/ilocal_storage_helper.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageHelper implements ILocalStorageHelper {
  SharedPreferences? _localStorageCache;
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  Future<SharedPreferences> get _localStorage async {
    _localStorageCache ??= await SharedPreferences.getInstance();
    return _localStorageCache!;
  }

  @override
  Future<String?> getString_localStorage(String key) async {
    final localStorage = await _localStorage;
    return localStorage.getString(key);
  }

  @override
  Future<void> setString_localStorage(String key, String value) async {
    final localStorage = await _localStorage;
    await localStorage.setString(key, value);
  }

  @override
  Future<void> remove_localStorage(String key) async {
    final localStorage = await _localStorage;
    await localStorage.remove(key);
  }

  @override
  Future<void> clear_localStorage() async {
    final localStorage = await _localStorage;
    await localStorage.clear();
  }

  @override
  Future<void> setBool_localStorage(String key, bool value) async {
    final localStorage = await _localStorage;
    await localStorage.setBool(key, value);
  }

  @override
  Future<bool?> getBool_localStorage(String key) async {
    final localStorage = await _localStorage;
    return localStorage.getBool(key);
  }

  @override
  Future<void> setInt_localStorage(String key, int value) async {
    final localStorage = await _localStorage;
    await localStorage.setInt(key, value);
  }

  @override
  Future<int?> getInt_localStorage(String key) async {
    final localStorage = await _localStorage;
    return localStorage.getInt(key);
  }

  @override
  Future<void> setDouble_localStorage(String key, double value) async {
    final localStorage = await _localStorage;
    await localStorage.setDouble(key, value);
  }

  @override
  Future<double?> getDouble_localStorage(String key) async {
    final localStorage = await _localStorage;
    return localStorage.getDouble(key);
  }

  @override
  void setStringSecureStorage(String key, String? value) {
    _secureStorage.write(key: key, value: value);
  }

  @override
  Future<String?> getStringSecureStorage(String key) async {
    return await _secureStorage.read(key: key);
  }

  @override
  void removeSecureStorage(String key) {
    _secureStorage.delete(key: key);
  }
}
