import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class QuickActionsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.flash_on,
                  color: AppTheme.primaryGold,
                  size: 24,
                ),
                SizedBox(width: 12),
                Text(
                  'Quick Actions',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkBlue,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: [
                _buildActionButton(
                  context,
                  icon: Icons.book_outlined,
                  label: 'Browse Books',
                  color: Colors.blue,
                  onTap: () {
                    // Navigate to books screen
                    DefaultTabController.of(context)?.animateTo(1);
                  },
                ),
                _buildActionButton(
                  context,
                  icon: Icons.music_note_outlined,
                  label: 'Browse Songs',
                  color: Colors.orange,
                  onTap: () {
                    // Navigate to songs screen
                    DefaultTabController.of(context)?.animateTo(2);
                  },
                ),
                _buildActionButton(
                  context,
                  icon: Icons.add_circle_outline,
                  label: 'Submit Content',
                  color: Colors.green,
                  onTap: () {
                    // Navigate to submit screen
                    DefaultTabController.of(context)?.animateTo(4);
                  },
                ),
                _buildActionButton(
                  context,
                  icon: Icons.favorite_outline,
                  label: 'My Favorites',
                  color: Colors.red,
                  onTap: () {
                    // Navigate to favorites screen
                    DefaultTabController.of(context)?.animateTo(3);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: 32,
            ),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
