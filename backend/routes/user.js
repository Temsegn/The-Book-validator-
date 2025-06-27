const express = require("express")
const User = require("../models/User")
const Book = require("../models/Book")
const Song = require("../models/Song")
const auth = require("../middleware/auth")
const bcrypt = require("bcryptjs")

const router = express.Router()

// @route   GET /api/user/profile
// @desc    Get user profile
// @access  Private
router.get("/profile", auth, async (req, res) => {
  try {
    const user = await User.findById(req.user.userId)
      .populate("favoriteBooks", "title author imageUrl averageRating")
      .populate("favoriteSongs", "title singer averageRating")

    if (!user) {
      return res.status(404).json({
        success: false,
        message: "User not found",
      })
    }

    res.json({
      success: true,
      user: user.toJSON(),
    })
  } catch (error) {
    console.error("Get profile error:", error)
    res.status(500).json({
      success: false,
      message: "Server error",
    })
  }
})

// @route   PUT /api/user/profile
// @desc    Update user profile
// @access  Private
router.put("/profile", auth, async (req, res) => {
  try {
    const { name, bio, location, preferences } = req.body

    const user = await User.findById(req.user.userId)
    if (!user) {
      return res.status(404).json({
        success: false,
        message: "User not found",
      })
    }

    // Update fields
    if (name) user.name = name.trim()
    if (bio !== undefined) user.bio = bio.trim()
    if (location !== undefined) user.location = location.trim()
    if (preferences) {
      user.preferences = { ...user.preferences, ...preferences }
    }

    await user.save()

    // Populate favorites for response
    await user.populate("favoriteBooks", "title author imageUrl averageRating")
    await user.populate("favoriteSongs", "title singer averageRating")

    res.json({
      success: true,
      message: "Profile updated successfully",
      user: user.toJSON(),
    })
  } catch (error) {
    console.error("Update profile error:", error)

    if (error.name === "ValidationError") {
      const errors = Object.values(error.errors).map((err) => err.message)
      return res.status(400).json({
        success: false,
        message: "Validation error",
        errors,
      })
    }

    res.status(500).json({
      success: false,
      message: "Server error",
    })
  }
})

// @route   PUT /api/user/change-password
// @desc    Change user password
// @access  Private
router.put("/change-password", auth, async (req, res) => {
  try {
    const { currentPassword, newPassword } = req.body

    if (!currentPassword || !newPassword) {
      return res.status(400).json({
        success: false,
        message: "Please provide current and new password",
      })
    }

    if (newPassword.length < 6) {
      return res.status(400).json({
        success: false,
        message: "New password must be at least 6 characters long",
      })
    }

    const user = await User.findById(req.user.userId).select("+password")
    if (!user) {
      return res.status(404).json({
        success: false,
        message: "User not found",
      })
    }

    // Verify current password
    const isCurrentPasswordValid = await user.comparePassword(currentPassword)
    if (!isCurrentPasswordValid) {
      return res.status(400).json({
        success: false,
        message: "Current password is incorrect",
      })
    }

    // Update password
    user.password = newPassword
    await user.save()

    res.json({
      success: true,
      message: "Password changed successfully",
    })
  } catch (error) {
    console.error("Change password error:", error)
    res.status(500).json({
      success: false,
      message: "Server error",
    })
  }
})

// @route   POST /api/user/favorites/books/:bookId
// @desc    Toggle book favorite
// @access  Private
router.post("/favorites/books/:bookId", auth, async (req, res) => {
  try {
    const { bookId } = req.params

    const user = await User.findById(req.user.userId)
    const book = await Book.findById(bookId)

    if (!user) {
      return res.status(404).json({
        success: false,
        message: "User not found",
      })
    }

    if (!book) {
      return res.status(404).json({
        success: false,
        message: "Book not found",
      })
    }

    const isFavorite = user.favoriteBooks.includes(bookId)

    if (isFavorite) {
      await user.removeFromFavorites("book", bookId)
    } else {
      await user.addToFavorites("book", bookId)
    }

    // Populate favorites for response
    await user.populate("favoriteBooks", "title author imageUrl averageRating")

    res.json({
      success: true,
      message: isFavorite ? "Removed from favorites" : "Added to favorites",
      isFavorite: !isFavorite,
      favoriteBooks: user.favoriteBooks,
    })
  } catch (error) {
    console.error("Toggle book favorite error:", error)
    res.status(500).json({
      success: false,
      message: "Server error",
    })
  }
})

// @route   POST /api/user/favorites/songs/:songId
// @desc    Toggle song favorite
// @access  Private
router.post("/favorites/songs/:songId", auth, async (req, res) => {
  try {
    const { songId } = req.params

    const user = await User.findById(req.user.userId)
    const song = await Song.findById(songId)

    if (!user) {
      return res.status(404).json({
        success: false,
        message: "User not found",
      })
    }

    if (!song) {
      return res.status(404).json({
        success: false,
        message: "Song not found",
      })
    }

    const isFavorite = user.favoriteSongs.includes(songId)

    if (isFavorite) {
      await user.removeFromFavorites("song", songId)
    } else {
      await user.addToFavorites("song", songId)
    }

    // Populate favorites for response
    await user.populate("favoriteSongs", "title singer averageRating")

    res.json({
      success: true,
      message: isFavorite ? "Removed from favorites" : "Added to favorites",
      isFavorite: !isFavorite,
      favoriteSongs: user.favoriteSongs,
    })
  } catch (error) {
    console.error("Toggle song favorite error:", error)
    res.status(500).json({
      success: false,
      message: "Server error",
    })
  }
})

// @route   GET /api/user/favorites/books
// @desc    Get user's favorite books
// @access  Private
router.get("/favorites/books", auth, async (req, res) => {
  try {
    const user = await User.findById(req.user.userId).populate({
      path: "favoriteBooks",
      select: "title author description imageUrl averageRating totalReviews category tags createdAt",
      match: { status: "approved" },
    })

    if (!user) {
      return res.status(404).json({
        success: false,
        message: "User not found",
      })
    }

    res.json({
      success: true,
      favoriteBooks: user.favoriteBooks,
    })
  } catch (error) {
    console.error("Get favorite books error:", error)
    res.status(500).json({
      success: false,
      message: "Server error",
    })
  }
})

module.exports = router
