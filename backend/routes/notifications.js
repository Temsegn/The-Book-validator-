const express = require("express")
const Notification = require("../models/Notification")
const { auth } = require("../middleware/auth")

const router = express.Router()

// Get user notifications
router.get("/", auth, async (req, res) => {
  try {
    const notifications = await Notification.find({
      $or: [
        { userId: req.user._id },
        { userId: null }, // Global notifications
      ],
    }).sort({ createdAt: -1 })

    res.json(notifications)
  } catch (error) {
    console.error("Get notifications error:", error)
    res.status(500).json({ success: false, message: "Server error" })
  }
})

// Mark notification as read
router.put("/:id/read", auth, async (req, res) => {
  try {
    const notification = await Notification.findOneAndUpdate(
      {
        _id: req.params.id,
        $or: [{ userId: req.user._id }, { userId: null }],
      },
      { isRead: true },
      { new: true },
    )

    if (!notification) {
      return res.status(404).json({ success: false, message: "Notification not found" })
    }

    res.json({
      success: true,
      message: "Notification marked as read",
      notification,
    })
  } catch (error) {
    console.error("Mark notification as read error:", error)
    res.status(500).json({ success: false, message: "Server error" })
  }
})

module.exports = router
