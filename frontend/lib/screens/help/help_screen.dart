import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';

class HelpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help & Support'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildHelpSection(
            'Getting Started',
            [
              _buildHelpItem(
                'How to browse books?',
                'Navigate to the Books tab to explore our collection of Orthodox literature.',
              ),
              _buildHelpItem(
                'How to search for content?',
                'Use the Search tab to find specific books, songs, or authors.',
              ),
              _buildHelpItem(
                'How to add favorites?',
                'Tap the heart icon on any book or song to add it to your favorites.',
              ),
            ],
          ),
          _buildHelpSection(
            'Account & Profile',
            [
              _buildHelpItem(
                'How to edit my profile?',
                'Go to your profile page and tap the edit button to update your information.',
              ),
              _buildHelpItem(
                'How to change my password?',
                'Visit Settings > Security to change your password.',
              ),
            ],
          ),
          _buildHelpSection(
            'Content Submission',
            [
              _buildHelpItem(
                'How to submit a book?',
                'Use the Submit button to add new books for admin review.',
              ),
              _buildHelpItem(
                'How to report missing content?',
                'Use the Report feature in the menu to notify us about missing books or songs.',
              ),
              _buildHelpItem(
                'What happens after I submit content?',
                'All submissions are reviewed by our admin team before being published.',
              ),
            ],
          ),
          _buildHelpSection(
            'Technical Support',
            [
              _buildHelpItem(
                'App is running slowly',
                'Try closing and reopening the app. If the issue persists, restart your device.',
              ),
              _buildHelpItem(
                'Content not loading',
                'Check your internet connection and try refreshing the page.',
              ),
              _buildHelpItem(
                'Login issues',
                'Ensure you\'re using the correct email and password. Use "Forgot Password" if needed.',
              ),
            ],
          ),
          SizedBox(height: 30),
          Card(
            color: AppTheme.primaryGold.withOpacity(0.1),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Icon(
                    Icons.support_agent,
                    size: 48,
                    color: AppTheme.primaryGold,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Still Need Help?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkBlue,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Contact our support team for personalized assistance',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Contact support functionality
                    },
                    child: Text('Contact Support'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(0, 20, 0, 16),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryGold,
            ),
          ),
        ),
        Card(
          child: Column(
            children: items,
          ),
        ),
      ],
    );
  }

  Widget _buildHelpItem(String question, String answer) {
    return ExpansionTile(
      title: Text(
        question,
        style: TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Text(
            answer,
            style: TextStyle(
              fontSize: 15,
              height: 1.5,
              color: Colors.grey.shade700,
            ),
          ),
        ),
      ],
    );
  }
}
