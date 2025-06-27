// Service for book-related business logic
const Book = require('../models/book');

exports.findBooksByUser = async (userId) => {
  return await Book.find({ user: userId });
};

exports.createBook = async (bookData) => {
  const book = new Book(bookData);
  return await book.save();
};
