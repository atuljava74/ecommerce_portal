class UserSession {
  static int? _userId;

  static int? get userId => _userId;

  static void setUserId(int id) {
    _userId = id;
  }

  static void clearSession() {
    _userId = null;
  }
}
