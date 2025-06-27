import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/book.dart';
import '../../providers/book_provider.dart';
import '../../providers/auth_provider.dart';

class BookDetailScreen extends StatefulWidget {
  final Book book;

  const BookDetailScreen({Key? key, required this.book}) : super(key: key);

  @override
  _BookDetailScreenState createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  final _reviewController = TextEditingController();
  int _rating = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book.title),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Book Image and Basic Info
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 120,
                  height: 160,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: widget.book.imageUrl.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            widget.book.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.book, size: 60, color: Colors.grey);
                            },
                          ),
                        )
                      : Icon(Icons.book, size: 60, color: Colors.grey),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.book.title,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'by ${widget.book.author}',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Icon(Icons.inventory, color: Colors.green),
                          SizedBox(width: 8),
                          Text('${widget.book.unitsAvailable} available'),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.orange),
                          SizedBox(width: 8),
                          Text('${widget.book.reviews.length} reviews'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            
            // Description
            Text(
              'Description',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              widget.book.description,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            
            // Add Review Section
            Text(
              'Add Review',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text('Rating: '),
                ...List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < _rating ? Icons.star : Icons.star_border,
                      color: Colors.orange,
                    ),
                    onPressed: () {
                      setState(() {
                        _rating = index + 1;
                      });
                    },
                  );
                }),
              ],
            ),
            TextField(
              controller: _reviewController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Write your review...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitReview,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade800,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Submit Review',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 24),
            
            // Reviews List
            Text(
              'Reviews',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            ...widget.book.reviews.map((review) => ReviewCard(review: review)),
          ],
        ),
      ),
    );
  }

  void _submitReview() async {
    if (_reviewController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please write a review')),
      );
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final bookProvider = Provider.of<BookProvider>(context, listen: false);

    final review = Review(
      id: '',
      userId: authProvider.user!.id,
      userName: authProvider.user!.name,
      comment: _reviewController.text.trim(),
      rating: _rating,
      createdAt: DateTime.now(),
    );

    final success = await bookProvider.addReview(widget.book.id, review);
    
    if (success) {
      _reviewController.clear();
      setState(() {
        _rating = 5;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Review submitted successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit review')),
      );
    }
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }
}

class ReviewCard extends StatelessWidget {
  final Review review;

  const ReviewCard({Key? key, required this.review}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  review.userName,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      index < review.rating ? Icons.star : Icons.star_border,
                      color: Colors.orange,
                      size: 16,
                    );
                  }),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(review.comment),
            SizedBox(height: 8),
            Text(
              '${review.createdAt.day}/${review.createdAt.month}/${review.createdAt.year}',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
