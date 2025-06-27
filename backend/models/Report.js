const mongoose = require("mongoose")

const reportSchema = new mongoose.Schema(
  {
    type: {
      type: String,
      required: true,
      enum: ["book", "song"],
    },
    title: {
      type: String,
      required: true,
    },
    description: {
      type: String,
      required: true,
    },
    screenshotUrl: {
      type: String,
      required: true,
    },
    reporterId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },
    reporterName: {
      type: String,
      required: true,
    },
    status: {
      type: String,
      enum: ["pending", "reviewed", "resolved"],
      default: "pending",
    },
  },
  {
    timestamps: true,
  },
)

module.exports = mongoose.model("Report", reportSchema)
