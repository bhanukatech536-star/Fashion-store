import 'package:flutter/material.dart';
import '../models/user_model.dart';
import 'auth_controller.dart';

class UserController extends ChangeNotifier {
  bool _isLoading = false;
  String? _lastError;

  bool get isLoading => _isLoading;
  String? get lastError => _lastError;

  Future<bool> updateProfile(
    AuthController authController,
    String name,
    String address,
    String phone,
  ) async {
    _isLoading = true;
    _lastError = null;
    notifyListeners();

    try {
      final current = authController.currentUser;
      if (current == null) {
        _lastError = 'Not signed in';
        return false;
      }

      final updatedUser = UserModel(
        id: current.id,
        name: name.trim(),
        email: current.email,
        address: address.trim(),
        phone: phone.trim(),
      );

      final ok = await authController.updateCurrentUser(updatedUser);
      if (!ok) {
        _lastError = 'Failed to save profile to Firebase';
      }
      return ok;
    } catch (_) {
      _lastError = 'Failed to update profile';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
