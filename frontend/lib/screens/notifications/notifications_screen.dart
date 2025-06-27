import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/notification_provider.dart';
import '../../models/notification.dart';
import '../../utils/app_theme.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_animationController);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NotificationProvider>(context, listen: false).loadNotifications();
      _animationController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        actions: [
          Consumer<NotificationProvider>(
            builder: (context, notificationProvider, child) {
              if (notificationProvider.unreadCount > 0) {
                return TextButton.icon(
                  onPressed: _markAllAsRead,
                  icon: Icon(Icons.done_all, color: Colors.white, size: 18),
                  label: Text(
                    'Mark All Read',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }
              return SizedBox.shrink();
            },
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Consumer<NotificationProvider>(
          builder: (context, notificationProvider, child) {
            if (notificationProvider.isLoading) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryGold),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Loading notifications...',
                      style: TextStyle(
                        color: AppTheme.darkBlue,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              );
            }

            if (notificationProvider.notifications.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.primaryGold.withOpacity(0.2),
                            AppTheme.lightBlue.withOpacity(0.1),
                          ],
                        ),
                      ),
                      child: Icon(
                        Icons.notifications_none,
                        size: 60,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 24),
                    Text(
                      'No notifications',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'You\'re all caught up!',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(height: 24),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryGold.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '🔔 Stay tuned for updates!',
                        style: TextStyle(
                          color: AppTheme.darkBlue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () => notificationProvider.loadNotifications(),
              color: AppTheme.primaryGold,
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: notificationProvider.notifications.length,
                itemBuilder: (context, index) {
                  final notification = notificationProvider.notifications[index];
                  return TweenAnimationBuilder<double>(
                    duration: Duration(milliseconds: 300 + (index * 100)),
                    tween: Tween(begin: 0.0, end: 1.0),
                    builder: (context, value, child) {
                      return Transform.translate(
                        offset: Offset((1 - value) * 100, 0),
                        child: Opacity(
                          opacity: value,
                          child: NotificationCard(
                            notification: notification,
                            onTap: () => _markAsRead(notification),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  void _markAsRead(AppNotification notification) {
    if (!notification.isRead) {
      Provider.of<NotificationProvider>(context, listen: false)
          .markAsRead(notification.id);
    }
  }

  void _markAllAsRead() {
    final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
    for (final notification in notificationProvider.notifications) {
      if (!notification.isRead) {
        notificationProvider.markAsRead(notification.id);
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class NotificationCard extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback onTap;

  const NotificationCard({
    Key? key,
    required this.notification,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: notification.isRead ? 2 : 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: notification.isRead 
            ? Theme.of(context).cardColor 
            : AppTheme.primaryGold.withOpacity(0.05),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Notification Icon
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: notification.isRead 
                          ? [Colors.grey.shade300, Colors.grey.shade200]
                          : [AppTheme.primaryGold, AppTheme.darkGold],
                    ),
                    boxShadow: notification.isRead ? [] : [
                      BoxShadow(
                        color: AppTheme.primaryGold.withOpacity(0.3),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    _getNotificationIcon(notification.title),
                    color: notification.isRead 
                        ? Colors.grey.shade600 
                        : AppTheme.darkBlue,
                    size: 24,
                  ),
                ),
                SizedBox(width: 16),
                
                // Notification Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: notification.isRead 
                                    ? FontWeight.w500 
                                    : FontWeight.bold,
                                color: notification.isRead 
                                    ? Colors.grey.shade700 
                                    : AppTheme.darkBlue,
                              ),
                            ),
                          ),
                          if (!notification.isRead)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: AppTheme.primaryGold,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        notification.message,
                        style: TextStyle(
                          fontSize: 14,
                          color: notification.isRead 
                              ? Colors.grey.shade600 
                              : Colors.grey.shade700,
                          height: 1.4,
                        ),
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: Colors.grey.shade500,
                          ),
                          SizedBox(width: 4),
                          Text(
                            _formatDate(notification.createdAt),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getNotificationIcon(String title) {
    if (title.toLowerCase().contains('book')) {
      return Icons.menu_book;
    } else if (title.toLowerCase().contains('song')) {
      return Icons.music_note;
    } else if (title.toLowerCase().contains('admin')) {
      return Icons.admin_panel_settings;
    } else if (title.toLowerCase().contains('welcome')) {
      return Icons.celebration;
    }
    return Icons.notifications;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 7) {
      return '${date.day}/${date.month}/${date.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }
}
