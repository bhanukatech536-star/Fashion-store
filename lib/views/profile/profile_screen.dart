import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/auth_controller.dart';
import '../orders/order_history_screen.dart';
import '../wishlist/wishlist_screen.dart';
import '../notifications/notifications_screen.dart';
import '../settings/settings_screen.dart';
import 'edit_profile_screen.dart';
import '../../core/theme.dart';
import '../../widgets/animations.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = context.watch<AuthController>();
    final user = authController.currentUser;

    if (user == null) {
      return const Center(child: Text('Not logged in'));
    }

    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 40),
          FadeInWidget(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
                  child: Text(
                    user.displayInitial,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  user.name.isNotEmpty ? user.name : user.email,
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  user.email,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                if (user.phone.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    user.phone,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
                if (user.address.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      user.address,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      AppPageRoute(child: const EditProfileScreen()),
                    );
                  },
                  child: const Text('Edit Profile'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              children: [
                _buildListTile(
                  context,
                  index: 0,
                  icon: Icons.shopping_bag_outlined,
                  title: 'Order History',
                  onTap: () {
                    Navigator.push(
                      context,
                      AppPageRoute(child: const OrderHistoryScreen()),
                    );
                  },
                ),
                _buildListTile(
                  context,
                  index: 1,
                  icon: Icons.favorite_outline,
                  title: 'My Wishlist',
                  onTap: () {
                    Navigator.push(
                      context,
                      AppPageRoute(child: const WishlistScreen()),
                    );
                  },
                ),
                _buildListTile(
                  context,
                  index: 2,
                  icon: Icons.notifications_none,
                  title: 'Notifications',
                  onTap: () {
                    Navigator.push(
                      context,
                      AppPageRoute(child: const NotificationsScreen()),
                    );
                  },
                ),
                _buildListTile(
                  context,
                  index: 3,
                  icon: Icons.settings_outlined,
                  title: 'Settings',
                  onTap: () {
                    Navigator.push(
                      context,
                      AppPageRoute(child: const SettingsScreen()),
                    );
                  },
                ),
                _buildListTile(
                  context,
                  index: 4,
                  icon: Icons.logout,
                  title: 'Logout',
                  color: AppTheme.errorColor,
                  onTap: () async {
                    await authController.logout();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context, {
    required int index,
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    Color? color,
  }) {
    final iconColor = color ?? Theme.of(context).textTheme.bodyLarge?.color;

    return StaggeredItem(
      index: index,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: (iconColor ?? Colors.black).withValues(alpha: 0.05),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: color ?? Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        subtitle: subtitle != null ? Text(subtitle) : null,
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
