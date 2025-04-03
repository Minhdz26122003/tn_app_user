class GlobalValue {
  static var global;
  static GlobalValue getInstance() {
    global ??= GlobalValue();
    return global;
  }

  String _token = "";

  void setToken(String token) {
    _token = token;
  }

  String getToken() {
    return _token;
  }
}
