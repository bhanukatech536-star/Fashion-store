import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/firebase_service.dart';

class AuthController extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  UserModel? _currentUser;
  bool _isLoading = false;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    setLoading(true);
    try {
      // Mock logic for UI testing phase
      await Future.delayed(const Duration(seconds: 2));
      if (email.isNotEmpty && password.isNotEmpty) {
        _currentUser = UserModel(
          id: '1',
          name: 'Jane Doe',
          email: email,
          address: '123 Fashion Ave, NY',
          phone: '(555) 123-4567',
        );
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<bool> register(String name, String email, String password) async {
    setLoading(true);
    try {
      await Future.delayed(const Duration(seconds: 2));
      _currentUser = UserModel(
        id: '1',
        name: name,
        email: email,
        address: '',
        phone: '',
      );
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<void> logout() async {
    setLoading(true);
    await Future.delayed(const Duration(seconds: 1));
    _currentUser = null;
    notifyListeners();
    setLoading(false);
  }
}
