const express = require("express")
const Book = require("../models/Book")
const { auth } = require("../middleware/auth")

const router = express.Router()

// Get all books with search
router.get("/", async (req, res) => {
  try {
    const { search } = req.query
    const query = { isVerified: true }

    if (search) {
      query.$text = { $search: search }
    }

    const books = await Book.find(query).sort({ createdAt: -1 })
    res.json(books)
  } catch (error) {
    console.error("Get books error:", error)
    res.status(500).json({ success: false, message: "Server error" })
  }
})

// Get single book
router.get("/:id", async (req, res) => {
  try {
    const book = await Book.findById(req.params.id)
    if (!book) {
      return res.status(404).json({ success: false, message: "Book not found" })
    }
    res.json(book)
  } catch (error) {
    console.error("Get book error:", error)
    res.status(500).json({ success: false, message: "Server error" })
  }
})

// Add review to book
router.post("/:id/reviews", auth, async (req, res) => {
  try {
    const { comment, rating } = req.body
    const book = await Book.findById(req.params.id)

    if (!book) {
      return res.status(404).json({ success: false, message: "Book not found" })
    }

    const review = {
      userId: req.user._id,
      userName: req.user.name,
      comment,
      rating,
    }

    book.reviews.push(review)
    await book.save()

    res.json({
      success: true,
      message: "Review added successfully",
      book,
    })
  } catch (error) {
    console.error("Add review error:", error)
    res.status(500).json({ success: false, message: "Server error" })
  }
})

// Submit book for review
router.post("/submit", auth, async (req, res) => {
  try {
    const { title, author, description, unitsAvailable, imageUrl } = req.body

    const book = new Book({
      title,
      author,
      description,
      unitsAvailable,
      imageUrl,
      submittedBy: req.user._id,
      isVerified: false,
    })

    await book.save()

    res.status(201).json({
      success: true,
      message: "Book submitted for review",
      book,
    })
  } catch (error) {
    console.error("Submit book error:", error)
    res.status(500).json({ success: false, message: "Server error" })
  }
})

module.exports = router
