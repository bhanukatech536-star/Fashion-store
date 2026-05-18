import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/animations.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late final AnimationController _headerCtrl;
  late final Animation<double> _headerFade;
  late final Animation<Offset> _headerSlide;

  @override
  void initState() {
    super.initState();
    _headerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _headerFade =
        CurvedAnimation(parent: _headerCtrl, curve: Curves.easeOut);
    _headerSlide = Tween<Offset>(
      begin: const Offset(0, -0.2),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _headerCtrl, curve: Curves.easeOut));
    _headerCtrl.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _headerCtrl.dispose();
    super.dispose();
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      final success = await context.read<AuthController>().register(
            _nameController.text,
            _emailController.text,
            _passwordController.text,
          );
      if (success && mounted) {
        Navigator.pop(context);
      } else if (mounted) {
        final msg = context.read<AuthController>().lastError ??
            'Registration failed. Please try again.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(msg),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthController>().isLoading;

    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        appBar: AppBar(title: const Text('Create Account')),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header ──────────────────────────────────────
                  FadeTransition(
                    opacity: _headerFade,
                    child: SlideTransition(
                      position: _headerSlide,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Join Us',
                            style: Theme.of(context).textTheme.displayLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Start your BH Cloths journey.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // ── Fields with staggered delays ─────────────────
                  FadeInWidget(
                    delay: const Duration(milliseconds: 200),
                    child: CustomTextField(
                      label: 'Full Name',
                      hint: 'Enter your full name',
                      controller: _nameController,
                      validator: (val) => val != null && val.isNotEmpty
                          ? null
                          : 'Name is required',
                    ),
                  ),
                  FadeInWidget(
                    delay: const Duration(milliseconds: 280),
                    child: CustomTextField(
                      label: 'Email',
                      hint: 'Enter your email',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (val) =>
                          val != null && val.contains('@')
                              ? null
                              : 'Enter a valid email',
                    ),
                  ),
                  FadeInWidget(
                    delay: const Duration(milliseconds: 360),
                    child: CustomTextField(
                      label: 'Password',
                      hint: 'Create a password',
                      controller: _passwordController,
                      isPassword: true,
                      validator: (val) => val != null && val.length >= 6
                          ? null
                          : 'Password must be 6+ characters',
                    ),
                  ),

                  const SizedBox(height: 8),
                  FadeInWidget(
                    delay: const Duration(milliseconds: 440),
                    child: CustomButton(
                      text: 'REGISTER',
                      isLoading: false,
                      onPressed: isLoading ? () {} : _register,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
