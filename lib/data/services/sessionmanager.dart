import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'authservice.dart';

class SessionManager {
  SessionManager._internal();
  static final SessionManager instance = SessionManager._internal();

  final GetStorage _box = GetStorage();

  static const String _keyUser = "session_user";
  static const String _keyIsLoggedIn = "session_is_logged_in";

  static Future<void> init() async {
    await GetStorage.init();
    print("🟣 [SessionManager] Initialized");
  }

  Future<void> saveUser(UserModel user) async {
    await _box.write(_keyUser, jsonEncode(user.toJson()));
    await _box.write(_keyIsLoggedIn, true);
    print("🟣 [SessionManager] User saved: ${user.username}");
  }

  UserModel? getUser() {
    final String? data = _box.read(_keyUser);
    if (data == null) return null;
    return UserModel.fromJson(jsonDecode(data));
  }

  /// Update ONLY the thinking_style of the currently saved user, keeping
  /// everything else untouched. Called by InteractionPreferenceController
  /// right after a successful API response.
  Future<void> updateThinkingStyle(String thinkingStyle) async {
    final currentUser = getUser();
    if (currentUser == null) {
      print("🔴 [SessionManager] Cannot update thinking style — no user in session");
      return;
    }

    final updatedUser = currentUser.copyWith(thinkingStyle: thinkingStyle);
    await saveUser(updatedUser);
    print("🟣 [SessionManager] Thinking style updated: $thinkingStyle");
  }

  bool get isLoggedIn => _box.read(_keyIsLoggedIn) ?? false;

  Future<void> clearSession() async {
    await _box.remove(_keyUser);
    await _box.remove(_keyIsLoggedIn);
    print("🟣 [SessionManager] Session cleared");
  }
}