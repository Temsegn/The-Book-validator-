import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/book_provider.dart';
import '../../providers/song_provider.dart';
import '../../models/book.dart';
import '../../models/song.dart';
import '../../utils/app_theme.dart';

class SubmitScreen extends StatefulWidget {
  @override
  _SubmitScreenState createState() => _SubmitScreenState();
}

class _SubmitScreenState extends State<SubmitScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_animationController);
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // Header
            Container(
              height: 250,
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
              child: SafeArea(
                child: Column(
                  children: [
                    // App Bar
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Expanded(
                          child: Text(
                            'Submit Content',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(width: 48),
                      ],
                    ),
                    SizedBox(height: 20),
                    
                    // Header Content
                    Icon(
                      Icons.add_circle_outline,
                      size: 80,
                      color: Colors.white,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Share with the Community',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Help grow our Orthodox library',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Tab Bar
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TabBar(
                controller: _tabController,
                indicatorColor: AppTheme.primaryGold,
                labelColor: AppTheme.primaryGold,
                unselectedLabelColor: Colors.grey,
                indicatorWeight: 3,
                tabs: [
                  Tab(
                    icon: Icon(Icons.menu_book),
                    text: 'Submit Book',
                  ),
                  Tab(
                    icon: Icon(Icons.music_note),
                    text: 'Submit Song',
                  ),
                ],
              ),
            ),
            
            // Tab Views
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  SubmitBookTab(),
                  SubmitSongTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}

class SubmitBookTab extends StatefulWidget {
  @override
  _SubmitBookTabState createState() => _SubmitBookTabState();
}

class _SubmitBookTabState extends State<SubmitBookTab>
    with AutomaticKeepAliveClientMixin {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _unitsController = TextEditingController();
  final _imageUrlController = TextEditingController();
  bool _isSubmitting = false;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Guidelines Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.lightBlue.withOpacity(0.1),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: AppTheme.lightBlue,
                          size: 24,
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Submission Guidelines',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.darkBlue,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    _buildGuidelineItem('📚', 'Only Orthodox Christian books'),
                    _buildGuidelineItem('✅', 'Provide accurate information'),
                    _buildGuidelineItem('👥', 'Admin review required'),
                    _buildGuidelineItem('🔔', 'You\'ll be notified of status'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            
            // Form Fields
            _buildFormField(
              controller: _titleController,
              label: 'Book Title',
              icon: Icons.book,
              hint: 'Enter the complete book title',
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter book title';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            
            _buildFormField(
              controller: _authorController,
              label: 'Author',
              icon: Icons.person,
              hint: 'Enter author\'s full name',
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter author name';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            
            _buildFormField(
              controller: _descriptionController,
              label: 'Description',
              icon: Icons.description,
              hint: 'Provide a detailed description',
              maxLines: 4,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter book description';
                }
                if (value.trim().length < 20) {
                  return 'Description must be at least 20 characters';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            
            _buildFormField(
              controller: _unitsController,
              label: 'Units Available',
              icon: Icons.inventory,
              hint: 'Estimated number of copies',
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter number of units';
                }
                final units = int.tryParse(value);
                if (units == null || units < 0) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            
            _buildFormField(
              controller: _imageUrlController,
              label: 'Image URL (Optional)',
              icon: Icons.image,
              hint: 'Link to book cover image',
            ),
            SizedBox(height: 40),
            
            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitBook,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryGold,
                  foregroundColor: AppTheme.darkBlue,
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: _isSubmitting
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: AppTheme.darkBlue,
                              strokeWidth: 2,
                            ),
                          ),
                          SizedBox(width: 16),
                          Text(
                            'Submitting...',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.send, size: 20),
                          SizedBox(width: 12),
                          Text(
                            'Submit Book for Review',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuidelineItem(String emoji, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(emoji, style: TextStyle(fontSize: 16)),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    String? Function(String?)? validator,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.darkBlue,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: AppTheme.primaryGold),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppTheme.primaryGold, width: 2),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
          ),
          validator: validator,
        ),
      ],
    );
  }

  Future<void> _submitBook() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final bookProvider = Provider.of<BookProvider>(context, listen: false);
      
      final book = Book(
        id: '',
        title: _titleController.text.trim(),
        author: _authorController.text.trim(),
        description: _descriptionController.text.trim(),
        unitsAvailable: int.parse(_unitsController.text.trim()),
        reviews: [],
        imageUrl: _imageUrlController.text.trim(),
        createdAt: DateTime.now(),
        isVerified: false,
      );

      final success = await bookProvider.submitBook(book);
      
      if (success) {
        _clearForm();
        _showSuccessDialog('Book submitted successfully!');
      } else {
        throw Exception('Failed to submit book');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to submit book: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  void _clearForm() {
    _titleController.clear();
    _authorController.clear();
    _descriptionController.clear();
    _unitsController.clear();
    _imageUrlController.clear();
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 64,
              ),
              SizedBox(height: 16),
              Text(
                'Success!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkBlue,
                ),
              ),
              SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Our admin team will review your submission.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGold,
                foregroundColor: AppTheme.darkBlue,
              ),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _descriptionController.dispose();
    _unitsController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }
}

