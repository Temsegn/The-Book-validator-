import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../models/book.dart';
import '../../models/song.dart';

class AdminAddContentScreen extends StatefulWidget {
  @override
  _AdminAddContentScreenState createState() => _AdminAddContentScreenState();
}

class _AdminAddContentScreenState extends State<AdminAddContentScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Content'),
        backgroundColor: Colors.green.shade800,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(text: 'Add Book'),
            Tab(text: 'Add Song'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          AddBookTab(),
          AddSongTab(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

class AddBookTab extends StatefulWidget {
  @override
  _AddBookTabState createState() => _AddBookTabState();
}

class _AddBookTabState extends State<AddBookTab> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _unitsController = TextEditingController();
  final _imageUrlController = TextEditingController();
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add New Book',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 24),
            
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Book Title *',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: Icon(Icons.book),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter book title';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            
            TextFormField(
              controller: _authorController,
              decoration: InputDecoration(
                labelText: 'Author *',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter author name';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            
            TextFormField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Description *',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                alignLabelWithHint: true,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter book description';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            
            TextFormField(
              controller: _unitsController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Units Available *',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: Icon(Icons.inventory),
              ),
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
            SizedBox(height: 16),
            
            TextFormField(
              controller: _imageUrlController,
              decoration: InputDecoration(
                labelText: 'Image URL (Optional)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: Icon(Icons.image),
              ),
            ),
            SizedBox(height: 32),
            
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitBook,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade800,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: _isSubmitting
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'Add Book',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitBook() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final book = Book(
        id: '',
        title: _titleController.text.trim(),
        author: _authorController.text.trim(),
        description: _descriptionController.text.trim(),
        unitsAvailable: int.parse(_unitsController.text.trim()),
        reviews: [],
        imageUrl: _imageUrlController.text.trim(),
        createdAt: DateTime.now(),
        isVerified: true,
      );

      final response = await ApiService.addBook(book);
      
      if (response['success']) {
        // Clear form
        _titleController.clear();
        _authorController.clear();
        _descriptionController.clear();
        _unitsController.clear();
        _imageUrlController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Book added successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        throw Exception(response['message'] ?? 'Failed to add book');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add book: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
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

class AddSongTab extends StatefulWidget {
  @override
  _AddSongTabState createState() => _AddSongTabState();
}

class _AddSongTabState extends State<AddSongTab> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _singerController = TextEditingController();
  final _lyricsController = TextEditingController();
  final _audioUrlController = TextEditingController();
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add New Song',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 24),
            
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Song Title *',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: Icon(Icons.music_note),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter song title';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            
            TextFormField(
              controller: _singerController,
              decoration: InputDecoration(
                labelText: 'Singer *',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter singer name';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            
            TextFormField(
              controller: _lyricsController,
              maxLines: 8,
              decoration: InputDecoration(
                labelText: 'Lyrics *',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                alignLabelWithHint: true,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter song lyrics';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            
            TextFormField(
              controller: _audioUrlController,
              decoration: InputDecoration(
                labelText: 'Audio URL (Optional)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: Icon(Icons.audiotrack),
              ),
            ),
            SizedBox(height: 32),
            
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitSong,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade800,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: _isSubmitting
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'Add Song',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitSong() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final song = Song(
        id: '',
        title: _titleController.text.trim(),
        singer: _singerController.text.trim(),
        lyrics: _lyricsController.text.trim(),
        audioUrl: _audioUrlController.text.trim(),
        createdAt: DateTime.now(),
        isVerified: true,
      );

      final response = await ApiService.addSong(song);
      
      if (response['success']) {
        // Clear form
        _titleController.clear();
        _singerController.clear();
        _lyricsController.clear();
        _audioUrlController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Song added successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        throw Exception(response['message'] ?? 'Failed to add song');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add song: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
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
