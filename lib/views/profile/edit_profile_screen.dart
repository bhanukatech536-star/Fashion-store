import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/user_controller.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/animations.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthController>().currentUser;
    if (user != null) {
      _nameController.text = user.name;
      _addressController.text = user.address;
      _phoneController.text = user.phone;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final authController = context.read<AuthController>();
      final userController = context.read<UserController>();
      
      await userController.updateProfile(
        authController,
        _nameController.text,
        _addressController.text,
        _phoneController.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<UserController>().isLoading;

    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Profile'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                      child: const Icon(Icons.person, size: 50, color: Colors.grey),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt, size: 20, color: Colors.black),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                CustomTextField(
                  label: 'Full Name',
                  hint: 'Enter your name',
                  controller: _nameController,
                  validator: (val) => val == null || val.isEmpty ? 'Name is required' : null,
                ),
                CustomTextField(
                  label: 'Phone Number',
                  hint: 'Enter your phone number',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                ),
                CustomTextField(
                  label: 'Shipping Address',
                  hint: 'Enter your address',
                  controller: _addressController,
                  keyboardType: TextInputType.multiline,
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: 'SAVE CHANGES',
                  onPressed: _saveProfile,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
