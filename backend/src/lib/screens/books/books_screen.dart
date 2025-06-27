import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/book_provider.dart';
import '../../models/book.dart';
import 'book_detail_screen.dart';

class BooksScreen extends StatefulWidget {
  @override
  _BooksScreenState createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BookProvider>(context, listen: false).loadBooks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search books...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                Provider.of<BookProvider>(context, listen: false)
                    .loadBooks(search: value);
              },
            ),
          ),
          Expanded(
            child: Consumer<BookProvider>(
              builder: (context, bookProvider, child) {
                if (bookProvider.isLoading) {
                  return Center(child: CircularProgressIndicator());
                }

                if (bookProvider.books.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.book, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'No books found',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: bookProvider.books.length,
                  itemBuilder: (context, index) {
                    final book = bookProvider.books[index];
                    return BookCard(book: book);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class BookCard extends StatelessWidget {
  final Book book;

  const BookCard({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Container(
          width: 60,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(8),
          ),
          child: book.imageUrl.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    book.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.book, color: Colors.grey);
                    },
                  ),
                )
              : Icon(Icons.book, color: Colors.grey),
        ),
        title: Text(
          book.title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('by ${book.author}'),
            SizedBox(height: 4),
            Text(
              book.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.inventory, size: 16, color: Colors.green),
                SizedBox(width: 4),
                Text('${book.unitsAvailable} available'),
                SizedBox(width: 16),
                Icon(Icons.star, size: 16, color: Colors.orange),
                SizedBox(width: 4),
                Text('${book.reviews.length} reviews'),
              ],
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookDetailScreen(book: book),
            ),
          );
        },
      ),
    );
  }
}
