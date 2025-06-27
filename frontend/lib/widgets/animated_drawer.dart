import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import '../utils/app_theme.dart';
import '../screens/reports/report_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/about/about_screen.dart';
import '../screens/help/help_screen.dart';

class AnimatedDrawer extends StatefulWidget {
  @override
  _AnimatedDrawerState createState() => _AnimatedDrawerState();
}

class _AnimatedDrawerState extends State<AnimatedDrawer>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeInOut,
    ));
    _slideController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return SlideTransition(
      position: _slideAnimation,
      child: Drawer(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).primaryColor.withOpacity(0.1),
                Theme.of(context).scaffoldBackgroundColor,
              ],
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              _buildDrawerHeader(authProvider),
              _buildAnimatedTile(
                icon: Icons.dashboard_outlined,
                title: 'Dashboard',
                onTap: () {
                  Navigator.pop(context);
                },
                delay: 100,
              ),
              _buildAnimatedTile(
                icon: Icons.report_outlined,
                title: 'Report Content',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          ReportScreen(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: Offset(1.0, 0.0),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        );
                      },
                    ),
                  );
                },
                delay: 200,
              ),
              if (authProvider.isAdmin) ...[
                Divider(color: AppTheme.primaryGold.withOpacity(0.3)),
                _buildSectionHeader('Admin Tools'),
                _buildAnimatedTile(
                  icon: Icons.admin_panel_settings_outlined,
                  title: 'Admin Dashboard',
                  onTap: () {
                    Navigator.pop(context);
                  },
                  delay: 300,
                  isAdmin: true,
                ),
                _buildAnimatedTile(
                  icon: Icons.people_outline,
                  title: 'Manage Users',
                  onTap: () {
                    Navigator.pop(context);
                    _showComingSoon(context);
                  },
                  delay: 400,
                  isAdmin: true,
                ),
                _buildAnimatedTile(
                  icon: Icons.pending_actions_outlined,
                  title: 'Pending Reviews',
                  onTap: () {
                    Navigator.pop(context);
                    _showComingSoon(context);
                  },
                  delay: 500,
                  isAdmin: true,
                ),
              ],
              Divider(color: AppTheme.primaryGold.withOpacity(0.3)),
              _buildSectionHeader('Settings'),
              _buildAnimatedTile(
                icon: themeProvider.isDarkMode 
                    ? Icons.light_mode_outlined 
                    : Icons.dark_mode_outlined,
                title: themeProvider.isDarkMode ? 'Light Mode' : 'Dark Mode',
                onTap: () {
                  themeProvider.toggleTheme();
                },
                delay: 600,
              ),
              _buildAnimatedTile(
                icon: Icons.settings_outlined,
                title: 'Settings',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          SettingsScreen(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                    ),
                  );
                },
                delay: 700,
              ),
              _buildAnimatedTile(
                icon: Icons.help_outline,
                title: 'Help & Support',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          HelpScreen(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                    ),
                  );
                },
                delay: 800,
              ),
              _buildAnimatedTile(
                icon: Icons.info_outline,
                title: 'About',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          AboutScreen(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                    ),
                  );
                },
                delay: 900,
              ),
              Divider(color: AppTheme.primaryGold.withOpacity(0.3)),
              _buildAnimatedTile(
                icon: Icons.logout,
                title: 'Logout',
                onTap: () {
                  _showLogoutDialog(context, authProvider);
                },
                delay: 1000,
                isLogout: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerHeader(AuthProvider authProvider) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.darkBlue,
            AppTheme.lightBlue,
          ],
        ),
      ),
      child: DrawerHeader(
        decoration: BoxDecoration(color: Colors.transparent),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 35,
              backgroundColor: AppTheme.primaryGold,
              child: Text(
                authProvider.user?.name.substring(0, 1).toUpperCase() ?? 'U',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkBlue,
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              authProvider.user?.name ?? 'User',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              authProvider.user?.email ?? '',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
            if (authProvider.isAdmin) ...[
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGold,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'ADMIN',
                  style: TextStyle(
                    color: AppTheme.darkBlue,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppTheme.primaryGold,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildAnimatedTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required int delay,
    bool isAdmin = false,
    bool isLogout = false,
  }) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + delay),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset((1 - value) * 100, 0),
          child: Opacity(
            opacity: value,
            child: ListTile(
              leading: Icon(
                icon,
                color: isLogout 
                    ? Colors.red 
                    : isAdmin 
                        ? AppTheme.primaryGold 
                        : Theme.of(context).iconTheme.color,
              ),
              title: Text(
                title,
                style: TextStyle(
                  color: isLogout 
                      ? Colors.red 
                      : isAdmin 
                          ? AppTheme.primaryGold 
                          : Theme.of(context).textTheme.bodyLarge?.color,
                  fontWeight: isAdmin ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
              onTap: onTap,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            ),
          ),
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                authProvider.logout();
                Navigator.pushReplacementNamed(context, '/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Feature coming soon!'),
        backgroundColor: AppTheme.primaryGold,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }
}
