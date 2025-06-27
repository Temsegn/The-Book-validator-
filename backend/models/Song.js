const mongoose = require("mongoose")

const songSchema = new mongoose.Schema(
  {
    title: {
      type: String,
      required: true,
      trim: true,
    },
    singer: {
      type: String,
      required: true,
      trim: true,
    },
    lyrics: {
      type: String,
      required: true,
    },
    audioUrl: {
      type: String,
      default: "",
    },
    isVerified: {
      type: Boolean,
      default: false,
    },
    submittedBy: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
    },
  },
  {
    timestamps: true,
  },
)

// Index for search functionality
songSchema.index({ title: "text", singer: "text", lyrics: "text" })

module.exports = mongoose.model("Song", songSchema)
