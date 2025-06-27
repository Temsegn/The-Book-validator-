import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/book_provider.dart';
import '../../providers/song_provider.dart';
import '../../providers/notification_provider.dart';
import '../../utils/app_theme.dart';
import '../../widgets/dashboard_stats_card.dart';
import '../../widgets/recent_activity_card.dart';
import '../../widgets/quick_actions_card.dart';
import '../../widgets/featured_content_card.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<double>> _cardAnimations;
  late List<Animation<Offset>> _slideAnimations;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );

    // Create staggered animations for cards
    _cardAnimations = List.generate(4, (index) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          index * 0.1,
          0.6 + (index * 0.1),
          curve: Curves.easeOutBack,
        ),
      ));
    });

    _slideAnimations = List.generate(4, (index) {
      return Tween<Offset>(
        begin: Offset(0.0, 0.5),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          index * 0.1,
          0.6 + (index * 0.1),
          curve: Curves.easeOutBack,
        ),
      ));
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDashboardData();
      _animationController.forward();
    });
  }

  void _loadDashboardData() {
    final bookProvider = Provider.of<BookProvider>(context, listen: false);
    final songProvider = Provider.of<SongProvider>(context, listen: false);
    final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
    
    bookProvider.loadBooks();
    songProvider.loadSongs();
    notificationProvider.loadNotifications();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final bookProvider = Provider.of<BookProvider>(context);
    final songProvider = Provider.of<SongProvider>(context);
    final notificationProvider = Provider.of<NotificationProvider>(context);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          _loadDashboardData();
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              SlideTransition(
                position: _slideAnimations[0],
                child: FadeTransition(
                  opacity: _cardAnimations[0],
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppTheme.darkBlue,
                          AppTheme.lightBlue,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.darkBlue.withOpacity(0.3),
                          blurRadius: 15,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: AppTheme.primaryGold,
                              child: Text(
                                authProvider.user?.name.substring(0, 1).toUpperCase() ?? 'U',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.darkBlue,
                                ),
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Welcome back,',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white.withOpacity(0.8),
                                    ),
                                  ),
                                  Text(
                                    authProvider.user?.name ?? 'User',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Continue your spiritual journey with our collection of Orthodox books and hymns.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.9),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 24),

              // Stats Cards
              SlideTransition(
                position: _slideAnimations[1],
                child: FadeTransition(
                  opacity: _cardAnimations[1],
                  child: DashboardStatsCard(
                    totalBooks: bookProvider.books.length,
                    totalSongs: songProvider.songs.length,
                    unreadNotifications: notificationProvider.unreadCount,
                    isAdmin: authProvider.isAdmin,
                  ),
                ),
              ),

              SizedBox(height: 24),

              // Quick Actions
              SlideTransition(
                position: _slideAnimations[2],
                child: FadeTransition(
                  opacity: _cardAnimations[2],
                  child: QuickActionsCard(),
                ),
              ),

              SizedBox(height: 24),

              // Featured Content
              SlideTransition(
                position: _slideAnimations[3],
                child: FadeTransition(
                  opacity: _cardAnimations[3],
                  child: FeaturedContentCard(
                    featuredBooks: bookProvider.books.take(3).toList(),
                    featuredSongs: songProvider.songs.take(3).toList(),
                  ),
                ),
              ),

              SizedBox(height: 24),

              // Recent Activity
              SlideTransition(
                position: _slideAnimations[3],
                child: FadeTransition(
                  opacity: _cardAnimations[3],
                  child: RecentActivityCard(
                    recentNotifications: notificationProvider.notifications.take(5).toList(),
                  ),
                ),
              ),

              SizedBox(height: 100), // Bottom padding for FAB
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
