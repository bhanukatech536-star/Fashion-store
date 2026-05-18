import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../models/user_model.dart';
import '../services/firebase_service.dart';

class AuthController extends ChangeNotifier {
  final FirebaseService _firebase = FirebaseService();
  UserModel? _currentUser;
  bool _isLoading = false;
  bool _isReady = false;
  String? _lastError;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isReady => _isReady;
  String? get lastError => _lastError;
  bool get isAuthenticated => _currentUser != null;
  bool get isAdmin =>
      _currentUser != null && AppConstants.isAdminEmail(_currentUser!.email);

  AuthController() {
    _init();
  }

  Future<void> _init() async {
    _firebase.authStateChanges.listen(_onAuthStateChanged);
    // Handle app restart while already signed in
    final user = _firebase.currentFirebaseUser;
    if (user != null) {
      await _onAuthStateChanged(user);
    }
    _isReady = true;
    notifyListeners();
  }

  Future<void> _onAuthStateChanged(User? user) async {
    if (user == null) {
      _currentUser = null;
      notifyListeners();
      return;
    }
    _currentUser = await _loadOrCreateProfile(user);
    notifyListeners();
  }

  Future<UserModel> _loadOrCreateProfile(User user, {String? fallbackName}) async {
    final email = (user.email ?? '').trim();
    var profile = await _firebase.getUserProfile(user.uid);

    if (profile == null) {
      profile = UserModel(
        id: user.uid,
        name: fallbackName ?? user.displayName ?? _nameFromEmail(email),
        email: email,
        address: '',
        phone: '',
      );
      await _firebase.saveUserProfile(profile);
    } else if (profile.email.trim().isEmpty && email.isNotEmpty) {
      profile = UserModel(
        id: profile.id,
        name: profile.name,
        email: email,
        address: profile.address,
        phone: profile.phone,
      );
      await _firebase.saveUserProfile(profile);
    }

    return profile;
  }

  String _nameFromEmail(String email) {
    if (email.contains('@')) return email.split('@').first;
    return 'User';
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    setLoading(true);
    _lastError = null;
    try {
      final cred = await _firebase.signIn(email, password);
      final user = cred.user;
      if (user == null) return false;

      _currentUser = await _loadOrCreateProfile(user);
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _lastError = e.message ?? 'Login failed';
      return false;
    } catch (e) {
      _lastError = 'Login failed. Check your connection.';
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<bool> register(String name, String email, String password) async {
    if (AppConstants.isAdminEmail(email)) {
      _lastError = 'Cannot register admin account here';
      notifyListeners();
      return false;
    }
    setLoading(true);
    _lastError = null;
    try {
      final cred = await _firebase.signUp(email, password);
      final user = cred.user;
      if (user == null) return false;

      final profile = UserModel(
        id: user.uid,
        name: name.trim(),
        email: email.trim(),
        address: '',
        phone: '',
      );
      await _firebase.saveUserProfile(profile);
      _currentUser = profile;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _lastError = e.message ?? 'Registration failed';
      return false;
    } catch (e) {
      _lastError = 'Registration failed. Try again.';
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<bool> updateCurrentUser(UserModel user) async {
    try {
      await _firebase.saveUserProfile(user);
      _currentUser = user;
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> logout() async {
    setLoading(true);
    try {
      await _firebase.signOut();
      _currentUser = null;
    } finally {
      setLoading(false);
    }
  }
}
