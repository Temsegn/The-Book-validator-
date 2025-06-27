import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../models/user.dart';

class AdminNotificationsScreen extends StatefulWidget {
  @override
  _AdminNotificationsScreenState createState() => _AdminNotificationsScreenState();
}

class _AdminNotificationsScreenState extends State<AdminNotificationsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();
  
  List<User> _users = [];
  User? _selectedUser;
  bool _isLoading = true;
  bool _isSending = false;
  bool _sendToAll = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      final users = await ApiService.getUsers();
      setState(() {
        _users = users;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading users: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send Notifications'),
        backgroundColor: Colors.purple.shade800,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.purple.shade800, Colors.purple.shade400],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.notifications_active,
                            size: 60,
                            color: Colors.white,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Send Notification',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Send notifications to users or broadcast to everyone',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),

                    // Recipient Selection
                    Text(
                      'Recipients',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    
                    RadioListTile<bool>(
                      title: Text('Send to all users'),
                      value: true,
                      groupValue: _sendToAll,
                      onChanged: (value) {
                        setState(() {
                          _sendToAll = value!;
                          _selectedUser = null;
                        });
                      },
                      activeColor: Colors.purple.shade800,
                    ),
                    
                    RadioListTile<bool>(
                      title: Text('Send to specific user'),
                      value: false,
                      groupValue: _sendToAll,
                      onChanged: (value) {
                        setState(() {
                          _sendToAll = value!;
                        });
                      },
                      activeColor: Colors.purple.shade800,
                    ),

                    if (!_sendToAll) ...[
                      SizedBox(height: 16),
                      DropdownButtonFormField<User>(
                        value: _selectedUser,
                        decoration: InputDecoration(
                          labelText: 'Select User',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: Icon(Icons.person),
                        ),
                        items: _users.map((user) {
                          return DropdownMenuItem<User>(
                            value: user,
                            child: Text('${user.name} (${user.email})'),
                          );
                        }).toList(),
                        onChanged: (user) {
                          setState(() {
                            _selectedUser = user;
                          });
                        },
                        validator: (value) {
                          if (!_sendToAll && value == null) {
                            return 'Please select a user';
                          }
                          return null;
                        },
                      ),
                    ],
                    
                    SizedBox(height: 24),

                    // Notification Content
                    Text(
                      'Notification Content',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: 'Title *',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: Icon(Icons.title),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter notification title';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    
                    TextFormField(
                      controller: _messageController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: 'Message *',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignLabelWithHint: true,
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(bottom: 60),
                          child: Icon(Icons.message),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter notification message';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 32),

                    // Send Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isSending ? null : _sendNotification,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple.shade800,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: _isSending
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    'Sending...',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.send, color: Colors.white),
                                  SizedBox(width: 8),
                                  Text(
                                    _sendToAll ? 'Send to All Users' : 'Send Notification',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    SizedBox(height: 20),

                    // Info Card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.purple.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.purple.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Colors.purple.shade800,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Notification Guidelines',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple.shade800,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            '• Keep titles concise and descriptive\n'
                            '• Write clear and actionable messages\n'
                            '• Use notifications sparingly to avoid spam\n'
                            '• Consider the timing of your notifications',
                            style: TextStyle(
                              color: Colors.purple.shade700,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Future<void> _sendNotification() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSending = true;
    });

    try {
      final response = await ApiService.sendNotification(
        _titleController.text.trim(),
        _messageController.text.trim(),
        _sendToAll ? null : _selectedUser!.id,
      );
      
      if (response['success']) {
        // Clear form
        _titleController.clear();
        _messageController.clear();
        setState(() {
          _selectedUser = null;
          _sendToAll = true;
        });

        final recipientText = _sendToAll 
            ? 'all users' 
            : _selectedUser?.name ?? 'selected user';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Notification sent to $recipientText successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        throw Exception(response['message'] ?? 'Failed to send notification');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send notification: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isSending = false;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }
}
