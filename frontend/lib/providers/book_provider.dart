import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/api_service.dart';

class BookProvider with ChangeNotifier {
  List<Book> _books = [];
  List<Book> _favoriteBooks = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';
  String _selectedCategory = '';

  List<Book> get books => _books;
  List<Book> get favoriteBooks => _favoriteBooks;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;

  List<Book> get filteredBooks {
    List<Book> filtered = _books;
    
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((book) =>
        book.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        book.author.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        book.description.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }
    
    if (_selectedCategory.isNotEmpty && _selectedCategory != 'All') {
      filtered = filtered.where((book) => book.category == _selectedCategory).toList();
    }
    
    return filtered;
  }

  List<String> get categories {
    final Set<String> categorySet = {'All'};
    for (final book in _books) {
      categorySet.add(book.category);
    }
    return categorySet.toList();
  }

  Future<void> loadBooks({String? status}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final books = await ApiService.getBooks(status: status);
      _books = books;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to load books: $e';
      print('Error loading books: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadFavoriteBooks() async {
    try {
      final favoriteBooks = await ApiService.getFavoriteBooks();
      _favoriteBooks = favoriteBooks;
      notifyListeners();
    } catch (e) {
      print('Error loading favorite books: $e');
    }
  }

  Future<Book?> getBook(String id) async {
    try {
      return await ApiService.getBook(id);
    } catch (e) {
      print('Error getting book: $e');
      return null;
    }
  }

  Future<bool> submitBook(Book book) async {
    try {
      final response = await ApiService.submitBook(book);
      if (response['success'] == true) {
        await loadBooks();
        return true;
      }
      return false;
    } catch (e) {
      print('Error submitting book: $e');
      return false;
    }
  }

  Future<bool> toggleFavorite(String bookId) async {
    try {
      final response = await ApiService.toggleBookFavorite(bookId);
      if (response['success'] == true) {
        await loadFavoriteBooks();
        return true;
      }
      return false;
    } catch (e) {
      print('Error toggling favorite: $e');
      return false;
    }
  }

  Future<bool> addReview(String bookId, Review review) async {
    try {
      final response = await ApiService.addBookReview(bookId, review);
      if (response['success'] == true) {
        await loadBooks();
        return true;
      }
      return false;
    } catch (e) {
      print('Error adding review: $e');
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

  bool isFavorite(String bookId) {
    return _favoriteBooks.any((book) => book.id == bookId);
  }
}
