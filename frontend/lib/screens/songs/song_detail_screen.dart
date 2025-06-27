import 'package:flutter/material.dart';
import '../../models/song.dart';
import '../../utils/app_theme.dart';

class SongDetailScreen extends StatefulWidget {
  final Song song;

  const SongDetailScreen({Key? key, required this.song}) : super(key: key);

  @override
  _SongDetailScreenState createState() => _SongDetailScreenState();
}

class _SongDetailScreenState extends State<SongDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: Offset(0.0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppTheme.darkBlue,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppTheme.darkBlue,
                      AppTheme.lightBlue,
                      AppTheme.primaryGold.withOpacity(0.3),
                    ],
                  ),
                ),
                child: Center(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 60),
                        Hero(
                          tag: 'song_${widget.song.id}',
                          child: Container(
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
                                  color: AppTheme.primaryGold.withOpacity(0.5),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.music_note,
                              size: 60,
                              color: AppTheme.darkBlue,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          widget.song.title,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.3),
                                offset: Offset(1, 1),
                                blurRadius: 3,
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'by ${widget.song.singer}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.favorite_border, color: Colors.white),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Added to favorites!'),
                      backgroundColor: AppTheme.primaryGold,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.share, color: Colors.white),
                onPressed: () {
                  // Share functionality
                },
              ),
            ],
          ),
          
          // Content
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Audio Player
                      if (widget.song.audioUrl.isNotEmpty) ...[
                        Card(
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: LinearGradient(
                                colors: [
                                  AppTheme.primaryGold.withOpacity(0.1),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isPlaying = !_isPlaying;
                                    });
                                  },
                                  child: Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppTheme.primaryGold,
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppTheme.primaryGold.withOpacity(0.3),
                                          blurRadius: 10,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      _isPlaying ? Icons.pause : Icons.play_arrow,
                                      color: AppTheme.darkBlue,
                                      size: 30,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Orthodox Hymn',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.darkBlue,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        _isPlaying ? 'Now Playing...' : 'Tap to play',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.audiotrack,
                                  color: AppTheme.primaryGold,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 24),
                      ],
                      
                      // Lyrics Section
                      Row(
                        children: [
                          Icon(
                            Icons.lyrics,
                            color: AppTheme.primaryGold,
                            size: 24,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Lyrics',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.darkBlue,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white,
                                AppTheme.cream.withOpacity(0.3),
                              ],
                            ),
                          ),
                          child: Text(
                            widget.song.lyrics,
                            style: TextStyle(
                              fontSize: 16,
                              height: 1.8,
                              color: AppTheme.darkBlue,
                              fontFamily: 'Serif',
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      
                      // Song Info
                      Card(
                        elevation: 4,
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
                                    Icons.info_outline,
                                    color: AppTheme.primaryGold,
                                    size: 24,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Song Information',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.darkBlue,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              _buildInfoRow('Title', widget.song.title),
                              _buildInfoRow('Singer/Artist', widget.song.singer),
                              _buildInfoRow('Added', _formatDate(widget.song.createdAt)),
                              _buildInfoRow('Status', widget.song.isVerified ? 'Verified' : 'Pending'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: AppTheme.darkBlue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
