const express = require("express")
const Report = require("../models/Report")
const { auth } = require("../middleware/auth")

const router = express.Router()

// Submit a report
router.post("/", auth, async (req, res) => {
  try {
    const { type, title, description, screenshotUrl } = req.body

    const report = new Report({
      type,
      title,
      description,
      screenshotUrl,
      reporterId: req.user._id,
      reporterName: req.user.name,
    })

    await report.save()

    res.status(201).json({
      success: true,
      message: "Report submitted successfully",
      report,
    })
  } catch (error) {
    console.error("Submit report error:", error)
    res.status(500).json({ success: false, message: "Server error" })
  }
})

// Get all reports (admin only)
router.get("/", auth, async (req, res) => {
  try {
    if (!req.user.isAdmin) {
      return res.status(403).json({ success: false, message: "Access denied" })
    }

    const reports = await Report.find().sort({ createdAt: -1 })
    res.json(reports)
  } catch (error) {
    console.error("Get reports error:", error)
    res.status(500).json({ success: false, message: "Server error" })
  }
})

// Update report status
router.put("/:id/status", auth, async (req, res) => {
  try {
    if (!req.user.isAdmin) {
      return res.status(403).json({ success: false, message: "Access denied" })
    }

    const { status } = req.body
    const report = await Report.findByIdAndUpdate(req.params.id, { status }, { new: true })

    if (!report) {
      return res.status(404).json({ success: false, message: "Report not found" })
    }

    res.json({
      success: true,
      message: "Report status updated",
      report,
    })
  } catch (error) {
    console.error("Update report status error:", error)
    res.status(500).json({ success: false, message: "Server error" })
  }
})

module.exports = router
