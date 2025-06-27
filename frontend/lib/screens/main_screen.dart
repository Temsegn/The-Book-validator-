import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/notification_provider.dart';
import '../providers/theme_provider.dart';
import '../utils/app_theme.dart';
import '../widgets/animated_drawer.dart';
import 'books/books_screen.dart';
import 'songs/songs_screen.dart';
import 'reports/report_screen.dart';
import 'submit/submit_screen.dart';
import 'admin/admin_panel.dart';
import 'notifications/notifications_screen.dart';
import 'profile/profile_screen.dart';
import 'favorites/favorites_screen.dart';
import 'search/search_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _fabAnimationController;
  late Animation<double> _fabAnimation;
  
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    
    _fabAnimationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    
    _fabAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.easeInOut,
    ));

    _fabAnimationController.forward();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NotificationProvider>(context, listen: false).loadNotifications();
    });
  }

  List<Widget> get _screens {
    final authProvider = Provider.of<AuthProvider>(context);
    return [
      BooksScreen(),
      SongsScreen(),
      SearchScreen(),
      FavoritesScreen(),
      if (authProvider.isAdmin) AdminPanel(),
    ];
  }

  List<BottomNavigationBarItem> get _bottomNavItems {
    final authProvider = Provider.of<AuthProvider>(context);
    return [
      BottomNavigationBarItem(
        icon: Icon(Icons.menu_book),
        activeIcon: Icon(Icons.menu_book, color: AppTheme.primaryGold),
        label: 'Books',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.music_note),
        activeIcon: Icon(Icons.music_note, color: AppTheme.primaryGold),
        label: 'Songs',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.search),
        activeIcon: Icon(Icons.search, color: AppTheme.primaryGold),
        label: 'Search',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.favorite_outline),
        activeIcon: Icon(Icons.favorite, color: AppTheme.primaryGold),
        label: 'Favorites',
      ),
      if (authProvider.isAdmin)
        BottomNavigationBarItem(
          icon: Icon(Icons.admin_panel_settings_outlined),
          activeIcon: Icon(Icons.admin_panel_settings, color: AppTheme.primaryGold),
          label: 'Admin',
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final notificationProvider = Provider.of<NotificationProvider>(context);

    return WillPopScope(
      onWillPop: () async {
        // Prevent back button from exiting the app
        if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
          Navigator.of(context).pop();
          return false;
        }
        return false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(_getAppBarTitle()),
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
          actions: [
            // Notifications
            Stack(
              children: [
                IconButton(
                  icon: Icon(Icons.notifications_outlined),
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            NotificationsScreen(),
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
                ),
                if (notificationProvider.unreadCount > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '${notificationProvider.unreadCount}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            // Profile
            IconButton(
              icon: CircleAvatar(
                radius: 16,
                backgroundColor: AppTheme.primaryGold,
                child: Text(
                  authProvider.user?.name.substring(0, 1).toUpperCase() ?? 'U',
                  style: TextStyle(
                    color: AppTheme.darkBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        ProfileScreen(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                  ),
                );
              },
            ),
          ],
        ),
        drawer: AnimatedDrawer(),
        body: AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          child: _screens[_currentIndex],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, -5),
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
              _fabAnimationController.reset();
              _fabAnimationController.forward();
            },
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppTheme.primaryGold,
            unselectedItemColor: Colors.grey,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
            items: _bottomNavItems,
          ),
        ),
        floatingActionButton: ScaleTransition(
          scale: _fabAnimation,
          child: FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      SubmitScreen(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: Offset(0.0, 1.0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    );
                  },
                ),
              );
            },
            backgroundColor: AppTheme.primaryGold,
            foregroundColor: AppTheme.darkBlue,
            icon: Icon(Icons.add),
            label: Text('Submit'),
            elevation: 6,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  String _getAppBarTitle() {
    switch (_currentIndex) {
      case 0:
        return 'Orthodox Books';
      case 1:
        return 'Orthodox Songs';
      case 2:
        return 'Search';
      case 3:
        return 'Favorites';
      case 4:
        return 'Admin Panel';
      default:
        return 'Orthodox Catalog';
    }
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    super.dispose();
  }
}
