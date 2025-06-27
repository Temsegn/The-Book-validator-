import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../models/book.dart';
import '../../models/song.dart';

class AdminPendingScreen extends StatefulWidget {
  @override
  _AdminPendingScreenState createState() => _AdminPendingScreenState();
}

class _AdminPendingScreenState extends State<AdminPendingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Book> _pendingBooks = [];
  List<Song> _pendingSongs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadPendingContent();
  }

  Future<void> _loadPendingContent() async {
    try {
      // You would implement this endpoint in your backend
      // final response = await ApiService.getPendingSubmissions();
      // setState(() {
      //   _pendingBooks = response['books'];
      //   _pendingSongs = response['songs'];
      //   _isLoading = false;
      // });
      
      // For now, using empty lists
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading pending content: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pending Submissions'),
        backgroundColor: Colors.orange.shade800,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(text: 'Books (${_pendingBooks.length})'),
            Tab(text: 'Songs (${_pendingSongs.length})'),
          ],
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildPendingBooksList(),
                _buildPendingSongsList(),
              ],
            ),
    );
  }

  Widget _buildPendingBooksList() {
    if (_pendingBooks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.book_outlined,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No pending book submissions',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _pendingBooks.length,
      itemBuilder: (context, index) {
        final book = _pendingBooks[index];
        return _buildPendingBookCard(book);
      },
    );
  }

  Widget _buildPendingSongsList() {
    if (_pendingSongs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.music_note_outlined,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No pending song submissions',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _pendingSongs.length,
      itemBuilder: (context, index) {
        final song = _pendingSongs[index];
        return _buildPendingSongCard(song);
      },
    );
  }

  Widget _buildPendingBookCard(Book book) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ExpansionTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.book,
            color: Colors.blue.shade800,
          ),
        ),
        title: Text(
          book.title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('by ${book.author}'),
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Description:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(book.description),
                SizedBox(height: 16),
                Text(
                  'Units Available: ${book.unitsAvailable}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _approveBook(book.id),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        child: Text('Approve', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _rejectBook(book.id),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: Text('Reject', style: TextStyle(color: Colors.white)),
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
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ExpansionTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.orange.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.music_note,
            color: Colors.orange.shade800,
          ),
        ),
        title: Text(
          song.title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('by ${song.singer}'),
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lyrics:',
                  style: TextStyle(fontWeight: FontWeight.bold),
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
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _approveSong(song.id),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        child: Text('Approve', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _rejectSong(song.id),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: Text('Reject', style: TextStyle(color: Colors.white)),
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

  Future<void> _approveBook(String bookId) async {
    try {
      // You would implement this endpoint in your backend
      // await ApiService.approveBook(bookId);
      
      setState(() {
        _pendingBooks.removeWhere((book) => book.id == bookId);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Book approved successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to approve book'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _rejectBook(String bookId) async {
    try {
      // You would implement this endpoint in your backend
      // await ApiService.rejectBook(bookId);
      
      setState(() {
        _pendingBooks.removeWhere((book) => book.id == bookId);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Book rejected'),
          backgroundColor: Colors.orange,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to reject book'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _approveSong(String songId) async {
    try {
      // You would implement this endpoint in your backend
      // await ApiService.approveSong(songId);
      
      setState(() {
        _pendingSongs.removeWhere((song) => song.id == songId);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Song approved successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to approve song'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _rejectSong(String songId) async {
    try {
      // You would implement this endpoint in your backend
      // await ApiService.rejectSong(songId);
      
      setState(() {
        _pendingSongs.removeWhere((song) => song.id == songId);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Song rejected'),
          backgroundColor: Colors.orange,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to reject song'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
