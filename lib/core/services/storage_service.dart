class StorageService {
  const StorageService();

  static final Map<String, String> _memory = <String, String>{};

  Future<void> write(String key, String value) async {
    _memory[key] = value;
  }

  Future<String?> read(String key) async {
    return _memory[key];
  }

  Future<void> delete(String key) async {
    _memory.remove(key);
  }
}
