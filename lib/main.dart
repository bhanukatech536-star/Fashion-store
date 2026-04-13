import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme.dart';
import 'controllers/auth_controller.dart';
import 'controllers/product_controller.dart';
import 'controllers/cart_controller.dart';
import 'controllers/order_controller.dart';
import 'controllers/user_controller.dart';
import 'controllers/wishlist_controller.dart';
import 'core/theme_controller.dart';
import 'views/auth/login_screen.dart';
import 'views/main_navigation.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => ProductController()),
        ChangeNotifierProvider(create: (_) => CartController()),
        ChangeNotifierProvider(create: (_) => OrderController()),
        ChangeNotifierProvider(create: (_) => UserController()),
        ChangeNotifierProvider(create: (_) => ThemeController()),
        ChangeNotifierProvider(create: (_) => WishlistController()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeController>(
      builder: (context, themeController, child) {
        return MaterialApp(
          title: 'Fashion Store',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeController.themeMode,
          debugShowCheckedModeBanner: false,
          home: Consumer<AuthController>(
            builder: (context, authController, _) {
              return authController.isAuthenticated
                  ? const MainNavigation()
                  : const LoginScreen();
            },
          ),
        );
      },
    );
  }
}
