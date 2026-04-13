import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme_controller.dart';
import '../../widgets/animations.dart';
import 'help_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = context.watch<ThemeController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text(
            'App Settings',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ListTile(
            title: const Text('Dark Mode'),
            trailing: Switch(
              value: themeController.isDarkMode,
              onChanged: (val) {
                themeController.toggleTheme();
              },
            ),
          ),
          const Divider(),
          const ListTile(
            title: Text('Language'),
            trailing: Text('English', style: TextStyle(color: Colors.grey)),
          ),
          const Divider(),
          ListTile(
            title: const Text('Help & Support'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpScreen()),
              );
            },
          ),
          const SizedBox(height: 32),
          const Text(
            'About',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const ListTile(
            title: Text('Privacy Policy'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
          ),
          const ListTile(
            title: Text('Terms of Service'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
          ),
          const ListTile(
            title: Text('App Version'),
            trailing: Text('1.0.0', style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }
}
