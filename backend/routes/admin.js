const express = require("express")
const Book = require("../models/Book")
const Song = require("../models/Song")
const User = require("../models/User")
const Report = require("../models/Report")
const Notification = require("../models/Notification")
const { adminAuth } = require("../middleware/auth")

const router = express.Router()

// Get all users
router.get("/users", adminAuth, async (req, res) => {
  try {
    const users = await User.find().sort({ createdAt: -1 })
    res.json(users)
  } catch (error) {
    console.error("Get users error:", error)
    res.status(500).json({ success: false, message: "Server error" })
  }
})

// Add new book
router.post("/books", adminAuth, async (req, res) => {
  try {
    const { title, author, description, unitsAvailable, imageUrl } = req.body

    const book = new Book({
      title,
      author,
      description,
      unitsAvailable,
      imageUrl,
      isVerified: true,
    })

    await book.save()

    res.status(201).json({
      success: true,
      message: "Book added successfully",
      book,
    })
  } catch (error) {
    console.error("Add book error:", error)
    res.status(500).json({ success: false, message: "Server error" })
  }
})

// Add new song
router.post("/songs", adminAuth, async (req, res) => {
  try {
    const { title, singer, lyrics, audioUrl } = req.body

    const song = new Song({
      title,
      singer,
      lyrics,
      audioUrl,
      isVerified: true,
    })

    await song.save()

    res.status(201).json({
      success: true,
      message: "Song added successfully",
      song,
    })
  } catch (error) {
    console.error("Add song error:", error)
    res.status(500).json({ success: false, message: "Server error" })
  }
})

// Get pending submissions
router.get("/pending", adminAuth, async (req, res) => {
  try {
    const pendingBooks = await Book.find({ isVerified: false }).populate("submittedBy", "name email")
    const pendingSongs = await Song.find({ isVerified: false }).populate("submittedBy", "name email")

    res.json({
      books: pendingBooks,
      songs: pendingSongs,
    })
  } catch (error) {
    console.error("Get pending submissions error:", error)
    res.status(500).json({ success: false, message: "Server error" })
  }
})

// Approve book
router.put("/books/:id/approve", adminAuth, async (req, res) => {
  try {
    const book = await Book.findByIdAndUpdate(req.params.id, { isVerified: true }, { new: true })

    if (!book) {
      return res.status(404).json({ success: false, message: "Book not found" })
    }

    // Send notification to submitter
    if (book.submittedBy) {
      const notification = new Notification({
        title: "Book Approved",
        message: `Your book "${book.title}" has been approved and added to the catalog.`,
        userId: book.submittedBy,
      })
      await notification.save()
    }

    res.json({
      success: true,
      message: "Book approved successfully",
      book,
    })
  } catch (error) {
    console.error("Approve book error:", error)
    res.status(500).json({ success: false, message: "Server error" })
  }
})

// Approve song
router.put("/songs/:id/approve", adminAuth, async (req, res) => {
  try {
    const song = await Song.findByIdAndUpdate(req.params.id, { isVerified: true }, { new: true })

    if (!song) {
      return res.status(404).json({ success: false, message: "Song not found" })
    }

    // Send notification to submitter
    if (song.submittedBy) {
      const notification = new Notification({
        title: "Song Approved",
        message: `Your song "${song.title}" has been approved and added to the catalog.`,
        userId: song.submittedBy,
      })
      await notification.save()
    }

    res.json({
      success: true,
      message: "Song approved successfully",
      song,
    })
  } catch (error) {
    console.error("Approve song error:", error)
    res.status(500).json({ success: false, message: "Server error" })
  }
})

// Send notification
router.post("/notifications", adminAuth, async (req, res) => {
  try {
    const { title, message, userId } = req.body

    const notification = new Notification({
      title,
      message,
      userId: userId || null, // null for global notifications
    })

    await notification.save()

    res.status(201).json({
      success: true,
      message: "Notification sent successfully",
      notification,
    })
  } catch (error) {
    console.error("Send notification error:", error)
    res.status(500).json({ success: false, message: "Server error" })
  }
})

module.exports = router
