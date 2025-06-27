import 'dart:convert';
import 'dart:io';
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
  }

  static Map<String, String> get _headers {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    if (_token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }
    return headers;
  }

  // Auth endpoints
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: _headers,
      body: jsonEncode({'email': email, 'password': password}),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> register(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: _headers,
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );
    return jsonDecode(response.body);
  }

  // Book endpoints
  static Future<List<Book>> getBooks({String? search}) async {
    String url = '$baseUrl/books';
    if (search != null && search.isNotEmpty) {
      url += '?search=$search';
    }
    final response = await http.get(Uri.parse(url), headers: _headers);
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((book) => Book.fromJson(book)).toList();
    }
    throw Exception('Failed to load books');
  }

  static Future<Book> getBook(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/books/$id'), headers: _headers);
    if (response.statusCode == 200) {
      return Book.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to load book');
  }

  static Future<Map<String, dynamic>> addReview(String bookId, Review review) async {
    final response = await http.post(
      Uri.parse('$baseUrl/books/$bookId/reviews'),
      headers: _headers,
      body: jsonEncode(review.toJson()),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> submitBook(Book book) async {
    final response = await http.post(
      Uri.parse('$baseUrl/books/submit'),
      headers: _headers,
      body: jsonEncode(book.toJson()),
    );
    return jsonDecode(response.body);
  }

  // Song endpoints
  static Future<List<Song>> getSongs({String? search}) async {
    String url = '$baseUrl/songs';
    if (search != null && search.isNotEmpty) {
      url += '?search=$search';
    }
    final response = await http.get(Uri.parse(url), headers: _headers);
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((song) => Song.fromJson(song)).toList();
    }
    throw Exception('Failed to load songs');
  }

  static Future<Song> getSong(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/songs/$id'), headers: _headers);
    if (response.statusCode == 200) {
      return Song.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to load song');
  }

  static Future<Map<String, dynamic>> submitSong(Song song) async {
    final response = await http.post(
      Uri.parse('$baseUrl/songs/submit'),
      headers: _headers,
      body: jsonEncode(song.toJson()),
    );
    return jsonDecode(response.body);
  }

  // Report endpoints
  static Future<Map<String, dynamic>> submitReport(Report report) async {
    final response = await http.post(
      Uri.parse('$baseUrl/reports'),
      headers: _headers,
      body: jsonEncode(report.toJson()),
    );
    return jsonDecode(response.body);
  }

  static Future<List<Report>> getReports() async {
    final response = await http.get(Uri.parse('$baseUrl/reports'), headers: _headers);
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((report) => Report.fromJson(report)).toList();
    }
    throw Exception('Failed to load reports');
  }

  // Notification endpoints
  static Future<List<AppNotification>> getNotifications() async {
    final response = await http.get(Uri.parse('$baseUrl/notifications'), headers: _headers);
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((notification) => AppNotification.fromJson(notification)).toList();
    }
    throw Exception('Failed to load notifications');
  }

  static Future<Map<String, dynamic>> markNotificationAsRead(String id) async {
    final response = await http.put(
      Uri.parse('$baseUrl/notifications/$id/read'),
      headers: _headers,
    );
    return jsonDecode(response.body);
  }

  // Admin endpoints
  static Future<Map<String, dynamic>> addBook(Book book) async {
    final response = await http.post(
      Uri.parse('$baseUrl/admin/books'),
      headers: _headers,
      body: jsonEncode(book.toJson()),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> addSong(Song song) async {
    final response = await http.post(
      Uri.parse('$baseUrl/admin/songs'),
      headers: _headers,
      body: jsonEncode(song.toJson()),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> sendNotification(String title, String message, String? userId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/admin/notifications'),
      headers: _headers,
      body: jsonEncode({
        'title': title,
        'message': message,
        'userId': userId,
      }),
    );
    return jsonDecode(response.body);
  }

  static Future<List<User>> getUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/admin/users'), headers: _headers);
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((user) => User.fromJson(user)).toList();
    }
    throw Exception('Failed to load users');
  }
  // Get all pending submissions
static Future<Map<String, List<dynamic>>> getPendingSubmissions() async {
  final response = await http.get(
    Uri.parse('$baseUrl/admin/pending'),
    headers: _headers,
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return {
      'books': (data['books'] as List).map((b) => Book.fromJson(b)).toList(),
      'songs': (data['songs'] as List).map((s) => Song.fromJson(s)).toList(),
    };
  } else {
    throw Exception('Failed to load pending submissions');
  }
}

// Approve a book
static Future<void> approveBook(String id) async {
  final response = await http.put(
    Uri.parse('$baseUrl/admin/books/$id/approve'),
    headers: _headers,
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to approve book');
  }
}

// Reject a book
static Future<void> rejectBook(String id) async {
  final response = await http.put(
    Uri.parse('$baseUrl/admin/books/$id/reject'),
    headers: _headers,
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to reject book');
  }
}

// Approve a song
static Future<void> approveSong(String id) async {
  final response = await http.put(
    Uri.parse('$baseUrl/admin/songs/$id/approve'),
    headers: _headers,
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to approve song');
  }
}

// Reject a song
static Future<void> rejectSong(String id) async {
  final response = await http.put(
    Uri.parse('$baseUrl/admin/songs/$id/reject'),
    headers: _headers,
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to reject song');
  }
}

}
