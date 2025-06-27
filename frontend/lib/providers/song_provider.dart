import 'package:flutter/material.dart';
import '../models/song.dart';
import '../services/api_service.dart';

class SongProvider with ChangeNotifier {
  List<Song> _songs = [];
  List<Song> _favoriteSongs = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';
  String _selectedCategory = '';

  List<Song> get songs => _songs;
  List<Song> get favoriteSongs => _favoriteSongs;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;

  List<Song> get filteredSongs {
    List<Song> filtered = _songs;
    
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((song) =>
        song.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        song.singer.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        song.lyrics.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }
    
    if (_selectedCategory.isNotEmpty && _selectedCategory != 'All') {
      filtered = filtered.where((song) => song.category == _selectedCategory).toList();
    }
    
    return filtered;
  }

  List<String> get categories {
    final Set<String> categorySet = {'All'};
    for (final song in _songs) {
      categorySet.add(song.category);
    }
    return categorySet.toList();
  }

  Future<void> loadSongs({String? status}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final songs = await ApiService.getSongs(status: status);
      _songs = songs;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to load songs: $e';
      print('Error loading songs: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadFavoriteSongs() async {
    try {
      final favoriteSongs = await ApiService.getFavoriteSongs();
      _favoriteSongs = favoriteSongs;
      notifyListeners();
    } catch (e) {
      print('Error loading favorite songs: $e');
    }
  }

  Future<Song?> getSong(String id) async {
    try {
      return await ApiService.getSong(id);
    } catch (e) {
      print('Error getting song: $e');
      return null;
    }
  }

  Future<bool> submitSong(Song song) async {
    try {
      final response = await ApiService.submitSong(song);
      if (response['success'] == true) {
        await loadSongs();
        return true;
      }
      return false;
    } catch (e) {
      print('Error submitting song: $e');
      return false;
    }
  }

  Future<bool> toggleFavorite(String songId) async {
    try {
      final response = await ApiService.toggleSongFavorite(songId);
      if (response['success'] == true) {
        await loadFavoriteSongs();
        return true;
      }
      return false;
    } catch (e) {
      print('Error toggling favorite: $e');
      return false;
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedCategory = '';
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  bool isFavorite(String songId) {
    return _favoriteSongs.any((song) => song.id == songId);
  }
}
