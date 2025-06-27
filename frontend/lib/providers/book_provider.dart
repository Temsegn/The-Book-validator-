import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/api_service.dart';

class BookProvider with ChangeNotifier {
  List<Book> _books = [];
  bool _isLoading = false;

  List<Book> get books => _books;
  bool get isLoading => _isLoading;

  Future<void> loadBooks({String? search}) async {
    _isLoading = true;
    notifyListeners();

    try {
      _books = await ApiService.getBooks(search: search);
    } catch (e) {
      print('Error loading books: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> addReview(String bookId, Review review) async {
    try {
      final response = await ApiService.addReview(bookId, review);
      if (response['success']) {
        await loadBooks(); // Refresh books
        return true;
      }
    } catch (e) {
      print('Error adding review: $e');
    }
    return false;
  }

  Future<bool> submitBook(Book book) async {
    try {
      final response = await ApiService.submitBook(book);
      return response['success'] ?? false;
    } catch (e) {
      print('Error submitting book: $e');
      return false;
    }
  }
}
