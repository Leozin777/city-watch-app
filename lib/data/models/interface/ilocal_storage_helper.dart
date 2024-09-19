abstract interface class ILocalStorageHelper {
  Future<String?> getString_localStorage(String key) async {}

  Future<void> setString_localStorage(String key, String value) async {}

  Future<void> remove_localStorage(String key) async {}

  Future<void> clear_localStorage() async {}

  Future<void> setBool_localStorage(String key, bool value) async {}

  Future<bool?> getBool_localStorage(String key) async {}

  Future<void> setInt_localStorage(String key, int value) async {}

  Future<int?> getInt_localStorage(String key) async {}

  Future<void> setDouble_localStorage(String key, double value) async {}

  Future<double?> getDouble_localStorage(String key) async {}

  void setStringSecureStorage(String key, String? value) {}

  Future<String?> getStringSecureStorage(String key) async {}

  void removeSecureStorage(String key) {}
}