class SubmitSongTab extends StatefulWidget {
  @override
  _SubmitSongTabState createState() => _SubmitSongTabState();
}

class _SubmitSongTabState extends State<SubmitSongTab>
    with AutomaticKeepAliveClientMixin {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _singerController = TextEditingController();
  final _lyricsController = TextEditingController();
  final _audioUrlController = TextEditingController();
  bool _isSubmitting = false;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Guidelines Card
            Card(
              elevation: 4,
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
                        SizedBox(width: 12),
                        Text(
                          'Submission Guidelines',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.darkBlue,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    _buildGuidelineItem('🎵', 'Only Orthodox hymns & chants'),
                    _buildGuidelineItem('📝', 'Complete and accurate lyrics'),
                    _buildGuidelineItem('🎧', 'Audio files are appreciated'),
                    _buildGuidelineItem('👥', 'Admin review required'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            
            // Form Fields
            _buildFormField(
              controller: _titleController,
              label: 'Song Title',
              icon: Icons.music_note,
              hint: 'Enter the song title',
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter song title';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            
            _buildFormField(
              controller: _singerController,
              label: 'Singer/Artist',
              icon: Icons.person,
              hint: 'Enter singer or choir name',
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter singer name';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            
            _buildFormField(
              controller: _lyricsController,
              label: 'Lyrics',
              icon: Icons.lyrics,
              hint: 'Enter the complete song lyrics',
              maxLines: 8,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter song lyrics';
                }
                if (value.trim().length < 20) {
                  return 'Lyrics must be at least 20 characters long';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            
            _buildFormField(
              controller: _audioUrlController,
              label: 'Audio URL (Optional)',
              icon: Icons.audiotrack,
              hint: 'Link to audio file',
            ),
            SizedBox(height: 40),
            
            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitSong,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryGold,
                  foregroundColor: AppTheme.darkBlue,
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: _isSubmitting
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: AppTheme.darkBlue,
                              strokeWidth: 2,
                            ),
                          ),
                          SizedBox(width: 16),
                          Text(
                            'Submitting...',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.send, size: 20),
                          SizedBox(width: 12),
                          Text(
                            'Submit Song for Review',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuidelineItem(String emoji, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(emoji, style: TextStyle(fontSize: 16)),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.darkBlue,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: AppTheme.primaryGold),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppTheme.primaryGold, width: 2),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
          ),
          validator: validator,
        ),
      ],
    );
  }

  Future<void> _submitSong() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final songProvider = Provider.of<SongProvider>(context, listen: false);
      
      final song = Song(
        id: '',
        title: _titleController.text.trim(),
        singer: _singerController.text.trim(),
        lyrics: _lyricsController.text.trim(),
        audioUrl: _audioUrlController.text.trim(),
        createdAt: DateTime.now(),
        isVerified: false,
      );

      final success = await songProvider.submitSong(song);
      
      if (success) {
        _clearForm();
        _showSuccessDialog('Song submitted successfully!');
      } else {
        throw Exception('Failed to submit song');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to submit song: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  void _clearForm() {
    _titleController.clear();
    _singerController.clear();
    _lyricsController.clear();
    _audioUrlController.clear();
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 64,
              ),
              SizedBox(height: 16),
              Text(
                'Success!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkBlue,
                ),
              ),
              SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Our admin team will review your submission.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGold,
                foregroundColor: AppTheme.darkBlue,
              ),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _singerController.dispose();
    _lyricsController.dispose();
    _audioUrlController.dispose();
    super.dispose();
  }
}
