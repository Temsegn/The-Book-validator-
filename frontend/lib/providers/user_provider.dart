import 'package:flutter/material.dart';
import '../models/book.dart';
import '../models/song.dart';
import '../services/api_service.dart';

class UserProvider with ChangeNotifier {
  List<Book> _favoriteBooks = [];
  List<Song> _favoriteSongs = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Book> get favoriteBooks => _favoriteBooks;
  List<Song> get favoriteSongs => _favoriteSongs;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadFavoriteBooks() async {
    _isLoading = true;
    notifyListeners();

    try {
      final books = await ApiService.getFavoriteBooks();
      _favoriteBooks = books;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to load favorite books: $e';
      print('Error loading favorite books: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadFavoriteSongs() async {
    _isLoading = true;
    notifyListeners();

    try {
      final songs = await ApiService.getFavoriteSongs();
      _favoriteSongs = songs;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to load favorite songs: $e';
      print('Error loading favorite songs: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> toggleBookFavorite(String bookId) async {
    try {
      final response = await ApiService.toggleBookFavorite(bookId);
      if (response['success'] == true) {
        await loadFavoriteBooks();
        return true;
      }
      return false;
    } catch (e) {
      print('Error toggling book favorite: $e');
      return false;
    }
  }

  Future<bool> toggleSongFavorite(String songId) async {
    try {
      final response = await ApiService.toggleSongFavorite(songId);
      if (response['success'] == true) {
        await loadFavoriteSongs();
        return true;
      }
      return false;
    } catch (e) {
      print('Error toggling song favorite: $e');
      return false;
    }
  }

  bool isBookFavorite(String bookId) {
    return _favoriteBooks.any((book) => book.id == bookId);
  }

  bool isSongFavorite(String songId) {
    return _favoriteSongs.any((song) => song.id == songId);
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
