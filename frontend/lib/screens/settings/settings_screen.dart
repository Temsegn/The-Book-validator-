import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import '../../utils/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildSectionHeader('Appearance'),
          Card(
            child: SwitchListTile(
              title: Text('Dark Mode'),
              subtitle: Text('Toggle between light and dark theme'),
              value: themeProvider.isDarkMode,
              onChanged: (value) {
                themeProvider.toggleTheme();
              },
              activeColor: AppTheme.primaryGold,
            ),
          ),
          SizedBox(height: 20),
          
          _buildSectionHeader('Notifications'),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: Text('Push Notifications'),
                  subtitle: Text('Receive notifications about new content'),
                  value: true,
                  onChanged: (value) {},
                  activeColor: AppTheme.primaryGold,
                ),
                Divider(height: 1),
                SwitchListTile(
                  title: Text('Email Notifications'),
                  subtitle: Text('Receive email updates'),
                  value: false,
                  onChanged: (value) {},
                  activeColor: AppTheme.primaryGold,
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          
          _buildSectionHeader('Privacy'),
          Card(
            child: Column(
              children: [
                ListTile(
                  title: Text('Privacy Policy'),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {},
                ),
                Divider(height: 1),
                ListTile(
                  title: Text('Terms of Service'),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {},
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          
          _buildSectionHeader('About'),
          Card(
            child: Column(
              children: [
                ListTile(
                  title: Text('Version'),
                  subtitle: Text('1.0.0'),
                  trailing: Icon(Icons.info_outline),
                ),
                Divider(height: 1),
                ListTile(
                  title: Text('Contact Support'),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppTheme.primaryGold,
        ),
      ),
    );
  }
}
