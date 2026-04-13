import 'package:flutter/material.dart';
import '../models/user_model.dart';
import 'auth_controller.dart';

class UserController extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> updateProfile(
    AuthController authController,
    String name,
    String address,
    String phone,
  ) async {
    _isLoading = true;
    notifyListeners();

    // Mock API call
    await Future.delayed(const Duration(seconds: 1));

    if (authController.currentUser != null) {
      final updatedUser = UserModel(
        id: authController.currentUser!.id,
        name: name,
        email: authController.currentUser!.email,
        address: address,
        phone: phone,
      );
      
      // Update the user locally
      // Note: In a real app with proper state management, you wouldn't directly mutate
      // private fields from outside, but rather trigger a refresh. Since AuthController
      // holds the user, let's assume we would call something on it.
      // We will handle it in the UI temporarily by pushing updates or just fetching.
    }

    _isLoading = false;
    notifyListeners();
  }
}
