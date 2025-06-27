import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/book_provider.dart';
import '../../providers/song_provider.dart';
import '../../providers/admin_provider.dart';
import '../../models/book.dart';
import '../../models/song.dart';
import '../../utils/app_theme.dart';

class PendingContentScreen extends StatefulWidget {
  @override
  _PendingContentScreenState createState() => _PendingContentScreenState();
}

class _PendingContentScreenState extends State<PendingContentScreen>
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
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPendingContent();
      _animationController.forward();
    });
  }

  void _loadPendingContent() {
    final bookProvider = Provider.of<BookProvider>(context, listen: false);
    final songProvider = Provider.of<SongProvider>(context, listen: false);
    
    bookProvider.loadBooks(status: 'pending');
    songProvider.loadSongs(status: 'pending');
  }

  @override
  Widget build(BuildContext context) {
    final bookProvider = Provider.of<BookProvider>(context);
    final songProvider = Provider.of<SongProvider>(context);
    
    final pendingBooks = bookProvider.books.where((book) => book.status == 'pending').toList();
    final pendingSongs = songProvider.songs.where((song) => song.status == 'pending').toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Pending Content'),
        backgroundColor: AppTheme.darkBlue,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.primaryGold,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(text: 'Books (${pendingBooks.length})'),
            Tab(text: 'Songs (${pendingSongs.length})'),
          ],
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildPendingBooksTab(pendingBooks),
            _buildPendingSongsTab(pendingSongs),
          ],
        ),
      ),
    );
  }

  Widget _buildPendingBooksTab(List<Book> pendingBooks) {
    if (pendingBooks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.book_outlined,
              size: 80,
              color: Colors.grey,
            ),
            SizedBox(height: 20),
            Text(
              'No pending book submissions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'All book submissions have been reviewed',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: pendingBooks.length,
      itemBuilder: (context, index) {
        final book = pendingBooks[index];
        return _buildPendingBookCard(book);
      },
    );
  }

  Widget _buildPendingSongsTab(List<Song> pendingSongs) {
    if (pendingSongs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.music_note_outlined,
              size: 80,
              color: Colors.grey,
            ),
            SizedBox(height: 20),
            Text(
              'No pending song submissions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'All song submissions have been reviewed',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: pendingSongs.length,
      itemBuilder: (context, index) {
        final song = pendingSongs[index];
        return _buildPendingSongCard(song);
      },
    );
  }

  Widget _buildPendingBookCard(Book book) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ExpansionTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.book,
            color: Colors.orange,
          ),
        ),
        title: Text(
          book.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.darkBlue,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('by ${book.author}'),
            SizedBox(height: 4),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'PENDING REVIEW',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade700,
                ),
              ),
            ),
          ],
        ),
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('Category', book.category),
                _buildDetailRow('Language', book.language),
                _buildDetailRow('Pages', book.pageCount.toString()),
                _buildDetailRow('Units Available', book.unitsAvailable.toString()),
                if (book.isbn.isNotEmpty)
                  _buildDetailRow('ISBN', book.isbn),
                SizedBox(height: 12),
                Text(
                  'Description:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkBlue,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  book.description,
                  style: TextStyle(height: 1.4),
                ),
                if (book.tags.isNotEmpty) ...[
                  SizedBox(height: 12),
                  Text(
                    'Tags:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkBlue,
                    ),
                  ),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: book.tags.map((tag) => Chip(
                      label: Text(
                        tag,
                        style: TextStyle(fontSize: 12),
                      ),
                      backgroundColor: AppTheme.primaryGold.withOpacity(0.2),
                    )).toList(),
                  ),
                ],
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _approveBook(book.id),
                        icon: Icon(Icons.check, size: 18),
                        label: Text('Approve'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _rejectBook(book.id),
                        icon: Icon(Icons.close, size: 18),
                        label: Text('Reject'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingSongCard(Song song) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ExpansionTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.music_note,
            color: Colors.orange,
          ),
        ),
        title: Text(
          song.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.darkBlue,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('by ${song.singer}'),
            SizedBox(height: 4),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'PENDING REVIEW',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade700,
                ),
              ),
            ),
          ],
        ),
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('Category', song.category),
                _buildDetailRow('Language', song.language),
                if (song.duration > 0)
                  _buildDetailRow('Duration', '${(song.duration / 60).floor()}:${(song.duration % 60).toString().padLeft(2, '0')}'),
                SizedBox(height: 12),
                Text(
                  'Lyrics:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkBlue,
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    song.lyrics,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ),
                if (song.tags.isNotEmpty) ...[
                  SizedBox(height: 12),
                  Text(
                    'Tags:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkBlue,
                    ),
                  ),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: song.tags.map((tag) => Chip(
                      label: Text(
                        tag,
                        style: TextStyle(fontSize: 12),
                      ),
                      backgroundColor: AppTheme.primaryGold.withOpacity(0.2),
                    )).toList(),
                  ),
                ],
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _approveSong(song.id),
                        icon: Icon(Icons.check, size: 18),
                        label: Text('Approve'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _rejectSong(song.id),
                        icon: Icon(Icons.close, size: 18),
                        label: Text('Reject'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: AppTheme.darkBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _approveBook(String bookId) async {
    final adminProvider = Provider.of<AdminProvider>(context, listen: false);
    final success = await adminProvider.approveContent('books', bookId);
    
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Book approved successfully'),
          backgroundColor: Colors.green,
        ),
      );
      _loadPendingContent();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to approve book'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _rejectBook(String bookId) async {
    final reason = await _showRejectDialog();
    if (reason != null) {
      final adminProvider = Provider.of<AdminProvider>(context, listen: false);
      final success = await adminProvider.rejectContent('books', bookId, reason);
      
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Book rejected'),
            backgroundColor: Colors.orange,
          ),
        );
        _loadPendingContent();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to reject book'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _approveSong(String songId) async {
    final adminProvider = Provider.of<AdminProvider>(context, listen: false);
    final success = await adminProvider.approveContent('songs', songId);
    
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Song approved successfully'),
          backgroundColor: Colors.green,
        ),
      );
      _loadPendingContent();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to approve song'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _rejectSong(String songId) async {
    final reason = await _showRejectDialog();
    if (reason != null) {
      final adminProvider = Provider.of<AdminProvider>(context, listen: false);
      final success = await adminProvider.rejectContent('songs', songId, reason);
      
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Song rejected'),
            backgroundColor: Colors.orange,
          ),
        );
        _loadPendingContent();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to reject song'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<String?> _showRejectDialog() async {
    final reasonController = TextEditingController();
    
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text('Reject Content'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Please provide a reason for rejection:'),
            SizedBox(height: 16),
            TextField(
              controller: reasonController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Enter rejection reason...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (reasonController.text.trim().isNotEmpty) {
                Navigator.pop(context, reasonController.text.trim());
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('Reject'),
          ),
        ],
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
