import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // App Logo
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppTheme.primaryGold,
                    AppTheme.darkGold,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryGold.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Icon(
                Icons.auto_stories,
                size: 60,
                color: AppTheme.darkBlue,
              ),
            ),
            SizedBox(height: 30),
            
            Text(
              'Orthodox Catalog',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppTheme.darkBlue,
              ),
            ),
            SizedBox(height: 10),
            
            Text(
              'Version 1.0.0',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: 30),
            
            Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'About This App',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryGold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Orthodox Catalog is a comprehensive digital library dedicated to preserving and sharing Orthodox Christian literature and music. Our mission is to make Orthodox resources accessible to believers worldwide.',
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            
            Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Features',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryGold,
                      ),
                    ),
                    SizedBox(height: 16),
                    _buildFeatureItem('📚', 'Extensive book collection'),
                    _buildFeatureItem('🎵', 'Orthodox songs and hymns'),
                    _buildFeatureItem('🔍', 'Advanced search functionality'),
                    _buildFeatureItem('⭐', 'Favorites and bookmarks'),
                    _buildFeatureItem('📝', 'User reviews and ratings'),
                    _buildFeatureItem('📱', 'Modern, intuitive interface'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            
            Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Contact Us',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryGold,
                      ),
                    ),
                    SizedBox(height: 16),
                    _buildContactItem(Icons.email, 'support@orthodoxcatalog.com'),
                    _buildContactItem(Icons.web, 'www.orthodoxcatalog.com'),
                    _buildContactItem(Icons.phone, '+1 (555) 123-4567'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
            
            Text(
              '© 2024 Orthodox Catalog. All rights reserved.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String emoji, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(emoji, style: TextStyle(fontSize: 18)),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryGold, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
