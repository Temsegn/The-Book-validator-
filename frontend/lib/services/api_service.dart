import 'dart:convert';
import 'dart:html' as html;
import 'package:http/http.dart' as http;
import '../models/book.dart';
import '../models/song.dart';
import '../models/user.dart';
import '../models/report.dart';
import '../models/notification.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:3000/api';
  static String? _token;

  static void setToken(String token) {
    _token = token;
    html.window.localStorage['auth_token'] = token;
  }

  static String? getToken() {
    if (_token != null) return _token;
    _token = html.window.localStorage['auth_token'];
    return _token;
  }

  static void clearToken() {
    _token = null;
    html.window.localStorage.remove('auth_token');
  }

  static Map<String, String> get _headers {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    final token = getToken();
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  // Auth endpoints
  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: _headers,
        body: jsonEncode({'email': email, 'password': password}),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['token'] != null) {
          setToken(data['token']);
        }
        return data;
      } else {
        final errorData = jsonDecode(response.body);
        return {'success': false, 'message': errorData['message'] ?? 'Login failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  static Future<Map<String, dynamic>> register(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: _headers,
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      );
      
      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['token'] != null) {
          setToken(data['token']);
        }
        return data;
      } else {
        final errorData = jsonDecode(response.body);
        return {'success': false, 'message': errorData['message'] ?? 'Registration failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  static Future<User?> getCurrentUser() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user/profile'),
        headers: _headers,
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return User.fromJson(data['user']);
      }
      return null;
    } catch (e) {
      print('Error getting current user: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> profileData) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/user/profile'),
        headers: _headers,
        body: jsonEncode(profileData),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  static Future<Map<String, dynamic>> changePassword(String currentPassword, String newPassword) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/user/change-password'),
        headers: _headers,
        body: jsonEncode({
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        }),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // Book endpoints
  static Future<List<Book>> getBooks({String? search, String? category, String? status}) async {
    try {
      String url = '$baseUrl/books';
      List<String> queryParams = [];
      
      if (search != null && search.isNotEmpty) {
        queryParams.add('search=${Uri.encodeComponent(search)}');
      }
      if (category != null && category.isNotEmpty) {
        queryParams.add('category=${Uri.encodeComponent(category)}');
      }
      if (status != null && status.isNotEmpty) {
        queryParams.add('status=${Uri.encodeComponent(status)}');
      }
      
      if (queryParams.isNotEmpty) {
        url += '?${queryParams.join('&')}';
      }
      
      final response = await http.get(Uri.parse(url), headers: _headers);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<dynamic> booksData = data['books'] ?? data;
        return booksData.map((book) => Book.fromJson(book)).toList();
      }
      return [];
    } catch (e) {
      print('Error loading books: $e');
      return [];
    }
  }

  static Future<Book?> getBook(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/books/$id'), headers: _headers);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Book.fromJson(data['book'] ?? data);
      }
      return null;
    } catch (e) {
      print('Error loading book: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>> submitBook(Book book) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/books/submit'),
        headers: _headers,
        body: jsonEncode(book.toJson()),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  static Future<Map<String, dynamic>> addBookReview(String bookId, Review review) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/books/$bookId/reviews'),
        headers: _headers,
        body: jsonEncode(review.toJson()),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // Song endpoints
  static Future<List<Song>> getSongs({String? search, String? category, String? status}) async {
    try {
      String url = '$baseUrl/songs';
      List<String> queryParams = [];
      
      if (search != null && search.isNotEmpty) {
        queryParams.add('search=${Uri.encodeComponent(search)}');
      }
      if (category != null && category.isNotEmpty) {
        queryParams.add('category=${Uri.encodeComponent(category)}');
      }
      if (status != null && status.isNotEmpty) {
        queryParams.add('status=${Uri.encodeComponent(status)}');
      }
      
      if (queryParams.isNotEmpty) {
        url += '?${queryParams.join('&')}';
      }
      
      final response = await http.get(Uri.parse(url), headers: _headers);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<dynamic> songsData = data['songs'] ?? data;
        return songsData.map((song) => Song.fromJson(song)).toList();
      }
      return [];
    } catch (e) {
      print('Error loading songs: $e');
      return [];
    }
  }

  static Future<Song?> getSong(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/songs/$id'), headers: _headers);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Song.fromJson(data['song'] ?? data);
      }
      return null;
    } catch (e) {
      print('Error loading song: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>> submitSong(Song song) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/songs/submit'),
        headers: _headers,
        body: jsonEncode(song.toJson()),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // Favorites endpoints
  static Future<Map<String, dynamic>> toggleBookFavorite(String bookId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/user/favorites/books/$bookId'),
        headers: _headers,
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  static Future<Map<String, dynamic>> toggleSongFavorite(String songId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/user/favorites/songs/$songId'),
        headers: _headers,
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  static Future<List<Book>> getFavoriteBooks() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user/favorites/books'),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<dynamic> booksData = data['favoriteBooks'] ?? data;
        return booksData.map((book) => Book.fromJson(book)).toList();
      }
      return [];
    } catch (e) {
      print('Error loading favorite books: $e');
      return [];
    }
  }

  static Future<List<Song>> getFavoriteSongs() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user/favorites/songs'),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<dynamic> songsData = data['favoriteSongs'] ?? data;
        return songsData.map((song) => Song.fromJson(song)).toList();
      }
      return [];
    } catch (e) {
      print('Error loading favorite songs: $e');
      return [];
    }
  }

  // Report endpoints
  static Future<Map<String, dynamic>> submitReport(Report report) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/reports'),
        headers: _headers,
        body: jsonEncode(report.toJson()),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // Notification endpoints
  static Future<List<AppNotification>> getNotifications() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/notifications'), headers: _headers);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<dynamic> notificationsData = data['notifications'] ?? data;
        return notificationsData.map((notification) => AppNotification.fromJson(notification)).toList();
      }
      return [];
    } catch (e) {
      print('Error loading notifications: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>> markNotificationAsRead(String id) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/notifications/$id/read'),
        headers: _headers,
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // Admin endpoints
  static Future<List<User>> getUsers() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/admin/users'), headers: _headers);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<dynamic> usersData = data['users'] ?? data;
        return usersData.map((user) => User.fromJson(user)).toList();
      }
      return [];
    } catch (e) {
      print('Error loading users: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>> approveContent(String contentType, String contentId) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/admin/$contentType/$contentId/approve'),
        headers: _headers,
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  static Future<Map<String, dynamic>> rejectContent(String contentType, String contentId, String reason) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/admin/$contentType/$contentId/reject'),
        headers: _headers,
        body: jsonEncode({'reason': reason}),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  static Future<Map<String, dynamic>> getAnalytics() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/admin/analytics'), headers: _headers);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return {};
    } catch (e) {
      print('Error loading analytics: $e');
      return {};
    }
  }
}
