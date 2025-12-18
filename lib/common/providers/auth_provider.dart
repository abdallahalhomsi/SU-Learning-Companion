import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../features/Authentication/auth_service.dart';
import '../../features/Authentication/user_profile_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;
  final UserProfileService _profileService;

  AuthProvider({
    AuthService? authService,
    UserProfileService? profileService,
  })  : _authService = authService ?? AuthService(),
        _profileService = profileService ?? UserProfileService();

  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;
  User? get currentUser => _authService.currentUser;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? msg) {
    _error = msg;
    notifyListeners();
  }

  String _friendlyAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No account exists for this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'invalid-email':
        return 'The email address entered is invalid.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'email-already-in-use':
        return 'An account with this email already exists.';
      case 'weak-password':
        return 'Password is too weak. Must at least be 6 Characters';
      case 'too-many-requests':
        return 'Too many attempts. Try again later.';
      default:
        return e.message ?? 'Authentication failed.';
    }
  }

  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    _setError(null);
    _setLoading(true);
    try {
      await _authService.signIn(
        email: email,
        password: password,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(_friendlyAuthError(e));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signUp({
    required String fullName,
    required String studentId,
    required String email,
    required String password,
    required String major,
    required String minor,
    required String department,
  }) async {
    _setError(null);
    _setLoading(true);
    try {
      final cred = await _authService.register(
        email: email,
        password: password,
      );

      final uid = cred.user?.uid;
      if (uid == null) {
        _setError('Failed to create user.');
        return false;
      }

      await _profileService.createUserProfile(
        uid: uid,
        fullName: fullName,
        studentId: studentId,
        email: email,
        major: major,
        minor: minor,
        department: department,
      );

      return true;
    } on FirebaseAuthException catch (e) {
      _setError(_friendlyAuthError(e));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    _setLoading(true);
    await _authService.signOut();
    _setLoading(false);
  }
}
