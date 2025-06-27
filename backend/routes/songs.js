const express = require("express")
const Song = require("../models/Song")
const { auth } = require("../middleware/auth")

const router = express.Router()

// Get all songs with search
router.get("/", async (req, res) => {
  try {
    const { search } = req.query
    const query = { isVerified: true }

    if (search) {
      query.$text = { $search: search }
    }

    const songs = await Song.find(query).sort({ createdAt: -1 })
    res.json(songs)
  } catch (error) {
    console.error("Get songs error:", error)
    res.status(500).json({ success: false, message: "Server error" })
  }
})

// Get single song
router.get("/:id", async (req, res) => {
  try {
    const song = await Song.findById(req.params.id)
    if (!song) {
      return res.status(404).json({ success: false, message: "Song not found" })
    }
    res.json(song)
  } catch (error) {
    console.error("Get song error:", error)
    res.status(500).json({ success: false, message: "Server error" })
  }
})

// Submit song for review
router.post("/submit", auth, async (req, res) => {
  try {
    const { title, singer, lyrics, audioUrl } = req.body

    const song = new Song({
      title,
      singer,
      lyrics,
      audioUrl,
      submittedBy: req.user._id,
      isVerified: false,
    })

    await song.save()

    res.status(201).json({
      success: true,
      message: "Song submitted for review",
      song,
    })
  } catch (error) {
    console.error("Submit song error:", error)
    res.status(500).json({ success: false, message: "Server error" })
  }
})

module.exports = router
