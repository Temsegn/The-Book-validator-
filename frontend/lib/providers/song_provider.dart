import 'package:flutter/material.dart';
import '../models/song.dart';
import '../services/api_service.dart';

class SongProvider with ChangeNotifier {
  List<Song> _songs = [];
  bool _isLoading = false;

  List<Song> get songs => _songs;
  bool get isLoading => _isLoading;

  Future<void> loadSongs({String? search}) async {
    _isLoading = true;
    notifyListeners();

    try {
      _songs = await ApiService.getSongs(search: search);
    } catch (e) {
      print('Error loading songs: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> submitSong(Song song) async {
    try {
      final response = await ApiService.submitSong(song);
      return response['success'] ?? false;
    } catch (e) {
      print('Error submitting song: $e');
      return false;
    }
  }
}
