import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'authservice.dart';

/// -----------------------------------------------------------------------
/// SESSION MANAGER — handles saving/reading/clearing local user session
/// -----------------------------------------------------------------------
class SessionManager {
  SessionManager._internal();
  static final SessionManager instance = SessionManager._internal();

  final GetStorage _box = GetStorage();

  static const String _keyUser = "session_user";
  static const String _keyIsLoggedIn = "session_is_logged_in";

  /// Call once in main() before runApp()
  static Future<void> init() async {
    await GetStorage.init();
    print("🟣 [SessionManager] Initialized");
  }

  /// Save user data after successful signup/login
  Future<void> saveUser(UserModel user) async {
    await _box.write(_keyUser, jsonEncode(user.toJson()));
    await _box.write(_keyIsLoggedIn, true);
    print("🟣 [SessionManager] User saved: ${user.username}");
  }

  /// Get currently saved user (null if none)
  UserModel? getUser() {
    final String? data = _box.read(_keyUser);
    if (data == null) return null;
    return UserModel.fromJson(jsonDecode(data));
  }

  /// Check login state
  bool get isLoggedIn => _box.read(_keyIsLoggedIn) ?? false;

  /// Clear session (logout)
  Future<void> clearSession() async {
    await _box.remove(_keyUser);
    await _box.remove(_keyIsLoggedIn);
    print("🟣 [SessionManager] Session cleared");
  }
}